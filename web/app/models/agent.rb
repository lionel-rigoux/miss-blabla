# == Schema Information
#
# Table name: agents
#
#  id         :integer          not null, primary key
#  nom        :string(255)
#  email      :text
#  telephone  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Agent < ApplicationRecord

  # relations
  has_many :clients
  has_one :patron

  # validations
  validates_presence_of :nom, :email, :telephone
  validates_uniqueness_of :nom
  validates :email, email: true
  validates_format_of :telephone, :with => /[0-9]{10}/
  before_validation :format_phone
  def format_phone
    self.telephone = (self.telephone || "").gsub(/[^\d]/,'')
  end

  def portefeuille
    self.clients.collect { |client|
      commandes = client.commandes.where(status: 3)
      {
        societe: client.societe,
        nbCommandes: commandes.count,
        total_net_ht: commandes.inject(0){|s,commande| s+commande.montant_net_ht},
        total_tva: commandes.inject(0){|s,commande| s+commande.tva},
        total_ttc: commandes.inject(0){|s,commande| s+commande.montant_ttc}
      }
    }
  end

  def performance_net_ht
    self.portefeuille.inject(0){|s,c| s+c[:total_net_ht]}
  end

  def performance_tva
    self.portefeuille.inject(0){|s,c| s+c[:total_tva]}
  end

  def performance_ttc
    self.portefeuille.inject(0){|s,c| s+c[:total_ttc]}
  end

end
