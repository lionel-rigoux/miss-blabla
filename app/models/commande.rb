# == Schema Information
#
# Table name: commandes
#
#  id               :integer          not null, primary key
#  client_id        :integer
#  livraison        :date
#  commentaire      :text
#  status           :integer
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
    unless quantite
      self.quantite = Quantite.new
      Modele.catalogue.each do |modele|
        modele.versions.each do |version|
          modele.liste_taille.compact.each do |taille|
            self.quantite.set(modele.id,version.id,taille,0)
          end
        end
      end
    end
  end

 #delegation
 delegate :modeles, :versions, :de, to: :quantite

 STATUS_LIST = ["Pré-commande", "En Production", "En préparation", "Envoyée", "Payée"]

  # methods
  def date
    livraison.strftime('%d/%m/%y')
  end

  def reference
    created_at.strftime('%y') + '-' + ("%03d" % client.id) + '-' + ("%04d" % id)
  end

  def numero_facture
    date_facturation.strftime('%y')+'-'+ ("%03d" % client.id) + '-' + ("%04d" % self[:numero_facture]) if self[:numero_facture]
  end

  def info
    case status
    when 0
      "Pré-commande"
    when 1
      "En production"
    when 2
      "En préparation"
    when 3
      "Envoyée"
    when 4
      "Réglée"
    end
  end

  def update_status
    self.status += 1
    self.save
  end

#  def quantites_totale
#    self.quantite.de
#  end

#  def quantite_version(version)
#    self.quantite.de(version)
#  end

  #def quantite(version,taille)
  #  eval(lignes_for(version).quantites[taille])
  #end

  def montant(*args)
    if args.count == 0
      self.modeles.collect { |m| montant(m) }.sum
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
