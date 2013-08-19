class AgentsController < ApplicationController
  before_action :set_agent, only: [:show, :edit, :update, :destroy]

  # GET /agents
  def index
    @agents = Agent.all(order: :nom)
  end

  # GET /agents/new
  def new
    @agent = Agent.new(agent_params)
  end
  
  def show
  end

  # GET /agents/1/edit
  def edit
  end

  # POST /agents
  def create    
    @agent = Agent.create(agent_params.permit!)
    if @agent.id
      flash[:notice] = 'L\'agent a bien été ajouté à la base de données !'
        redirect_to agents_path
    else
        render action: 'new'
    end
  end

  # PUT /agents/1
  def update
      if @agent.update(agent_params.permit!)
        flash[:notice] = 'L\'agent a biet été modifié.'
        redirect_to @agent
      else
        render action: 'edit'
      end
  end

  # DELETE /agents/1
  def destroy
    @agent.destroy
    redirect_to agents_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent
      @agent = Agent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def agent_params
      params[:agent]
    end
end
