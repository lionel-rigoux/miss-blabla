class Agent < ActiveRecord::Base
  has_many :clients
  has_one :patron
    
end
