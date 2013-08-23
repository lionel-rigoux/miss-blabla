class CommandesController < ApplicationController
  before_action :set_commande, only: [:show, :edit, :update, :destroy]

  # GET /commandes
  # GET /commandes.json
  def index
    
    @commandes = Commande.all
  end

  # GET /commandes/1
  # GET /commandes/1.json
  def show
    @modeles=Modele.all(order: 'numero ASC')
    @patron=Patron.first
    if params[:mode] == "livraison"
      render 'show_livraison', layout: "printable"
    elsif params[:mode] == "facture"
      render 'show_facture', layout: "printable"
    elsif params[:mode] == "validation"
      @commande.status=3
      render 'show_validation'
     else
      render 'show'
    end
  end

  

  # GET /commandes/new
  def new
    @commande = Commande.new
  end

  # GET /commandes/1/edit
  def edit
  end

  # POST /commandes
  # POST /commandes.json
  def create
    @commande = Commande.new(commande_params)
    respond_to do |format|
      if @commande.save
        format.html { redirect_to @commande, notice: 'Commande was successfully created.' }
        format.json { render action: 'show', status: :created, location: @commande }
      else
        format.html { render action: 'new' }
        format.json { render json: @commande.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commandes/1
  # PATCH/PUT /commandes/1.json
  def update    
    case commande_params[:status].to_i
      
    when 0
      @commande.update(commande_params)
    when 1
      @commande.update(commande_params)
    when 2
        @commande.update(commande_params)
    when 3
      commande_params[:date_facturation] = Time.now
      commande_params[:numero_facture] = Commande.nouveau_numero
      if @commande.update(commande_params)
        stock = Stock.find_or_initialize_by_id(1)
        stock.prendre(@commande)
        stock.quantite.save      
      end
    end
    redirect_to @commande
  end

  # DELETE /commandes/1
  # DELETE /commandes/1.json
  def destroy
    @commande.destroy
    respond_to do |format|
      format.html { redirect_to commandes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commande
      @commande = Commande.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commande_params
      params[:commande].permit!
    end
end
