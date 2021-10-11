desc "Wipe season"
task :wipe_all => :environment do
  Retour.delete_all
  Commande.delete_all
  Production.delete_all
  Modele.delete_all
  Couleur.delete_all
end
