- if @quantite.errors.any?
  #error_explanation
    %h2= "#{pluralize(@quantite.errors.count, "error")} prohibited this quantite from being saved:"
    %ul
      - @quantite.errors.full_messages.each do |msg|
        %li= msg