class AgentsController < ApplicationController
  before_action :set_agent, only: [:show, :edit, :update, :destroy]

  # GET /agents
  def index
    @agents = Agent.all().order(:nom)
  end

  # GET /agents/new
  def new
    @agent = Agent.new
  end

  def show
    if @agent.patron
      redirect_to patrons_path
    end
  end

  # GET /agents/1/edit
  def edit
  end

  # POST /agents
  def create
    @agent = Agent.new(agent_params)
    if @agent.save
      redirect_to agents_path
    else
      render action: 'new'
    end
  end

  # PUT /agents/1
  def update
      if @agent.update(agent_params)
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
      @agent = Agent.includes(:clients, :clients => :commandes).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def agent_params
      params[:agent].permit!
    end
end
