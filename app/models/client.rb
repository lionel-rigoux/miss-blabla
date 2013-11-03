# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  societe    :string(255)
#  nom        :string(255)
#  siret      :string(255)
#  tva        :string(255)
#  email      :string(255)
#  telephone  :string(255)
#  adresse_1  :text
#  adresse_2  :text
#  agent_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  has_tva    :boolean          default(TRUE), not null
#

class Client < ActiveRecord::Base

 # relations
 belongs_to :agent

 # validations
 validates_presence_of :societe, :email, :telephone, :adresse_1, :adresse_2
 validates_uniqueness_of :societe
 validates_uniqueness_of :nom, allow_blank: true
 validate :validations
 validates :email, email: true
 validates_format_of :telephone, :with => /[0-9]{10}/
 before_validation :format_phone
 def format_phone
   self.telephone = self.telephone.gsub(/[^\d]/,'')
 end

 def validations
   if self.tva.blank? and self.siret.blank?
     self.errors.add(:tva)
   end
 end

 # initialisation
 after_initialize :init
 def init
   has_tva = true if self.has_tva.nil?
 end

 # SCOPES
  default_scope order(:societe)


  def intitule
    int = []
    int += [self.societe] unless self.societe.blank?
    int += [self.nom] unless self.nom.blank?
    int.join(' / ')
  end

 def identification
   iden = []
   iden += ["SIRET: #{self.siret}"] unless self.siret.blank?
   iden += ["TVA: #{self.tva}"] unless self.tva.blank?
   iden.join(',')

 end


end
