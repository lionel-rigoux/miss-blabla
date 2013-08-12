class Version < ActiveRecord::Base
    belongs_to :modele
    
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
