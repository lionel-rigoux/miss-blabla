class CommandesController < ApplicationController
  before_action :set_commande, only: [:show, :edit, :update, :destroy]
  before_action :set_catalogue, only: [:show, :new, :create, :edit, :update, :index]

  # GET /commandes
  # GET /commandes.json
  def index

    @commandes = Commande.includes(:quantite,:client)
    @commandes = @commandes.where(status: params[:commande_status].to_i) unless params[:commande_status].blank?

    #@commandes.sort_by { |c| c.send(params[:commande_order] || 'societe')}
    order_value = params[:commande_order] || 'societe'
    @commandes = @commandes.sort_by(&order_value.to_sym)
    #if params[:factures] == 'pro'
   #    @patron=Patron.first
   #   @commandes = @commandes.where(status: 2)
  #    render 'show_all_factures', layout: "printable"
  #  else
      render 'index'
   # end

  end

  # GET /commandes/1
  # GET /commandes/1.json
  def show
    #@modeles=Modele.all(order: 'numero ASC')
    @patron=Patron.first
    if params[:mode] == "livraison"
      filename = "bon-livraison_" + @commande.numero_commande
      render pdf: filename,
        disposition: 'inline',                 # default 'inline'
        template:    'commandes/show_livraison',
        layout:      'printable',
        show_as_html: params[:debug].present?
    elsif params[:mode] == "facture"
      if @commande.status < 2
        filename = "pro-forma_" + @commande.numero_commande
      else
        filename = "facture_" + @commande.numero_facture
      end
      render pdf: filename,
        disposition: 'inline',                 # default 'inline'
        template:    'commandes/show_facture',
        layout:      'printable',
        show_as_html: params[:debug].present? #true
    elsif params[:mode] == "validation"
      @commande.status=3
      @avoir = @commande.avoirs_en_attente.where(status: 0).to_a.sum(&:total)
      render 'show_validation'
     else
      render 'show'
    end
  end



  # GET /commandes/new
  def new
    if params[:mode] == "print"
      filename = "bon-commande"
      render pdf: filename,
        disposition: 'inline',                 # default 'inline'
        template:    'commandes/new_print',
        layout:      'printable',
        show_as_html: params[:debug].present?
    else
      @commande = Commande.new.prepare
      render 'new'
    end
  end

  # GET /commandes/1/edit
  def edit
    q_new = Commande.new.prepare.quantite
    q_new.id = @commande.quantite.id
    @commande.quantite += q_new
    #sorted_list = @catalogue.collect(&:id)
    #@commande.quantite.detail.sort {|a,b| sorted_list.index(a) <=> sorted_list.index(b)}
  end

  # POST /commandes
  # POST /commandes.json
  def create
    @commande = Commande.new(commande_params)
      if @commande.save
        render 'show'
      else
        render 'edit'
      end
  end

  # PATCH/PUT /commandes/1
  # PATCH/PUT /commandes/1.json
  def update
      case commande_params[:status].to_i
      when 0
        ok=@commande.update(commande_params)
      when 1
        ok=@commande.update(commande_params)
      when 2
        ok=@commande.update(commande_params)
      when 3
        commande_params[:date_facturation] = Time.now
        commande_params[:numero_facture] = Commande.nouveau_numero
        commande_params[:status] = 3
        ok= @commande.update(commande_params)
        if !ok
          @commande.status -= 1
          render action: 'show_validation' and return

          #set_commande
          #render action: 'show_facture', layout: "printable" and return
        end
        #  stock = Stock.find_or_initialize_by_id(1)
        #  stock -= @commande
        #  unless stock.save
        #    @commande.status -= 1
        #    @commande.save
        #    ok = false
        #  end
        #end
      end
    if ok
      @commande.avoirs_en_attente.update_all(status: 1)
      redirect_to @commande
    else
      render action: 'edit'
    end

  end

  # DELETE /commandes/1
  # DELETE /commandes/1.json
  def destroy
    @commande.destroy
    redirect_to commandes_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commande
      @commande = Commande.where(id: params[:id]).includes(:quantite, :client).first
      if @commande.status == 2
        @commande.update(status: 3)
      end
    end

    def set_catalogue
      @catalogue = Modele.catalogue
      @couleurs = Hash[Couleur.pluck(:id,:nom)]
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def commande_params
      #params[:commande].permit! if params[:commande]
      params.require(:commande).permit!

    end
end
