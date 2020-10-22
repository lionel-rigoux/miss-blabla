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

class Version < ApplicationRecord

    # RELATIONS
    belongs_to :modele

    # VALIDATIONS
    validates_presence_of :modele_id, :couleurs_1_id

    # destruction
    before_destroy :ensure_is_in_no_order

    def ensure_is_in_no_order
       if Commande.includes(:quantite).all.to_a.select {|c| c.quantite.de(self) > 0}.present?
         self.errors.add(:couleurs,"Impossible de suppirmer. Cette version de modele est en commande.")
         throw :abort
       end
    end

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
