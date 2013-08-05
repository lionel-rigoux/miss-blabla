class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  # GET /clients
  def index
    @clients = Client.all
  end

  # GET /clients/new
  def new
    @client = Client.new()
  end
  
  def show
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  def create    
    @client = Client.create(client_params.permit!)
    if @client.id
      flash[:notice] = 'Le contact a bien été ajouté à la base de données !'
        redirect_to clients_path
    else
        render action: 'new'
    end
  end

  # PUT /clients/1
  def update
      if @client.update(client_params.permit!)
        flash[:notice] = 'Le client a bien été modifié.'
        redirect_to @client
      else
        render action: 'edit'
      end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
    redirect_to clients_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id], include: [:agent])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params[:client]
    end
end
