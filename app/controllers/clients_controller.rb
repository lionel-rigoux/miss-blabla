class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  # GET /clients
  def index
    @clients = Client.all_clients
    @agents  = Client.all_agents
  end

  # GET /clients/new
  def new
    @client = Client.new(client_params)
  end
  
  def show
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  def create    
    @client = Client.create(client_params)
    if @client.id
      flash[:notice] = 'Le contact a bien été ajouté à la base de données !'
        redirect_to clients_path
    else
        render action: 'new'
    end
  end

  # PUT /clients/1
  def update
      if @client.update(client_params)
        flash[:notice] = 'Client was successfully updated.'
        redirect_to @client
      else
        render action: 'edit'
      end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
    flash[:notice] = 'Le contact a été supprimé.'
    redirect_to clients_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params[:client].permit!
    end
end
