module ClientsHelper
  def to_html(text)
    text.gsub(/\r\n/,"</br>")
  end
end
