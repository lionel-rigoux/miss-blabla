# == Schema Information
#
# Table name: patrons
#
#  id         :integer          not null, primary key
#  societe    :string(255)
#  siret      :string(255)
#  tva        :string(255)
#  capital    :float
#  adresse    :text
#  agent_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Patron < ActiveRecord::Base

  # RELATIONS
  belongs_to :agent
  accepts_nested_attributes_for :agent

  # VALIDATIONS
  validates_presence_of :adresse
  validate :validations

   def validations
     if self.tva.blank? and self.siret.blank?
       self.errors.add(:tva)
     end
   end

  # INITIALIZATION
  after_initialize :init

  def init
    self.agent ||= Agent.new
  end

  # METHODS
  delegate :nom, :email, :telephone, to: :agent

  def identification
    iden = []
    iden += ["SIRET: #{self.siret}"] unless self.siret.blank?
    iden += ["TVA: #{self.tva}"] unless self.tva.blank?
    iden.join(',')
  end

  def intitule
    int = []
    int += [self.societe] unless self.societe.blank?
    int += [self.nom] unless self.nom.blank?
    int.join(' / ')
  end

end
