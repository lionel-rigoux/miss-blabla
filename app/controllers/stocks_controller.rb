class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  # GET /stocks
  # GET /stocks.json
  def index
    @productions=Production.all
    case params[:stock_mode] || 'reel'
    when 'reel'
      @stock = Stock.find_or_initialize_by_id(1)
    when 'net'
      @stock = Stock.find_or_initialize_by_id(1)
      Commande.en_preparation.includes(:quantite).each { |c|  @stock.quantite -= c.quantite }
    end
    @catalogue = Modele.catalogue.to_a
    @couleurs = Hash[Couleur.pluck(:id,:nom)]

  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
  end

  # GET /stocks/1/edit

  def edit
    @production = Production.find(params[:production])
    @stock=Stock.new(quantite: Quantite.new + @production.quantite)
    @catalogue = Modele.catalogue.to_a
    @couleurs = Hash[Couleur.pluck(:id,:nom)]

  end

  # POST /stocks
  # POST /stocks.json
  def create
    case params[:mode]

    when "production"
      @old_stock = Stock.find_or_initialize_by_id(1)
      @stock = Stock.new(stock_params)
      @production = Production.find(params[:production])

      if @stock.valid?
        @old_stock.quantite += @stock.quantite
        if @old_stock.save
          @production.commandes.update_all(production_id: nil, status: 2)
          @production.destroy
          redirect_to stocks_path
          return
        end
      else
        render 'edit'
        return
      end
    end
    redirect_to stocks_path

  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
     redirect_to stocks_path
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params[:stock].permit!
    end
end
