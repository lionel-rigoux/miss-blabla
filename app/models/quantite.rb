class Quantite < ActiveRecord::Base
  belongs_to :quantifiable, :polymorphic => true  
  serialize :detail, Hash
  
  after_initialize do |quantite|
    if quantite.detail.empty?
      quantite.detail = Hash.new { |h1,k1| h1[k1] = Hash.new { |h2,k2| h2[k2] = Hash.new {|h3,k3| h3[k3] = 0} } }
    end
  end
  
  def modeles
    Modele.find_all_by_id(self.detail.keys)
  end
  
  def versions(modele)
    modele.versions
  end
  
  def de(*args)
    if args[0].is_a? Modele
      versions(args[0]).collect {|v| de(v)}.sum
    elsif args[0].is_a? Version
      if args[1]
        self.detail[args[0].modele_id][args[0].id][args[1]]
      else
       args[0].modele.liste_taille.compact.collect {|t| de(args[0],t)}.sum
      end
    end
  end
  
  def +(quantite)
    quantite.detail.each do |modele_id,versions|
      versions.each do |version_id,tailles|
        taille.each do |t,combien|
          self.detail[modele_id][version_id][t] += combien
        end
      end
    end
    self
  end
  
  def -(quantite)
    quantite.detail.each do |modele_id,versions|
      versions.each do |version_id,tailles|
        taille.each do |t,combien|
          self.detail[modele_id][version_id][t] -= combien
        end
      end
    end
    self
  end
  
  
end
