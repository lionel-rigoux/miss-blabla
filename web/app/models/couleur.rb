# == Schema Information
#
# Table name: couleurs
#
#  id         :integer          not null, primary key
#  nom        :string(255)      not null
#  saison_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Couleur < ApplicationRecord

  # VALIDATION
  validates_presence_of :nom
  validates_uniqueness_of :nom

  # SCOPE
  default_scope { order(:nom) }

  # destruction
  before_destroy :ensure_is_in_no_versions

  def ensure_is_in_no_versions
     if Version.where("couleurs_1_id = ? OR couleurs_2_id = ?", self.id,  self.id).present?
       self.errors.add(:couleurs,"Impossible de suppirmer. Cette couleur est utilisée dans le catalogue.")
       throw :abort
     end
   end

end
