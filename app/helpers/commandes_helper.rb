module CommandesHelper
  def taille_entete
    Modele.new.tailles_possibles.each do |t|
      haml_tag :td, t
    end
  end
  
  def prix(combien)
    format('%.2f', combien.round(2)) + "&#x20AC;"
  end
  
  def taille_modele(modele)
    
    modele.tailles_possibles.each do |t|
      if modele.has_taille?(t) 
        haml_tag :td, 'x'
      else
        haml_tag :td, '-'
      end
    end
  end
end
