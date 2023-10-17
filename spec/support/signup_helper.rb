module SignupHelper
  def sign_up(profile_scope)
    visit signout_path

    allow(CookiedCoordinates).to receive(:get).and_return(
      [41.50196838, -87.64051818]
    )

    SeasonToggles.enable_signup(profile_scope)

    visit root_path
    click_link "Sign up today"

    check "I agree"
    click_button "Next"

    expect(page).to have_selector('#location_city', visible: true)
    expect(page).to have_selector('#location_state', visible: true)
    expect(page).to have_selector('#location_country', visible: true)

    expect(page.find('#location_city').value).to eq("Chicago")

    fill_in "State / Province", with: "CA"
    fill_in "City", with: "Los Angeles"

    click_button "Next"
    click_button "Confirm"

    year = case profile_scope
           when :student
             Season.current.year - 11
           else
             Season.current.year - 20
           end
    fill_in_vue_select "Year", with: year
    fill_in_vue_select "Month", with: "1"
    fill_in_vue_select "Day", with: "1"
    click_button "Next"

    # Choose Profile: automatic by age
    click_button "Next"

    fill_in "First name(s)", with: "Marge"
    fill_in "Last name(s)", with: "Bouvier"

    case profile_scope
    when :student
      fill_in "School name", with: "Springfield Middle School"
    when :mentor
      fill_in_vue_select "Gender identity", with: "Female"
      fill_in_vue_select "School or company name", with: "Springfield Nuclear Power Plant"
      fill_in "Job title", with: "Safety Supervisor"
      fill_in_vue_select "As a mentor, you may call me a(n)...", with: "Parent"
      fill_in "Tell the students about yourself", with: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa."
    end

    click_button "Next"

    email = FactoryBot.attributes_for(:account)[:email]
    stub_mailgun_validation(valid: true, email: email)

    fill_in "Email", with: email
    fill_in "Password", with: "mysecret1234"
    click_button "Next"

    "#{profile_scope}_profile".camelize.constantize.last
  end
end
