class Admin
  module FlagHelper
    def report_attribute_info(response, index)
      if ["1", true, "true"].include?(response['selected'])
        "#{response['prompt']}:</b> #{response['value'].presence || 'Selected but no correction offered.'}".html_safe
      end
    end
  end
end
