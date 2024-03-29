# == Schema Information
#

class Retour < ApplicationRecord

  # relations
  belongs_to :commande
  has_one :quantite, as: :quantifiable, dependent: :destroy
  accepts_nested_attributes_for :quantite, allow_destroy: true

  # validation
  validates_presence_of :commande_id
  validate :validations, :on => :create
  validates_numericality_of :frais_de_port, :greater_than_or_equal_to => 0

  def validations
    self.errors.add(:quantite) unless self.quantite.de > 0
  end
  before_validation :remove_comma

  def remove_comma
    self[:frais_de_port] = self.read_attribute_before_type_cast('frais_de_port').to_s.gsub(',', '.').to_f
  end

 STATUS_LIST = {0=>"en attente", 1=>"soldé"}

  # SCOPES

  # initialization

  after_initialize :init
  def init
    self.frais_de_port ||= 0
    self.status ||= 0
  end

  before_save :update_montant
  def update_montant
    modeles_list = Modele.where(id: self.quantite.modeles_ids).to_a
    self[:montant] = modeles_list.collect { |m| montant(m) }.sum
  end

  def montant(*args)
    if args.count == 0
      self[:montant]
    elsif args[0].is_a?(Modele)
        self.quantite.de(args[0]) * args[0].prix
    end
  end
 #delegation
 delegate :modeles, :versions, :de, to: :quantite
 delegate :client, to: :commande

 def de_commande(commande)
   self.commande = commande;
   self.quantite = Quantite.new
   self.quantite += commande.quantite;
      # set to zero
      self.quantite.modeles_ids.each do |modele_id|
        self.quantite.versions_ids(modele_id).each do |version_id|
          self.quantite.tailles(modele_id,version_id).each do |taille|
            self.quantite.set(modele_id,version_id,taille,0);
          end
        end
      end
     self
 end

 def montant_net_ht()
   montant() * (1 - self.commande.escompte())
 end

 def tva()
   client.has_tva ? montant_net_ht()*0.20 : 0
 end

 def montant_ttc()
   montant_net_ht() + tva()
 end
 

  def total
    montant_ttc + (frais_de_port || 0)
  end

  def numero_avoir
    'R' + created_at.strftime('%y') + '-' + ("%03d" % client.id) + '-' + ("%03d" % id)
  end

  def info
    STATUS_LIST[status]
  end

  def +(arg)
    if arg.is_a? Retour
      self.quantite += arg.quantite
    else
      raise ArgumentError, "Opération non définie pour le type #{arg.class}"
    end
    self.update_montant
    self
  end

end
