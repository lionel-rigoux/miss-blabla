# == Schema Information
#
# Table name: productions
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Production < ActiveRecord::Base

  # RELATIONS
  has_many :commandes
  has_one :quantite, as: :quantifiable, :dependent => :destroy

  # INITIALIZATION
  after_initialize :init

  def init
    self.quantite ||= Quantite.new
  end

  # METHODS
  delegate :modeles, :versions, :de, to: :quantite

  def date
    created_at.strftime('%d/%m/%Y')
  end

  def up_to_date
    self.quantite.reset
    self.quantite += self.commandes.collect {|c| c.quantite}.sum
    self.save
    self
  end

  def +(arg)
    if arg.is_a? Commande
      self.quantite += arg.quantite
    else
      raise ArgumentError, "Opération non définie pour le type #{arg.class}"
    end
    self
  end

end
