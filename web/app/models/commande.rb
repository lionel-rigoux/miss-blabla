# == Schema Information
#
# Table name: commandes
#
#  id               :integer          not null, primary key
#  client_id        :integer
#  livraison        :date
#  commentaire      :text
#  status           :integer          default(0), not null
#  production_id    :integer
#  created_at       :datetime
#  updated_at       :datetime
#  frais_de_port    :float
#  nombre_paiments  :integer
#  numero_facture   :integer
#  date_facturation :date
#

class Commande < ApplicationRecord

  # relations
  belongs_to :client
  belongs_to :production
  has_one :quantite, as: :quantifiable, dependent: :destroy
  accepts_nested_attributes_for :quantite, allow_destroy: true

  # validation
  validates_presence_of :client_id
  validates_inclusion_of :status, :in => 0..4
  validate :validations, :on => :create
  validates_uniqueness_of :numero_facture, allow_blank: true
  validates_numericality_of :frais_de_port, :greater_than_than_or_equal_to => 0
  validates_numericality_of :avoir, :greater_than_than_or_equal_to => 0

  def validations
    self.errors.add(:livraison) if self.livraison < Time.now-1.day
    self.errors.add(:quantite) unless self.quantite.de > 0
  end
  before_validation :remove_comma

  def remove_comma
    self[:frais_de_port] = self.read_attribute_before_type_cast('frais_de_port').to_s.gsub(',', '.').to_f
    self[:avoir] = self.read_attribute_before_type_cast('avoir').to_s.gsub(',', '.').to_f
  end

  # SCOPES
  scope :en_avance, -> {where(status: 0)}
  scope :en_production, -> {where(status: 1)}
  scope :en_preparation, -> {where(status: 2)}
  scope :envoyees, -> {where(status: 3)}
  scope :payees, -> {where(status: 4)}


  # initialization

  after_initialize :init
  def init
    self.status ||= 0
    self.frais_de_port ||= 0
    self.avoir ||= 0
  end

  before_save :update_montant
  def update_montant
    modeles_list = Modele.where(id: modeles).to_a
    self[:montant] = modeles_list.collect { |m| montant(m) }.sum
  end

 #delegation
 delegate :modeles, :versions, :de, to: :quantite
 delegate :societe, to: :client

 STATUS_LIST = {0=>"en pré-commande", 1=>"en production", 2=>"en préparation", 3=>"envoyée", 4=>"payée"}

 def prepare
   self.quantite = Quantite.new
      Modele.catalogue.each do |modele|
        modele.versions.each do |version|
          modele.liste_taille.compact.each do |taille|
            self.quantite.set(modele.id,version.id,taille,0)
          end
        end
     end
     self
 end

  # methods
  def date
    livraison.strftime('%d/%m/%y')
  end

  def pasee_le
    created_at.strftime('%d/%m/%y')
  end

  def reference
    status < 3 ? numero_commande : numero_facture
  end

  def numero_commande
    'C' + created_at.strftime('%y') + '-' + ("%03d" % client.id) + '-' + ("%03d" % id)
  end

  def numero_facture
    ('F' + date_facturation.strftime('%y')+'-'+ ("%03d" % client.id) + '-' + ("%03d" % self[:numero_facture])) if self[:numero_facture]
  end

  def info
    STATUS_LIST[status]
  end

  def update_status
    self.status += 1
    self.save
  end

  def montant(*args)
    if args.count == 0
      self[:montant]
    elsif args[0].is_a?(Modele)
        self.quantite.de(args[0]) * args[0].prix
    end
  end

  def escompte()
    (nombre_paiments == 1) ? montant()*0.03 : 0
  end

  def montant_net_ht()
    montant() - escompte()
  end

    def tva()
      client.has_tva ? montant_net_ht()*0.20 : 0
    end

  def montant_ttc()
    montant_net_ht() + tva()
  end

  def mensualite
    montant_ttc / nombre_paiments
  end

  def total
    montant_ttc + (frais_de_port || 0) - (avoir || 0) 
  end

  def quantite_totale
    self.quantite.total
  end

  def echeancier
    case nombre_paiments
    when 1
      "30"
    when 2
      "15 et 60"
    when 3
      "15, 60 et 90"
    end
  end

  def self.nouveau_numero
    self.where(date_facturation: Time.new.beginning_of_year..Time.now).count + 1
  end

  def avoirs_en_attente
    self.client.retours.where(status: 0)
  end

  def +(arg)
    if arg.is_a? Commande
      self.quantite += arg.quantite
    else
      raise ArgumentError, "Opération non définie pour le type #{arg.class}"
    end
    self.update_montant
    self
  end

end
