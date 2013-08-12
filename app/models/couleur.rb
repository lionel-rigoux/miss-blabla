class Couleur < ActiveRecord::Base
  def self.liste
    self.all(:order => "nom ASC")
  end
end
