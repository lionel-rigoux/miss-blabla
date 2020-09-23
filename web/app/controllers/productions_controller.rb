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
     @patron = Patron.find_or_initialize_by(id: 1)
     #@production.up_to_date
     @catalogue = Modele.catalogue
     @couleurs = Hash[Couleur.pluck(:id,:nom)]
     filename = "production_" + @production.date
     render pdf: filename,
       disposition: 'inline',                 # default 'inline'
       template:    'productions/show',
       layout:      'printable',
       show_as_html: params[:debug].present?

  end

  # GET /productions/new
  def new
    pre_orders = Commande.en_avance
    quantite= pre_orders.to_a.inject(Quantite.new) {|q,c| q+c.quantite}
    production = Production.new(quantite: quantite)
    if production.save
      pre_orders.update_all(status: 1, production_id: production.id)
    end
    redirect_to productions_path

  end



  def destroy
    @production.commandes.update_all(status: 0, production_id: nil)
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
      params.require(:production).permit!
    end
end
