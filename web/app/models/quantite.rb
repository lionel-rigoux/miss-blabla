# == Schema Information
#
# Table name: quantites
#
#  id                :integer          not null, primary key
#  quantifiable_id   :integer
#  quantifiable_type :string(255)
#  detail            :text             default("--- {}\n"), not null
#  created_at        :datetime
#  updated_at        :datetime
#

class Quantite < ApplicationRecord

  # RELATIONS
  belongs_to :quantifiable, :polymorphic => true
  serialize :detail#, JSON

  # VALIDATIONS
  validate :validations
  def validations
    detail.each do |modele,versions|
      versions.each do |version,tailles|
        tailles.each do |taille,q|
          unless q =~ /^[0-9]*$/
            self.errors.add("detail[#{modele}][#{version}][#{taille}]".to_sym,I18n.t('activerecord.errors.models.quantite.attributes.detail.invalid'))
            # try to restore from db
            previous_quantite = Quantite.where(id: self.id).first
            self.set(modele,version,taille,previous_quantite ? previous_quantite.de(modele,version,taille) : 0)
          end
        end
      end
    end
  end

  # INITIALIZATION
  after_initialize :init
  def init
    self.detail ||= {}
  end

  before_save :update_total
  before_save :trimed
  def update_total
    self.total = self.de_tout
  end

  def reset
    self.detail = {}
  end

  def trimed
    new_quantite = self.clone
    self.modeles_ids.each do |modele_id|
      if self.de_modele(modele_id) == 0
        new_quantite.detail.delete(modele_id.to_s)
      else
        self.versions_ids(modele_id).each do |version_id|
          if self.de_version(modele_id,version_id) == 0
            new_quantite.detail[modele_id.to_s].delete(version_id.to_s)
          end
        end
      end
    end
    new_quantite
  end

  # METHODS

  def modeles
    modeles_ids
    #Modele.where(id: detail.keys).order(:numero).to_a
  end

  def versions(modele)
    versions_ids(modele)
    #if detail[modele.id.to_s]
    #  Version.where(id: detail[modele.id.to_s].keys).to_a
    #else
    #  []
    #end
  end

  def modeles_ids(*catalogue)
    all_ids = detail.keys
    unless catalogue.empty?
      all_ids = all_ids.sort do |a,b|
        e1=catalogue.first.select {|e| e.id == a.to_i}.first
        e2=catalogue.first.select {|e| e.id == b.to_i}.first
        e1.numero <=> e2.numero
      end
    end
    all_ids
  end

  def versions_ids(modele_id)
        detail.fetch(modele_id.to_s,{}).keys
    #detail[modele_id.to_s].keys
  end

  def tailles(modele)
      ((detail[modele.id.to_s] || {}).values.first || {}).keys
  end

  def de(*args)
    begin
    if args[0].is_a? Modele
      #versions(args[0]).collect {|v| de(v)}.sum
      de_modele(args[0].id.to_s)
    elsif args[0].is_a? Version
      if args[1]
        de_taille(args[0].modele_id.to_s,args[0].id.to_s,args[1])
        #(((self.detail[args[0].modele_id.to_s] || {})[args[0].id.to_s] || {})[args[1]] || 0 ).to_i
      else
        de_version(args[0].modele_id.to_s,args[0].id.to_s)
       #args[0].modele.liste_taille.compact.collect {|t| de(args[0],t)}.sum
      end
    elsif args.empty?
      de_tout
      #self.modeles.collect { |modele| self.de(modele)}.sum
    end
  rescue
    0
  end
  end

  def de_tout()
    detail.collect {|k,v| de_modele(k)}.sum
  end
  def de_modele(modele_id)


    detail[modele_id].collect {|k,v| de_version(modele_id,k)}.sum
  end
  def de_version(modele_id, version_id)
    detail[modele_id][version_id].collect {|k,v| de_taille(modele_id,version_id,k)}.sum
  end
  def de_taille(modele_id,version_id,taille)
      (((detail[modele_id.to_s] || {})[version_id.to_s] || {})[taille] || 0).to_i
  end


  def set(modele_id,version_id,taille,q)
    ((self.detail[modele_id.to_s] ||= {})[version_id.to_s] ||= {})[taille] = q.to_s
  end

  def method_missing(method_id,*args)
    if method_id.to_s.match(/detail\[(.*)\]\[(.*)\]\[(.*)\]$/)
      self.detail[$1][$2][$3].to_i
    end
  end

  def tailles(modele_id,version_id)
    self.detail[modele_id][version_id].keys
  end

  def +(other_quantite)
    new_quantite = self.clone

    if other_quantite.kind_of?(Array)
      new_quantite + other_quantite.shift
      new_quantite + other_quantite if other_quantite.count > 0
    else

    other_quantite.modeles_ids.each do |modele_id|
      other_quantite.versions_ids(modele_id).each do |version_id|
        other_quantite.tailles(modele_id,version_id).each do |taille|
          new_quantite.set(modele_id,version_id,taille, self.de_taille(modele_id,version_id,taille) + other_quantite.de_taille(modele_id,version_id,taille))
        end
      end
    end
    new_quantite
  end
  end

def -(other_quantite)
    new_quantite = self.clone

    if other_quantite.kind_of?(Array)
      new_quantite - other_quantite.shift
      new_quantite - other_quantite if other_quantite.count > 0
    else

    other_quantite.modeles_ids.each do |modele_id|
      other_quantite.versions_ids(modele_id).each do |version_id|
        other_quantite.tailles(modele_id,version_id).each do |taille|
          new_quantite.set(modele_id,version_id,taille, self.de_taille(modele_id,version_id,taille) - other_quantite.de_taille(modele_id,version_id,taille))
        end
      end
    end
    new_quantite
  end
  end

end
