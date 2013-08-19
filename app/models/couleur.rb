class Couleur < ActiveRecord::Base
  validates :nom, presence: true
  
  def self.liste
    self.all(:order => "nom ASC")
  end
end
