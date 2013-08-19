class Production < ActiveRecord::Base
  has_many :commandes
  
  def date
    self.created_at.strftime('%d/%m/%Y')
  end
  
  def quantites_totale
    q=Hash.new(0)
    self.commandes.each do |c| 
      modeles.each do |m|
        q[m.id] += c.quantites_totale[m.id]
      end
    end
    q
  end
  
  def quantite(modele,version,t)
    q=0
    self.commandes.each do |commande|
       q+=eval(commande.quantite_version(version)[t])
    end
    q
  end
  
  def quantite_version(version)
    q=0
    self.commandes.each do |commande|
      q+=commande.quantite_version(version).values.map {|v| eval(v)}.sum
    end
    q
  end
  
  def total
    q=0
    self.commandes.each do |commande|
      q+=commande.total
    end
    q
  end
  
  def modeles
    liste_modele = []
    self.commandes.each do |commande|
      commande.ligne_commandes.each do |ligne|
        liste_modele += [ligne.version.modele]
      end
    end
    liste_modele.uniq
  end
end
