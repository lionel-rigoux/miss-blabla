module ActionView
  module Helpers
    module FormHelper
      def text_area(object_name, method, options = {})
        html = InstanceTag.new(object_name, method, self, options.delete(:object)).to_text_area_tag(options)
        html.gsub(/>\&#x000A;/, '>').html_safe
      end
    end
  end
end