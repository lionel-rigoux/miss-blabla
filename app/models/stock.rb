class Stock < ActiveRecord::Base
  has_one :quantite, as: :quantifiable, :dependent => :delete
  accepts_nested_attributes_for :quantite
  
  
  after_initialize :init
  
  def init
    self.quantite ||= Quantite.new
  end
  
   
    
  def add_production(production_id,quantite_a_ajouter)
    self.update(quantite: self.quantite + quantite_a_ajouter)
    
    production = Production.find_by_id(production_id)
    production.commandes.each do |commande|
      commande.update_status
      commande.update(production: nil)
    end
    production.destroy
        
  end
  
  def modeles
    self.quantite.modeles
  end
  
  def versions(modele)
    self.quantite.versions(modele)
  end
  
  def quantite_de(*args)
    self.quantite.de(*args)
  end
  
  def prendre(commande)
    self.quantite = self.quantite - commande.quantite
  end
  
  
   def deficit(commandes=Commande.find_all_by_status(3))     
    d = Quantite.new.detail
    Modele.all.each do |modele|
      modele.versions.each do |version|
        modele.liste_taille.each do |t|
          if t
            ordered=commandes.collect {|c| c.quantite(version,t)}.sum
            in_stock = self.quantite_de(version,t)
            if ordered > in_stock
             d[modele.id][version.id][t] =  ordered - in_stock
           end
          end
        end
      end
    end
    d
  end
end
