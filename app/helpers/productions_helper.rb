module ProductionsHelper

  def nombre_commandes(commandes)
    commandes.count
  end

  def nombre_pieces(commandes)
    commandes.collect {|c| c.quantite.de}.sum
  end

end
