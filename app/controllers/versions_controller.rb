class VersionsController < ApplicationController
  before_action :set_version, only: [:show, :edit, :update, :destroy]

  # GET /versions
  # GET /versions.json
  def index
    @versions = Version.all
  end

  # GET /versions/1
  # GET /versions/1.json
  def show
  end

  # GET /versions/new
  def new
    @version = Version.new
    @modele = Modele.find(params[:modele_id])
  end

  # GET /versions/1/edit
  def edit
    @modele = @version.modele
  end

  # POST /versions
  # POST /versions.json
  def create
    @version = Version.new(version_params)
      if @version.save
        redirect_to modele_path(@version.modele)
      else
        render action: 'new'
      end
  end

  # PATCH/PUT /versions/1
  # PATCH/PUT /versions/1.json
  def update
      if @version.update(version_params)
        redirect_to modele_path(@version.modele)
      else
        render action: 'edit'
      end
  end

  # DELETE /versions/1
  # DELETE /versions/1.json
  def destroy
    @version.destroy
    redirect_to modele_path(@version.modele)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_version
      @version = Version.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def version_params
      params[:version].permit!
    end
end
