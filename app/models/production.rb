class Production < ActiveRecord::Base
  has_many :commandes
  has_one :quantite, as: :quantifiable
  
  
  after_initialize do |prod|
    prod.update_quantite!
  end
  
  
  def update_quantite
    self.quantite.reset
    Commande.where(production: self).each do |c|
      self.quantite = self.quantite +  c.quantite     
    end
    self
  end
  
  def update_quantite!
    update_quantite
    self.quantite.save
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
