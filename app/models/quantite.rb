class Quantite < ActiveRecord::Base
  belongs_to :quantifiable, :polymorphic => true  
  serialize :detail, Hash
  
  after_initialize :init
  
  def init
    reset if self.detail.empty?
  end
  
  def reset
    self.detail = Hash.new { |h1,k1| h1[k1] = Hash.new { |h2,k2| h2[k2] = Hash.new {|h3,k3| h3[k3] = 0} } }
  end
     
  def modeles
    Modele.where(id: self.detail.keys).to_a
  end
  
  def versions(modele)
    if self.detail[modele.id.to_s]
      Version.find_all_by_id(self.detail[modele.id.to_s].keys)
    else
      []
    end
  end
    
  def method_missing(method_id,*args)
    if method_id.to_s.match(/detail\[(.*)\]\[(.*)\]\[(.*)\]$/)
      self.detail[$1][$2][$3].to_i
    end
  end
      
  
  def de(*args)
    if args[0].is_a? Modele
      versions(args[0]).collect {|v| de(v)}.sum
    elsif args[0].is_a? Version
      if args[1]
        (((self.detail[args[0].modele_id.to_s] || {})[args[0].id.to_s] || {})[args[1]] || 0 ).to_i
        #begin
        #self.detail[args[0].modele_id.to_s][args[0].id.to_s][args[1]].to_i 
        #rescue
        #self.detail[args[0].modele_id.to_s] = {args[0].id.to_s => { args[1] => "0"}}
        #0
        #end
      else
       args[0].modele.liste_taille.compact.collect {|t| de(args[0],t)}.sum
      end
    elsif args.empty?
      self.modeles.collect { |modele| self.de(modele)}.sum
    end
  end
  
  def +(other_quantite)
    new_quantite = Quantite.new
    new_modeles = (self.modeles + other_quantite.modeles).uniq
    new_modeles.each do |modele|
      new_versions = (self.versions(modele) + other_quantite.versions(modele)).uniq
      new_versions.each do |version|
        modele.liste_taille.compact.each do |t|
          total = self.de(version,t) + other_quantite.de(version,t)
          new_quantite.detail[modele.id.to_s][version.id.to_s][t] = total.to_s         
        end
      end
    end
    new_quantite
  end
  
  def -(other_quantite)
    
    new_modeles = (self.modeles + other_quantite.modeles).uniq
    new_modeles.each do |modele|
      new_versions = (self.versions(modele) + other_quantite.versions(modele)).uniq
      new_versions.each do |version|
        modele.liste_taille.compact.each do |t|
          total = self.de(version,t) - other_quantite.de(version,t)
          self.detail[modele.id.to_s][version.id.to_s][t] = total.to_s         
        end
      end
    end
    self
  end
  
  
  
  def reset
    self.detail = Hash.new { |h1,k1| h1[k1] = Hash.new { |h2,k2| h2[k2] = Hash.new {|h3,k3| h3[k3] = 0} } }
  end

end
