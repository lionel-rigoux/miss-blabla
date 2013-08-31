module CommandesHelper
  
  def prix(combien)
    format('%.2f', combien.round(2)) + "&#x20AC;"
  end
  
  def mensualise(commande,texte)
    texte if commande.nombre_paiments > 1
  end

end
