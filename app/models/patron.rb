class Patron < ActiveRecord::Base
  belongs_to :agent
  accepts_nested_attributes_for :agent
  
  def email
    self.agent.email
  end
  
  def telephone
    self.agent.telephone
  end
  
end
