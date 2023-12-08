require "rails_helper"

RSpec.feature "Students view rpe details", js: true do
  let(:super_admin) { FactoryBot.create(:super_admin) }

  before do
    @rpe = FactoryBot.create(:rpe)
    @submissions = FactoryBot.create_list(:team_submission, 3, :senior, :complete)
    @submissions.each do |sub|
      @rpe.teams << sub.team
    end
    @incomplete_submissions = FactoryBot.create_list(:team_submission, 2, :senior, :incomplete)
    @incomplete_submissions.each do |sub|
      @rpe.teams << sub.team
    end

    sign_in(super_admin)
    visit admin_events_path
  end

  scenario "Clicking on admin events link displays a datagrid of all regional pitch events" do
    expect(page).to have_content(@rpe.name)
    expect(page).to have_content(@rpe.ambassador.name)
    expect(page).to have_content(@rpe.teams_count)
  end

  scenario "Viewing a specific RPE displays all of the RPE details" do
    expect(page).to have_link "view"
    click_link "view"

    expect(page).to have_content(@rpe.name)
    expect(page).to have_content(@rpe.ambassador.name)
    expect(page).to have_content(@rpe.officiality)
    expect(page).to have_content(@rpe.division_names)
    expect(page).to have_content(@rpe.venue_address)
    expect(page).to have_content("No link provided.")
  end

  scenario "Viewing a specific RPE displays RPE team details" do
    expect(page).to have_link "view"
    click_link "view"

    expect(page).to have_content("Teams (#{@rpe.teams_count})")
    @rpe.teams.each do |team|
      expect(page).to have_link("#{team.name}", href: admin_team_path(team))
      expect(page).to have_content(team.division.name)
      expect(page).to have_content("#{team.submission.app_name}")
      expect(page).to have_content(team.human_status)
    end
  end

  scenario "Viewing a specific RPE displays RPE judge details" do
    rpe_judges = FactoryBot.create_list(:judge, 3)
    rpe_judges.each do |judge|
      judge.regional_pitch_events << @rpe
    end

    invited_judge = UserInvitation.create!(
      profile_type: :judge,
      email: "judge@judge.com",
      event_ids: [@rpe.id]
    )

    expect(page).to have_link "view"
    click_link "view"

    expect(page).to have_content("Judges (#{@rpe.judge_list.size})")

    @rpe.judge_list.each do |judge|
      expect(page).to have_link("#{judge.name}")
      expect(page).to have_content(judge.email)
      expect(page).to have_content(judge.human_status)
    end
  end
end
