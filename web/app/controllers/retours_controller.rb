class RetoursController < ApplicationController

  before_action :set_retour, only: [:show, :edit, :update, :destroy]
  before_action :set_catalogue, only: [:show, :create, :edit, :update]

  def index
    @retours = Retour.includes(:client)
    render 'index'
  end

  def new
    @retour = Retour.new
  end

  def create
    @retour = Retour.new(retour_params)
    if @retour.quantite.nil?
      if @retour.client_id
        @retour.de_client(Client.find(@retour.client_id))
        set_catalogue
      end
      render action: 'edit'
    else
      if @retour.save
        redirect_to retour_path(@retour)
      else
        render action: 'new'
      end
    end
  end

 def show
    if params[:mode] == "avoir"
      @patron=Patron.first
      render 'show_avoir', layout: "printable"
    elsif params[:mode] == "solde"
      render 'show_validation'
    else
      render 'show'
    end
 end

 def edit
   @retour.quantite += Retour.new.de_client(Client.find(@retour.client_id)).quantite
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
      params[:retour].permit! if params[:retour]
    end

       def set_catalogue
      @catalogue = Modele.catalogue
      @couleurs = Hash[Couleur.pluck(:id,:nom)]
    end

    def set_retour
      @retour = Retour.where(id: params[:id]).includes(:quantite).first
    end

end