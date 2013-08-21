class ProductionsController < ApplicationController
  before_action :set_production, only: [:show, :edit, :update, :destroy]

  # GET /productions
  # GET /productions.json
  def index
    @commandes=Commande.find_all_by_status(0)
    @productions = Production.all   
  end

  # GET /productions/1
  # GET /productions/1.json
  def show
     @patron = Patron.first
     @production.update_quantite(@production.commandes)
      render 'show', layout: "printable"
   
  end

  # GET /productions/new
  def new
    
    production = Production.new
    if production.save
      production.quantite.init
      production.update_quantite(Commande.find_all_by_status(0))
      Commande.find_all_by_status(0).each {|c| c.update_status }
      production.quantite.save
    end
    redirect_to productions_path
    
  end

  # GET /productions/1/edit
  #def edit    
  #  Commande.find_all_by_status(0).each do |c|
  #    c.update_status
  #    c.production = @production
  #    c.save
  #  end
  #    redirect_to productions_path  
  #end
  
  def destroy
    Commande.where(production: @production).all.each do |commande|
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
