class Commande < ActiveRecord::Base
  #has_many :ligne_commandes, dependent: :destroy
  #accepts_nested_attributes_for :ligne_commandes
  
  
  belongs_to :client
  belongs_to :production
  has_one :quantite, as: :quantifiable
  accepts_nested_attributes_for :quantite
  
  validates :client, presence: true
  
  
  after_initialize do |commande|
    if commande.quantite.nil?
      commande.quantite = Quantite.new
      commande.status = 0
       Modele.catalogue.each do |modele|
          modele.versions.each do |version|
            modele.liste_taille.compact.each do |taille|
              self.quantite.detail[modele.id.to_s][version.id.to_s][taille] = 0
            end
          end
        end
    end
  end
  
 
  def modeles
    self.quantite.modeles
  end
  
  def versions(modele)
    self.quantite.versions(modele)
  end
  
  
  def date
    self.created_at.strftime('%d/%m/%Y')
  end
  
  def reference
    self.created_at.strftime('%y') + '-' + ("%03d" % self.client.id) + '-' + ("%04d" % self.id)
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
      "Facturée"
    when 4
      "Réglée"
    end
  end
  
  def update_status
    self.status += 1
    self.save
  end
  
  def quantites_totale
    self.quantite.de
  end
  
  def quantite_version(version)
    self.quantite.de(version)
  end
  
  #def quantite(version,taille)
  #  eval(lignes_for(version).quantites[taille])
  #end
  
  def total 
    quantites_totale.values.sum
  end

  
  def montant(*args)
    if args.count == 0
      self.modeles.collect { |m| montant(m) }.sum
    else
      if args[0].is_a?(Modele)
        self.quantite.de(args[0]) * args[0].prix
      end
    end
  end
  
  def tva
    (montant*0.196)
  end
  
  
  
  
end
