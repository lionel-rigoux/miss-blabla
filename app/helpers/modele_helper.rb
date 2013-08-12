module ModeleHelper
  def setup_version(modele)
    modele.versions[0] ||= Version.new
    modele
  end
end
