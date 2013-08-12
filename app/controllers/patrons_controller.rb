class PatronsController < ApplicationController
  before_action :set_patron, only: [:show, :edit, :update, :destroy]

  # GET /patrons
  # GET /patrons.json
  def index
    @patron = Patron.first
  end

  # GET /patrons/1
  # GET /patrons/1.json
  def show
  end

  # GET /patrons/new
  def new
    @patron = Patron.new
  end

  # GET /patrons/1/edit
  def edit
  end

  # PATCH/PUT /patrons/1
  # PATCH/PUT /patrons/1.json
  def update
      if @patron.update(patron_params)
        redirect_to patrons_path
      else
        render action: 'edit' 
      end
  end

  # DELETE /patrons/1
  # DELETE /patrons/1.json
  def destroy
    @patron.destroy
    respond_to do |format|
      format.html { redirect_to patrons_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patron
      @patron = Patron.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patron_params
      params[:patron].permit!
    end
    def agent_params
      params[:agent].permit!
    end
end
