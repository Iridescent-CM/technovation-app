require "rails_helper"

RSpec.feature "Toggle available user types for registration" do
  %w{student mentor judge regional_ambassador}.each do |scope|
    scenario "#{scope} registration is toggled on" do
      SeasonToggles.public_send("#{scope}_signup=", "on")

      set_signup_token("user@example.com")

      visit signup_path

      href = public_send("#{scope}_signup_path")
      links = page.all(:css, "a[href='#{href}']")

      expect(links).not_to be_empty
      links.each do |link|
        expect(link[:disabled]).to be_nil
      end
    end

    scenario "#{scope} registration is toggled off" do
      SeasonToggles.public_send("#{scope}_signup=", "off")

      set_signup_token("user@example.com")

      visit signup_path

      href = public_send("#{scope}_signup_path")
      links = page.all(:css, "a[href='#{href}']")

      expect(links).not_to be_empty
      links.each do |link|
        expect(link[:disabled]).to eq("disabled")
      end
    end

    scenario "#{scope} registration is toggled off, with admin permission" do
      SeasonToggles.public_send("#{scope}_signup=", "off")

      set_signup_and_permission_token("user@example.com")

      visit signup_path

      href = public_send("#{scope}_signup_path")
      links = page.all(:css, "a[href='#{href}']")

      expect(links).not_to be_empty
      links.each do |link|
        expect(link[:disabled]).to be_nil
      end
    end
  end
end
