class Commande < ActiveRecord::Base
  has_many :ligne_commandes, dependent: :destroy
  accepts_nested_attributes_for :ligne_commandes
  
  belongs_to :client
  belongs_to :production
  
  validates :client, presence: true
  
  
  def self.prepare
    commande = self.new(status: '0')
    Modele.all(order: 'numero ASC').each do |m|
      m.versions.each do |v|
        commande.ligne_commandes.new(version_id: v.id)
      end
    end
    commande
  end
  
  def self.parse_params(params)
    parsed_params={}
    
     params.each do |k,v|
       
     if k.match(/ligne_commandes_attributes$/)
       ligne_attributes = {} 
       v.each do |id,ligne_param| 
         ligne_attributes.store(id,LigneCommande.parse_params(ligne_param)) 
       end
       parsed_params.store('ligne_commandes_attributes',ligne_attributes)
      else
        parsed_params.store(k,v)
      end
    end
    parsed_params
  end
 
  def modeles
    self.ligne_commandes.collect {|l| l.version.modele}.uniq
  end
  
  def lignes_for(what)
    if what.class == Version 
      ligne = self.ligne_commandes.select {|l| l.version==what}.first
      if ligne.nil?
        ligne=self.ligne_commandes.new(version: what)
        self.save!
      end
      ligne
    elsif what.class == Modele
      what.versions.collect { |version| lignes_for(version) }
    end
     
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
    q = Hash.new(0)
    Modele.all.each do |m|
      lignes_for(m).each {|l| q[m.id] += l.total}
    end
    q
  end
  
  def quantite_version(version)
    lignes_for(version).quantites
  end
  
  def quantite(version,taille)
    eval(lignes_for(version).quantites[taille])
  end
  
  def total 
    quantites_totale.values.sum
  end
  
  def montant(*args)
    if args.count == 0
      total = 0
      Modele.all.each { |m| total += montant(m) }
      total
    else
      if args[0].is_a?(Modele)
        lignes_for(args[0]).collect {|l| l.total}.sum * args[0].prix
      end
    end
  end
  
  def tva
    (montant*0.196).round(1)
  end
  
  
  
  
end
