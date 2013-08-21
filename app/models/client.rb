class Client < ActiveRecord::Base
 belongs_to :agent
  
  
 after_initialize :init

 def init
   self.has_tva = true if self.has_tva.nil?
 end
 
 
end
