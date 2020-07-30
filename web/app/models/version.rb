# == Schema Information
#
# Table name: versions
#
#  id            :integer          not null, primary key
#  modele_id     :integer
#  couleurs_1_id :integer
#  couleurs_2_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Version < ActiveRecord::Base

    # RELATIONS
    belongs_to :modele

    # VALIDATIONS
    validates_presence_of :modele_id, :couleurs_1_id

    # METHODS
    def couleur_1
        Couleur.find(self.couleurs_1_id).nom if self.couleurs_1_id
    end

    def couleur_2
        Couleur.find(self.couleurs_2_id).nom if self.couleurs_2_id
    end

    def couleurs
        [couleur_1, couleur_2].compact.join('/')
    end
end
