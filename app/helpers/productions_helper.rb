module ProductionsHelper
  
  def nombre_commandes(commandes)
    commandes.count
  end
  
  def nombre_pieces(commandes)
    total = 0
    commandes.each {|c| total += c.total}
    total
  end
  
end
