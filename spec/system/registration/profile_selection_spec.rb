require "rails_helper"

RSpec.describe "Registration Step 1 - Selecting a Profile", :js do
  context "when registration is open" do
    before do
      allow(SeasonToggles).to receive(:registration_closed?).and_return(false)
    end

    context "when student registration is open" do
      before do
        allow(SeasonToggles).to receive(:student_registration_open?).and_return(true)
      end

      it "displays student registration options" do
        visit signup_path

        expect(page).to have_content("I am registering myself and am 13-18 years old")
        expect(page).to have_content("I am registering my 8-12 year old* daughter")
      end
    end

    context "when student registration is closed" do
      before do
        allow(SeasonToggles).to receive(:student_registration_open?).and_return(false)
      end

      it "does not display student registration options" do
        visit signup_path

        expect(page).not_to have_content("I am registering myself and am 13-18 years old")
        expect(page).not_to have_content("I am registering my 8-12 year old* daughter")
      end
    end

    context "when mentor registration is open" do
      before do
        allow(SeasonToggles).to receive(:mentor_registration_open?).and_return(true)
      end

      it "displays a mentor registration option" do
        visit signup_path

        expect(page).to have_content("I am over 18 years old and will guide a team")
      end
    end

    context "when mentor registration is closed" do
      before do
        allow(SeasonToggles).to receive(:mentor_registration_open?).and_return(false)
      end

      it "does not display a mentor registration option" do
        visit signup_path

        expect(page).not_to have_content("I am over 18 years old and will guide a team")
      end
    end

    context "when judge registration is open" do
      before do
        allow(SeasonToggles).to receive(:judge_registration_open?).and_return(true)
      end

      it "displays a judge registration option" do
        visit signup_path

        expect(page).to have_content("I am over 18 years old and will judge submissions")
      end
    end

    context "when judge registration is closed" do
      before do
        allow(SeasonToggles).to receive(:judge_registration_open?).and_return(false)
      end

      it "does not display a judge registration option" do
        visit signup_path

        expect(page).not_to have_content("I am over 18 years old and will judge submissions")
      end
    end
  end
end
