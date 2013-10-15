class ProductionsController < ApplicationController
  before_action :set_production, only: [:show, :edit, :update, :destroy]

  # GET /productions
  # GET /productions.json
  def index
    @commandes_0=Commande.where(status: 0).count
    @productions = Production.all
  end

  # GET /productions/1
  # GET /productions/1.json
  def show
     @patron = Patron.find_or_initialize_by_id(1)
     #@production.up_to_date
     @production.quantite.trimed
     render 'show', layout: "printable"

  end

  # GET /productions/new
  def new
    production = Production.create!(quantite: Quantite.new)
    Commande.en_avance.each do |commande|
        production += commande
        if production.save
          commande.update_status
          commande.update(production: production)
        end
    end
    redirect_to productions_path

  end



  def destroy
    @production.commandes.each do |commande|
      commande.update(status: 0, production: nil)
    end
    @production.destroy
    redirect_to productions_path

  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_production
      @production = Production.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def production_params
      params[:production]
    end
end
