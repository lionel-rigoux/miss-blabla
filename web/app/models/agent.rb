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
    self.clients.collect { |c|
      commandes = c.commandes.where(status: 3)
      {
        societe: c.societe,
        nbCommandes: commandes.count,
        total: commandes.inject(0){|s,c| s+c.total}
      }
    }
  end

  def performance
    self.portefeuille.inject(0){|s,c| s+c[:total]}
  end

end
