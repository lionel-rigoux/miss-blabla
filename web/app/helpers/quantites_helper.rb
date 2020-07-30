module QuantitesHelper
  
  def td_for(quantite,*args)
    value = quantite.de(*args) 
    
    if value < 0
      para = {class: "neg"}
    elsif value==0
      para = {class: "zero"}
    else
      para = {}
    end  
    if args.last.nil?
      haml_tag :td
    else
      haml_tag :td, value, para
    end
  end
end
