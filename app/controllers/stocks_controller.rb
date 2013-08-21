class StocksController < ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]

  # GET /stocks
  # GET /stocks.json
  def index
    @productions=Production.all
    @stock = Stock.find_or_initialize_by_id(1)
    if params[:stock_mode] == 'net'
      Commande.find_all_by_status(2).each { |c| @stock.prendre(c) }
    end
    
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
  end

  # POST /stocks
  # POST /stocks.json
  def create
    case stock_params[:mode]
    when "production"
      @old_stock = Stock.find_or_initialize_by_id(1)
      quantite = Quantite.new(stock_params[:quantite_attributes].permit!)
      @old_stock.add_production(stock_params[:production],quantite) 
      @old_stock.quantite.save
    end
    redirect_to stocks_path
    
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    puts "UPDATE"
    
     redirect_to stocks_path    
  end

 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params[:stock]
    end
end
