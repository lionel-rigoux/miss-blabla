class CommandesController < ApplicationController
  before_action :set_commande, only: [:show, :edit, :update, :destroy]

  # GET /commandes
  # GET /commandes.json
  def index
    if params[:commande_status].blank?
      @commandes = Commande.includes(:client, :quantite).load
    else
      @commandes = Commande.includes(:client, :quantite).where(status: params[:commande_status].to_i).load
    end
    @commandes.sort_by!  { |c| c.send(params[:commande_order] || 'societe')}


    #@sorted_by = params[:sorted_by] || 'societe'
    #@commandes = Commande.includes(:client, :quantite).load.sort_by!  { |c| c.send(@sorted_by)}

  end

  # GET /commandes/1
  # GET /commandes/1.json
  def show
    #@modeles=Modele.all(order: 'numero ASC')
    @commande.quantite.trimed
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
    @commande = Commande.new()
  end

  # GET /commandes/1/edit
  def edit
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
      @commande = Commande.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commande_params
      params[:commande].permit! if params[:commande]
    end
end
