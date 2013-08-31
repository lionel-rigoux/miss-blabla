# == Schema Information
#
# Table name: couleurs
#
#  id         :integer          not null, primary key
#  nom        :string(255)
#  saison_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Couleur < ActiveRecord::Base

  # VALIDATION
  validates_presence_of :nom
  validates_uniqueness_of :nom

  # SCOPE
  default_scope order(:nom)

end
