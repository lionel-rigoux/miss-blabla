class Modele < ActiveRecord::Base
  has_many :versions, :dependent => :destroy
  accepts_nested_attributes_for :versions, :allow_destroy => true
  before_validation :remove_comma
  
  validates :numero, :nom, :prix, presence: true

    def remove_comma
      @attributes["prix"].gsub!(',', '.') if @attributes["prix"]
    end
      
    def with_blank_version(n = 1) n.times do
     self.versions.build
     end
    self
    end
    
    def tailles_possibles
      ['XS','S','M','L','XL','XXL','XXXL']
    end
    
    def liste_taille
      tailles_possibles.collect {|t| self.has_taille?(t) ? t : nil}
    end
      
    
    def nombre_versions
      self.versions.count
    end
    
    def liste_versions
      versions = self.versions.collect {|v| v.couleurs}
      versions.join(', ')
    end
    
    def has_taille?(t)
      idx_1=self.tailles_possibles.index(self.taille_min)
      idx_2=self.tailles_possibles.index(self.taille_max)
      idx_min = [idx_1,idx_2].min
      idx_max = [idx_1,idx_2].max
      
     (self.tailles_possibles.index(t) >= idx_min) and (self.tailles_possibles.index(t) <= idx_max)
    end
    
    
end
