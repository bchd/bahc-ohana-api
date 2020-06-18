class Admin
  module FlagHelper
    def report_attribute_info(response, index)
      if response['selected'] == 'true' || response['selected'].nil?
        "<b>#{index} - #{response['prompt']}:</b> #{response['value'].presence || 'Selected but no correction offered.'}".html_safe
      end
    end
  end
end
