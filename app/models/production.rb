class Production < ActiveRecord::Base
  has_many :commandes
  has_one :quantite, as: :quantifiable, :dependent => :delete
  

  after_initialize :init
  
  def init
    self.quantite ||= Quantite.new
  end
  
  def update_quantite(commandes)
    quantite.reset
    commandes.each do |c|        
      c.production = self
      c.save
      self.quantite = self.quantite + c.quantite
    end
  end
  
  def date
    self.created_at.strftime('%d/%m/%Y')
  end
  
  
  def modeles
    quantite.modeles
  end
  
  def versions(modele)
    quantite.versions(modele)
  end
      
end
