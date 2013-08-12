class Modele < ActiveRecord::Base
  has_many :versions, :dependent => :destroy
  accepts_nested_attributes_for :versions, :allow_destroy => true
    
    def with_blank_version(n = 1) n.times do
     self.versions.build
     end
    self
    end
    
    def tailles_possibles
      ['XS','S','M','L','XL','XXL','XXXL']
    end 
    
    def nombre_versions
      self.versions.count
    end
    
    def liste_versions
      versions = self.versions.collect {|v| v.couleurs}
      versions.join(', ')
    end
end
