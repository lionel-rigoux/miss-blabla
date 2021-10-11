desc "Generate archive"
task :archive => :environment do

  require 'zip'

  # target directory
  temp_dir = Rails.root.join('tmp','media')

  # clean any previous files
  FileUtils.rm_rf(Dir.glob(File.join(temp_dir,'*')))

  # zip File
  zipfile_name = File.join(temp_dir,"archive.zip")

  # useful vars for the templates
  catalogue = Modele.catalogue
  couleurs = Hash[Couleur.pluck(:id,:nom)]
  patron = Patron.first

  Zip::File.open(zipfile_name, create: true) do |zipfile|

    # Generate pdfs of all factures
    Commande.where(status: 3).includes(:quantite,:client).to_a.each do |commande|
      filename = commande.numero_facture + ".pdf"
      content = ApplicationController.render(pdf: filename, template: "commandes/show_facture.html.haml", locals: {:@commande => commande, :@patron => patron, :@catalogue => catalogue, :@couleurs => couleurs}, layout: 'printable', formats: 'pdf')
      save_path = File.join(temp_dir,filename)
      File.open(save_path, 'wb') do |file|
        file << content
      end
      zipfile.add(filename, save_path)
    end

    Retour.where(status: 1).includes(:quantite).to_a.each do |retour|
        filename = retour.numero_avoir + ".pdf"
        content = ApplicationController.render(pdf: filename, template: "retours/show_avoir.html.haml", locals: {:@retour => retour, :@patron => patron, :@catalogue => catalogue, :@couleurs => couleurs}, layout: 'printable', formats: 'pdf')
        save_path = File.join(temp_dir,filename)
        File.open(save_path, 'wb') do |file|
          file << content
        end
        zipfile.add(filename, save_path)
    end

  end

  # clean temp pdf files
  FileUtils.rm_rf(Dir.glob(File.join(temp_dir,'*.pdf')))

end
