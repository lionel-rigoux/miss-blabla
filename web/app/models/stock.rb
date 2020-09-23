# == Schema Information
#
# Table name: stocks
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Stock < ApplicationRecord

   # RELATIONS
  has_one :quantite, as: :quantifiable, :dependent => :destroy
  accepts_nested_attributes_for :quantite, allow_destroy: true

  # CALLBACKS
  after_initialize :init
  def init
    self.quantite ||= Quantite.new
  end

  before_save :trimed


  # METHHODS
  delegate :modeles, :versions, :trimed, to: :quantite

  def add_production(production_id,quantite_a_ajouter)
    self.update(quantite: quantite + quantite_a_ajouter)

    production = Production.find_by_id(production_id)
    production.commandes.each do |commande|
      commande.update_status
      commande.update(production: nil)
    end
    production.destroy
  end

  def quantite_de(*args)
    self.quantite.de(*args)
  end

  def prendre(commande)
    self.quantite -= commande.quantite
  end

  def -(arg)
    new_stock = self.clone
    if arg.is_a? Commande
      new_stock.quantite = (new_stock.quantite - arg.quantite).trimed
    else
      raise ArgumentError, "Opération non définie pour le type #{arg.class}"
    end
    new_stock
  end


#   def deficit(commandes=Commande.find_all_by_status(3))
#    d = Quantite.new.detail
#    Modele.all.each do |modele|
#      modele.versions.each do |version|
#        modele.liste_taille.each do |t|
#          if t
#            ordered=commandes.collect {|c| c.quantite(version,t)}.sum
#            in_stock = self.quantite_de(version,t)
#            if ordered > in_stock
#             d[modele.id][version.id][t] =  ordered - in_stock
#           end
#          end
#        end
#      end
#    end
#    d
#  end
end
