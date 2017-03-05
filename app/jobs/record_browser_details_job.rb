class RecordBrowserDetailsJob < ActiveJob::Base
  queue_as :default

  def perform(account_id, remote_ip, user_agent)
    account = Account.find(account_id)
    browser = Browser.new(user_agent)
    attrs = {}

    if remote_ip != account.last_login_ip
      attrs.merge!({ last_login_ip: remote_ip })
    end

    if browser.name != account.browser_name
      attrs.merge!({
        browser_name: browser.name,
        browser_version: browser.version,
        os_name: browser.platform.name,
        os_version: browser.platform.version,
      })
    end

    account.update_attributes(attrs)
  end
end
