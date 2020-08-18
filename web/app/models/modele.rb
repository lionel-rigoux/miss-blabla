# == Schema Information
#
# Table name: modeles
#
#  id         :integer          not null, primary key
#  numero     :string(255)      not null
#  nom        :string(255)      not null
#  taille_min :string(255)
#  taille_max :string(255)
#  prix       :float            not null
#  created_at :datetime
#  updated_at :datetime
#

class Modele < ApplicationRecord

  # RELATIONS
  has_many :versions, :dependent => :destroy
  accepts_nested_attributes_for :versions, :allow_destroy => true

  # VALIDATION
  validates_presence_of :numero, :nom, :prix
  validates_uniqueness_of :numero
  validates_numericality_of :prix, greater_than: 0.1
  validates_uniqueness_of :numero
  validate :uniqueness_of_versions

  def uniqueness_of_versions
    if self.versions.uniq.size != self.versions.size
      self.errors.add(:versions)
   end
  end

  before_validation :remove_comma
  def remove_comma
    self[:prix] = self.read_attribute_before_type_cast('prix').to_s.gsub(',', '.').to_f
  end

  # SCOPES
  scope :catalogue, -> {order(:numero).includes(:versions)}

  # METHODS

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
