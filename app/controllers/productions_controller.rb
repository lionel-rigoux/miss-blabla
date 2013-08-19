class ProductionsController < ApplicationController
  before_action :set_production, only: [:show, :edit, :update, :destroy]

  # GET /productions
  # GET /productions.json
  def index
    @commandes=Commande.find_all_by_status('0')
    @productions = Production.all    
  end

  # GET /productions/1
  # GET /productions/1.json
  def show
     @patron = Patron.first
      render 'show', layout: "printable"
   
  end

  # GET /productions/new
  def new
    production = Production.create()
    if production.id
      Commande.find_all_by_status('0').each do |c|
        c.status= 1
        c.production = production
        c.save
      end
      redirect_to productions_path  
    else
      redirect_to productions_path
    end
  end

  # GET /productions/1/edit
  def edit    
    Commande.find_all_by_status('0').each do |c|
      c.status= 1
      c.production = @production
      c.save
    end
      redirect_to productions_path  
   
    
  end

  # POST /productions
  # POST /productions.json
  def create
    @production = Production.new(production_params)

    respond_to do |format|
      if @production.save
        format.html { redirect_to @production, notice: 'Production was successfully created.' }
        format.json { render action: 'show', status: :created, location: @production }
      else
        format.html { render action: 'new' }
        format.json { render json: @production.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /productions/1
  # PATCH/PUT /productions/1.json
  def update
    respond_to do |format|
      if @production.update(production_params)
        format.html { redirect_to @production, notice: 'Production was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @production.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /productions/1
  # DELETE /productions/1.json
  def destroy
    @production.destroy
    respond_to do |format|
      format.html { redirect_to productions_url }
      format.json { head :no_content }
    end
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
