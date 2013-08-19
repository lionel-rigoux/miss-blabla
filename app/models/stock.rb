class Stock < ActiveRecord::Base
  has_one :quantite, as: :quantifiable
  
  def self.prepare()
    s=self.find_or_initialize_by_id(1) 
    s.quantite = Quantite.new if s.quantite.nil?
    s
  end
   
    
  def add_production(production_id,quantite_a_ajouter)
    production = Production.find_by_id(production_id)
    new_detail = self.quantite.detail
    quantite_a_ajouter.each do |de,combien|
      de.match(/de_(?<modele_id>.+)_(?<version_id>.+)_(?<taille>.+)/)
      modele_id,version_id,taille=[eval($1),eval($2),$3]    
      new_detail[modele_id][version_id][taille] += eval(combien)      
    end
    self.quantite.update(detail: new_detail)
    
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
    new_detail = self.quantite.detail
    commande.modeles.each do |modele|
      modele.versions.each do |version|
        modele.liste_taille.compact.each do |t|
          new_detail[modele.id][version.id][t] -= commande.quantite(version,t)
        end
      end
    end
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
