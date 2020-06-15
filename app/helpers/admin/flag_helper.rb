class Admin
  module FlagHelper
    def report_attribute_info(prompt, value, index)
      "<b>#{index} - #{prompt}:</b> #{value.presence || 'N/A'}".html_safe
    end
  end
end
