# Capybara 3.40's ChromeDriver#reset! clears storage via CDP with origin '*',
# which newer Chrome rejects ("* is not a valid URL"). Clear cookies and the
# test server's origin instead.
#
# Raises RuntimeError if Capybara version != "3.40.0". This serves as a trigger to check
# and see if we can remove this monkeypatch. This issue is a widespread problem with Capybara.
# There is a PR open in the Capybara repo. We're assuming it will be fixed with the next
# version of Capybara. See https://github.com/teamcapybara/capybara/issues/2865
module CapybaraChromeResetFix
  private

  # This monkey patches a private method on Capybara's ChromeDriver.
  # CDP =  Chrome DevTools Protocol
  def execute_cdp(cmd, params = {})

    # Raise if Capybara has been upgraded.
    if Gem.loaded_specs["capybara"].version != "3.40.0"
      raise "Capybara upgraded! Check for fix for CapybaraChromeResetFix monkey patch"
    end

    return super unless cmd == 'Storage.clearDataForOrigin' && params[:origin] == '*'

    super('Network.clearBrowserCookies')
    origin = Capybara.current_session.server&.base_url
    super(cmd, params.merge(origin: origin)) if origin
  end
end

Capybara::Selenium::Driver::ChromeDriver.prepend(CapybaraChromeResetFix)