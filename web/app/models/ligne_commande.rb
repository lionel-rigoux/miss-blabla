class LigneCommande < ActiveRecord::Base
  belongs_to :commande
  belongs_to :version
  
  def self.parse_params(params)
    quantities={}
    parsed_params={}
    
    params.each do |k,v|
      if k.match(/quantity_(.*)$/)
        quantities.store($1,v)
      else
        parsed_params.store(k,v)
      end
    end
    parsed_params.store("quantities",quantities.to_yaml)
    params=parsed_params
  end
    
  def quantites
    if self.quantities
      YAML.load(self.quantities)
    else
      q={}
      self.version.modele.liste_taille.compact.each {|t| q.store(t,"0")}
      q
    end
  end
    
  def method_missing(method_id,*args)
    if method_id.to_s.match(/quantity_?(.*)$/)
      taille =  args[0] || $1
      q = self.quantities ? YAML.load(self.quantities) : {}
      if q.has_key?(taille)
        q[taille]
      else
        0
      end
    end
  end
  
  def total
    q = self.quantities ? YAML.load(self.quantities) : {}
    q.values.map {|v| eval(v)}.sum
  end
  
end
