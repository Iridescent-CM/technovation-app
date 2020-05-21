require "rails_helper"

RSpec.feature "getting the semifinalist blog post snippet" do

  context "in different formats" do
    it "renders plaintext" do
      admin = FactoryBot.create(:admin)
      sign_in admin
      visit admin_semifinalist_snippet_path(format: :text)

      expect(page).to have_content("Copy and paste the following")
      expect(page.response_headers["Content-Type"]).to include("text/plain")
    end

    it "renders html" do
      admin = FactoryBot.create(:admin)
      sign_in admin
      visit admin_semifinalist_snippet_path

      expect(page).to have_content("Copy and paste the following")
      expect(page.response_headers["Content-Type"]).to include("text/html")
    end
  end

  context "with a junior and a senior semifinalist" do
    let!(:senior_submission) {
      FactoryBot.create(
        :team_submission,
        :complete,
        :senior,
        contest_rank: :semifinalist
      )
    }

    let!(:junior_submission) {
      FactoryBot.create(
        :team_submission,
        :complete,
        :junior,
        :brazil,
        contest_rank: :semifinalist
      )
    }

    before do
      admin = FactoryBot.create(:admin)
      sign_in admin
      visit admin_semifinalist_snippet_path
    end

    it "renders two columns per division" do
      expect(page).to have_css("#senior", count: 1)
      within "#senior" do
        expect(page).to have_css("#senior-col-1", count: 1)
        expect(page).to have_css("#senior-col-2", count: 1)
      end

      expect(page).to have_css("#junior", count: 1)
      within "#junior" do
        expect(page).to have_css("#junior-col-1", count: 1)
        expect(page).to have_css("#junior-col-2", count: 1)
      end
    end

    it "groups submissions by division then country" do
      within "#senior" do
        expect(page).to have_css("#us")
        within "#us" do
          expect(page).to have_text("United States")
          expect(page).to have_text(senior_submission.name)
        end
      end

      within "#junior" do
        expect(page).to have_css("#br")
        within "#br" do
          expect(page).to have_text("Brazil")
          expect(page).to have_text(junior_submission.name)
        end
      end
    end
  end

  context "with 4 senior submissions across 3 countries" do
    let!(:submissions) {
      FactoryBot.create(
        :team_submission,
        :complete,
        contest_rank: :semifinalist,
        team: FactoryBot.create(
          :team,
          :brazil,
          name: "Team XYZ"
        )
      )

      FactoryBot.create(
        :team_submission,
        :complete,
        contest_rank: :semifinalist,
        team: FactoryBot.create(
          :team,
          :brazil,
          name: "Team ABC"
        )
      )

      FactoryBot.create(
        :team_submission,
        :complete,
        contest_rank: :semifinalist,
        team: FactoryBot.create(
          :team,
          :chicago
        )
      )

      FactoryBot.create(
        :team_submission,
        :complete,
        contest_rank: :semifinalist,
        team: FactoryBot.create(
          :team,
          city: "Najran",
          state_province: "Najran Province",
          country: "SA"
        )
      )
    }

    before do
      admin = FactoryBot.create(:admin)
      sign_in admin
      visit admin_semifinalist_snippet_path
    end

    it "balances the columns" do
      expect(page).to have_css("#junior-col-1 .country", count: 1)
      expect(page).to have_css("#junior-col-1 .semifinalist", count: 2)
      expect(page).to have_css("#junior-col-2 .country", count: 2)
      expect(page).to have_css("#junior-col-2 .semifinalist", count: 2)
    end

    it "sorts countries alphabetically" do
      within "#junior-col-1" do
        expect(page).to have_content("Brazil")
      end
      within "#junior-col-2 > *:first-child" do
        expect(page).to have_content("Saudi Arabia")
      end
      within "#junior-col-2 > *:last-child" do
        expect(page).to have_content("United State")
      end
    end

    it "sorts submissions within a country by team name, alphabetically" do
      within "#br .semifinalist:first-child" do
        expect(page).to have_content("Team ABC")
      end
      within "#br .semifinalist:last-child" do
        expect(page).to have_content("Team XYZ")
      end
    end
  end

  context "with a submission without good country data" do
    let!(:team) {
      FactoryBot.create(
        :team,
        :senior,
        country: ""
      )
    }
    let!(:submission) {
      FactoryBot.create(
        :team_submission,
        :complete,
        contest_rank: :semifinalist,
        team: team
      )
    }

    before do
      admin = FactoryBot.create(:admin)
      sign_in admin
      visit admin_semifinalist_snippet_path
    end

    it "still shows it on the page" do
      expect(page).to have_css(".country", count: 1, text: "")
      expect(page).to have_content(team.name)
      expect(page).to have_content(submission.app_name)
    end
  end
end