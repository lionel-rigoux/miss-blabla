class ModelesController < ApplicationController
  before_action :set_modele, only: [:show, :edit, :update, :destroy]

  # GET /modeles
  # GET /modeles.json
  def index
    @modeles = Modele.includes(:versions).order(:numero).load
    @couleurs = Hash[Couleur.pluck(:id,:nom)]
  end

  # GET /modeles/1
  # GET /modeles/1.json
  def show
  end

  # GET /modeles/new
  def new
    @modele = Modele.new(versions: [Version.new])
  end

  # GET /modeles/1/edit
  def edit
  end

  # POST /modeles
  # POST /modeles.json
  def create
    @modele = Modele.new(modele_params)

      if @modele.save
        redirect_to modele_path(@modele)
      else
        render action: 'new'
      end
  end

  # PATCH/PUT /modeles/1
  # PATCH/PUT /modeles/1.json
  def update
      if @modele.update(modele_params)
        redirect_to modele_path(@modele)
      else
        render action: 'edit'
      end

  end

  # DELETE /modeles/1
  # DELETE /modeles/1.json
  def destroy
    @modele.destroy
    redirect_to modeles_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modele
      @modele = Modele.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modele_params
      params.require(:modele).permit!
    end
end
