class QuantitesController < ApplicationController
  before_action :set_quantite, only: [:show, :edit, :update, :destroy]

  # GET /quantites
  # GET /quantites.json
  def index
    @quantites = Quantite.all
  end

  # GET /quantites/1
  # GET /quantites/1.json
  def show
  end

  # GET /quantites/new
  def new
    @quantite = Quantite.new
  end

  # GET /quantites/1/edit
  def edit
  end

  # POST /quantites
  # POST /quantites.json
  def create
    @quantite = Quantite.new(quantite_params)

    respond_to do |format|
      if @quantite.valid? && @quantite.save
        format.html { redirect_to @quantite, notice: 'Quantite was successfully created.' }
        format.json { render action: 'show', status: :created, location: @quantite }
      else
        format.html { render action: 'new' }
        format.json { render json: @quantite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quantites/1
  # PATCH/PUT /quantites/1.json
  def update
    respond_to do |format|
      if @quantite.update(quantite_params)
        format.html { redirect_to @quantite, notice: 'Quantite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @quantite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quantites/1
  # DELETE /quantites/1.json
  def destroy
    @quantite.destroy
    respond_to do |format|
      format.html { redirect_to quantites_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quantite
      @quantite = Quantite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quantite_params
      params.require(:quantite).permit!
    end
end
