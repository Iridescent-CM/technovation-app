require "rails_helper"

RSpec.describe "Registration toggles", :js do
  context "when student registration is toggled on" do
    before do
      SeasonToggles.enable_signup("student")
    end

    it "allows students and parents to register" do
      visit signup_path

      expect(page).to have_content("I am registering myself and am 13-18 years old")
      expect(page).to have_content("I am registering my 8-12 year old* daughter")
    end
  end

  context "when mentor registration is toggled on" do
    before do
      SeasonToggles.enable_signup("mentor")
    end

    it "allows mentors to register" do
      visit signup_path

      expect(page).to have_content("I am over 18 years old and will guide a team")
    end
  end

  context "when judge registration is toggled on" do
    before do
      SeasonToggles.enable_signup("judge")
    end

    it "allows judges to register" do
      visit signup_path

      expect(page).to have_content("I am over 18 years old and will judge submissions")
    end
  end

  context "when student registration is toggled off" do
    before do
      SeasonToggles.disable_signup("student")
    end

    it "does not allow students or parents to register" do
      visit signup_path

      expect(page).not_to have_content("I am registering myself and am 13-18 years old")
      expect(page).not_to have_content("I am registering my 8-12 year old* daughter")
    end
  end

  context "when mentor registration is toggled off" do
    before do
      SeasonToggles.disable_signup("mentor")
    end

    it "does not allow mentors to register" do
      visit signup_path

      expect(page).not_to have_content("I am over 18 years old and will guide a team")
    end
  end

  context "when judge registration is toggled off" do
    before do
      SeasonToggles.disable_signup("judge")
    end

    it "does not allows judges to register" do
      visit signup_path

      expect(page).not_to have_content("I am over 18 years old and will judge submissions")
    end
  end

  context "when all registration toggles are off" do
    before do
      SeasonToggles.disable_signup("student")
      SeasonToggles.disable_signup("mentor")
      SeasonToggles.disable_signup("judge")
    end

    it "does not allows anyone to register" do
      visit signup_path

      expect(page).not_to have_content("I am registering myself and am 13-18 years old")
      expect(page).not_to have_content("I am registering my 8-12 year old* daughter")
      expect(page).not_to have_content("I am over 18 years old and will guide a team")
      expect(page).not_to have_content("I am over 18 years old and will judge submissions")

      expect(page).to have_content("Registration is currently closed")
    end
  end
end
