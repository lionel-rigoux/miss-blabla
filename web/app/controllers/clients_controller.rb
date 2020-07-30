class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  # GET /clients
  def index
    @clients = Client.all(order: :societe)
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
    @client = Client.new(client_params)
    if @client.save
        redirect_to clients_path
    else
        render action: 'new'
    end
  end

  # PUT /clients/1
  def update
      if @client.update(client_params)
        redirect_to @client
      else
        render action: 'edit'
      end
  end

  # DELETE /clients/1
  def destroy
    if @client.destroy
    redirect_to clients_url
    else
    render action: 'show'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id], include: [:agent])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params[:client].permit!
    end
end
