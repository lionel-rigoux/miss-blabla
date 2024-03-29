class RetoursController < ApplicationController

  before_action :set_retour, only: [:show, :edit, :update, :destroy]
  before_action :set_catalogue, only: [:show, :create, :edit, :update]
  before_action :set_clients, only: [:new, :create, :edit]

  def index
    @retours = Retour.includes(:commande => :client)
    render 'index'
  end

  def new
    @retour = Retour.new
    @client = Client.new
  end

  def create
    @retour = Retour.new(retour_params)

    if params[:client_id].present?
      @client = Client.find(params[:client_id])
      @commandes = Commande.where(client_id: params[:client_id]).where(status: [3,4])
    else
      @client = Client.new
    end
    if @retour.quantite.nil?
      if @retour.commande_id
        @retour.de_commande(Commande.find(@retour.commande_id))
        set_catalogue
      end
      render action: 'edit'
    else
      if @retour.valid? && @retour.save
        redirect_to retour_path(@retour)
      else
        render action: 'new'
      end
    end
  end

 def show
    if params[:mode] == "avoir"
      @patron=Patron.first
      filename = "avoir_" + @retour.numero_avoir
      render pdf: filename,
        disposition: 'inline',                 # default 'inline'
        template:    'retours/show_avoir',
        layout:      'printable',
        show_as_html: params[:debug].present?

    elsif params[:mode] == "solde"
      render 'show_validation'
    else
      render 'show'
    end
 end

 def edit
   q_new = Retour.new.de_commande(Commande.find(@retour.commande_id)).quantite
   q_new += @retour.quantite
   @retour.quantite.detail = q_new.detail
   @commandes = Commande.where(client_id: @retour.client.id).where(status: [3,4])
 end

 def update
      if @retour.update(retour_params)
        redirect_to retour_path(@retour)
      else
        render action: 'edit'
      end
  end

  def destroy
    @retour.destroy
    redirect_to retours_url
  end


  def retour_params
    params.require(:retour).permit!
  end

  def set_catalogue
      @catalogue = Modele.catalogue
      @couleurs = Hash[Couleur.pluck(:id,:nom)]
  end

  def set_retour
      @retour = Retour.where(id: params[:id]).includes(:quantite, :commande => :client).first
      @client = @retour.client
  end

  def set_clients
    @clients = Client.where(id: Commande.where(status: [3,6]).pluck(:client_id))
  end
end
