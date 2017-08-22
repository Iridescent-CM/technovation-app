require "rails_helper"

RSpec.feature "Toggle available user types for registration" do
  %w{student mentor judge regional_ambassador}.each do |scope|
    scenario "#{scope} registration is toggled on" do
      SeasonToggles.enable_signup(scope)

      set_signup_token("user@example.com")

      visit signup_path

      href = public_send("#{scope}_signup_path")
      links = page.all(:css, "a[href='#{href}']")

      expect(links).not_to be_empty
    end

    scenario "#{scope} registration is toggled off" do
      SeasonToggles.disable_signup(scope)

      set_signup_token("user@example.com")

      visit signup_path

      href = public_send("#{scope}_signup_path")
      links = page.all(:css, "a[href='#{href}']")

      expect(links).to be_empty
    end

    scenario "#{scope} registration is toggled off, with admin permission" do
      SeasonToggles.disable_signup(scope)

      set_signup_and_permission_token("user@example.com")

      visit signup_path

      href = public_send("#{scope}_signup_path")
      links = page.all(:css, "a[href='#{href}']")

      expect(links).not_to be_empty
    end
  end
end
