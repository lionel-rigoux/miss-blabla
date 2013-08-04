class Client < ActiveRecord::Base
  def self.all_clients
    self.where('niveau="client"') || {}
  end
  
  def self.all_agents
    self.where('niveau="agent"') || {}
  end
  
end
