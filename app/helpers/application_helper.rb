module ApplicationHelper
  def version
    @version ||= File.read('VERSION').chomp
  end

  def last_updated_at(updated_at)
    last_updated_text = '<p>Last Updated: ' + (updated_at ? updated_at.strftime('%m/%d/%Y, %l:%M %p') : 'N/A') + '</p>'
    last_updated_text.html_safe
  end

  def upload_server
    Rails.configuration.upload_server
  end
end
