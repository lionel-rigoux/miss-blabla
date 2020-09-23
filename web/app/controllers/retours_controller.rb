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
    params.require(:retour).permit!
    end

       def set_catalogue
      @catalogue = Modele.catalogue
      @couleurs = Hash[Couleur.pluck(:id,:nom)]
    end

    def set_retour
      @retour = Retour.where(id: params[:id]).includes(:quantite).first
    end

end
