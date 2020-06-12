class Admin
  module FlagHelper
    def report_attribute_info(attribute, index, flag)
      attribute_label = Flag.get_report_attribute_label_for(attribute)
      attribute_data = flag.report_attributes[attribute.to_s]

      "<b>#{index + 1} - #{attribute_label}:</b> #{attribute_data.presence || 'N/A'}".html_safe
    end
  end
end
