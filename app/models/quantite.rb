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

class Quantite < ActiveRecord::Base

  # RELATIONS
  belongs_to :quantifiable, :polymorphic => true
  serialize :detail, Hash

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
            self.set(modele,version,taille,previous_quantite ? previous.de(modele,version,taille) : 0)
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
  def update_total
    self.total = self.de
  end

  def reset
    self.detail = {}
  end

  def trimed
    new_quantite = self.clone
    self.modeles.each do |modele|
      if self.de(modele) == 0
        new_quantite.detail.delete(modele.id.to_s)
      else
        self.versions(modele).each do |version|
          if self.de(version) == 0
            new_quantite.detail[modele.id.to_s].delete(version.id.to_s)
          end
        end
      end
    end
    new_quantite
  end

  # METHODS

  def modeles
    Modele.where(id: detail.keys).order(:numero).to_a
  end

  def versions(modele)
    if detail[modele.id.to_s]
      Version.where(id: detail[modele.id.to_s].keys).to_a
    else
      []
    end
  end

  def tailles(modele)
      ((detail[modele.id.to_s] || {}).values.first || {}).keys
  end

  def de(*args)
    if args[0].is_a? Modele
      versions(args[0]).collect {|v| de(v)}.sum
    elsif args[0].is_a? Version
      if args[1]
        (((self.detail[args[0].modele_id.to_s] || {})[args[0].id.to_s] || {})[args[1]] || 0 ).to_i
      else
       args[0].modele.liste_taille.compact.collect {|t| de(args[0],t)}.sum
      end
    elsif args.empty?
      self.modeles.collect { |modele| self.de(modele)}.sum
    end
  end

  def set(modele_id,version_id,taille,q)
    ((self.detail[modele_id.to_s] ||= {})[version_id.to_s] ||= {})[taille] = q.to_s
  end

  def method_missing(method_id,*args)
    if method_id.to_s.match(/detail\[(.*)\]\[(.*)\]\[(.*)\]$/)
      self.detail[$1][$2][$3].to_i
    end
  end

  def +(other_quantite)
    new_quantite = self.clone #Quantite.new

    other_quantite.modeles.each do |modele|
      other_quantite.versions(modele).each do |version|
        other_quantite.tailles(modele).each do |taille|
          new_quantite.set(modele.id,version.id,taille, de(version,taille) + other_quantite.de(version,taille))
        end
      end
    end
    new_quantite
  end

  def -(other_quantite)
    #new_quantite = Quantite.new
    new_quantite = self.clone
    other_quantite.modeles.each do |modele|
      other_quantite.versions(modele).each do |version|
        other_quantite.tailles(modele).each do |taille|
          new_quantite.set(modele.id,version.id,taille, de(version,taille) - other_quantite.de(version,taille))
        end
      end
    end
    new_quantite
  end

end
