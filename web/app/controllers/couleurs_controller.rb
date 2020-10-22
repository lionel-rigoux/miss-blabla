class CouleursController < ApplicationController
  before_action :set_couleur, only: [:show, :edit, :update, :destroy]

  # GET /couleurs
  # GET /couleurs.json
  def index
    @couleurs = Couleur.all
  end

  # GET /couleurs/1
  # GET /couleurs/1.json
  def show
  end

  # GET /couleurs/new
  def new
    @couleur = Couleur.new
  end

  # GET /couleurs/1/edit
  def edit
  end

  # POST /couleurs
  # POST /couleurs.json
  def create
    @couleur = Couleur.new(couleur_params)
      if @couleur.valid? && @couleur.save
          redirect_to couleurs_path
        else
          render action: 'new'
      end
  end

  # PATCH/PUT /couleurs/1
  # PATCH/PUT /couleurs/1.json
  def update
      if @couleur.update(couleur_params)
          redirect_to couleurs_path
        else
          render action: 'edit'
       end
  end

  # DELETE /couleurs/1
  def destroy
    if @couleur.destroy
    redirect_to couleurs_url
    else
    render action: 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_couleur
      @couleur = Couleur.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def couleur_params
      params.require(:couleur).permit!
    end
end
