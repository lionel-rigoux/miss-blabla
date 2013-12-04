class CommandesController < ApplicationController
  before_action :set_commande, only: [:show, :edit, :update, :destroy]
  before_action :set_catalogue, only: [:show, :new, :edit, :update]

  # GET /commandes
  # GET /commandes.json
  def index
    if params[:commande_status].blank?
      @commandes = Commande.includes(:client)
    else
      @commandes = Commande.includes(:client).where(status: params[:commande_status].to_i)
    end
    @commandes.order(params[:commande_order])

    @quantite = Hash[Quantite.where(quantifiable_id: @commandes.collect {|c| c.id}).pluck(:quantifiable_id,:total)]

  end

  # GET /commandes/1
  # GET /commandes/1.json
  def show
    #@modeles=Modele.all(order: 'numero ASC')
    @commande.quantite
    @patron=Patron.first
    if params[:mode] == "livraison"
      render 'show_livraison', layout: "printable"
    elsif params[:mode] == "facture"
      render 'show_facture', layout: "printable"
    elsif params[:mode] == "validation"
      @commande.status=3
      render 'show_validation'
     else
      render 'show'
    end
  end



  # GET /commandes/new
  def new
    @commande = Commande.new.prepare
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
        ok= @commande.update(commande_params)
        if ok
          stock = Stock.find_or_initialize_by_id(1)
          stock -= @commande
          unless stock.save
            @commande.status -= 1
            @commande.save
            ok = false
          end
        end
      end
    if ok
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
      @commande = Commande.where(id: params[:id]).includes(:quantite).first
    end

    def set_catalogue
      @catalogue = Modele.catalogue
      @couleurs = Hash[Couleur.pluck(:id,:nom)]
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def commande_params
      params[:commande].permit! if params[:commande]
    end
end
