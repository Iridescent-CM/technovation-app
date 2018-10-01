require "rails_helper"

RSpec.describe "A mentor completing their training", :js do
  it "displays their training step as complete" do
    sign_in(:mentor)
    expect(page).to have_xpath(
      '//*[@id="mentor_training"]/button/img[contains(@src, "circle-o")]'
    )

    visit mentor_training_completion_path
    click_button "Build your team"
    expect(page).to have_xpath(
      '//*[@id="mentor_training"]/button/img[contains(@src, "check-circle")]'
    )
  end
end