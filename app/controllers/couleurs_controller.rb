class CouleursController < ApplicationController
  before_action :set_couleur, only: [:show, :edit, :update, :destroy]

  # GET /couleurs
  # GET /couleurs.json
  def index
    @couleurs = Couleur.liste
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

      if @couleur.save
          redirect_to couleurs_path
      end
  end

  # PATCH/PUT /couleurs/1
  # PATCH/PUT /couleurs/1.json
  def update
      if @couleur.update(couleur_params)
        redirect_to couleurs_path
       end
  end

  # DELETE /couleurs/1
  # DELETE /couleurs/1.json
  def destroy
    @couleur.destroy
    respond_to do |format|
      format.html { redirect_to couleurs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_couleur
      @couleur = Couleur.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def couleur_params
      params.require(:couleur).permit(:nom)
    end
end
