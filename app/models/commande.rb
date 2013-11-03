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

class Commande < ActiveRecord::Base

  # relations
  belongs_to :client
  belongs_to :production
  has_one :quantite, as: :quantifiable, dependent: :destroy
  accepts_nested_attributes_for :quantite

  # validation
  validates_presence_of :client_id
  validates_inclusion_of :status, :in => 0..4
  validate :validations, :on => :create
  validates_uniqueness_of :numero_facture, allow_blank: true

  def validations
    self.errors.add(:livraison) if self.livraison < Time.now-1.day
    self.errors.add(:quantite) unless self.quantite.de > 0
  end
  before_validation :remove_comma

  def remove_comma
    @attributes["frais_de_port"].to_s.gsub!(',', '.') if @attributes["frais_de_port"]
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
    status ||= 0
  end

  before_save :update_montant
  def update_montant
    self[:montant] = modeles.collect { |m| montant(m) }.sum
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

  def tva(*args)
    client.has_tva ? montant(*args)*0.196 : 0
  end

  def montant_ttc(*args)
    montant(*args)+tva(*args)
  end

  def mensualite
    montant_ttc / nombre_paiments
  end

  def total
    montant_ttc + (frais_de_port || 0)
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


end
