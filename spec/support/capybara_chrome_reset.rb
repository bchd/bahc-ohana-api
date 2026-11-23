# Capybara 3.40's ChromeDriver#reset! clears storage via CDP with origin '*',
# which newer Chrome rejects ("* is not a valid URL"). Clear cookies and the
# test server's origin instead.
module CapybaraChromeResetFix
  private

  # This monkey patches a private method on Capybara's ChromeDriver.
  # CDP =  Chrome DevTools Protocol
  def execute_cdp(cmd, params = {})
    return super unless cmd == 'Storage.clearDataForOrigin' && params[:origin] == '*'

    super('Network.clearBrowserCookies')
    origin = Capybara.current_session.server&.base_url
    super(cmd, params.merge(origin: origin)) if origin
  end
end

Capybara::Selenium::Driver::ChromeDriver.prepend(CapybaraChromeResetFix)
