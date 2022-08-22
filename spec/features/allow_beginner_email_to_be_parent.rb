require "rails_helper"

RSpec.feature "Allow beginner to be parent", :js do
  before { SeasonToggles.enable_signups! }

  let(:beginner_profile) { FactoryBot.create(:student, :beginner ) }
  let(:beginner_account) { beginner_profile.account }

  let(:junior_birthdate) {
    Division.cutoff_date - (Division::SENIOR_DIVISION_AGE - 1).years
  }

  context "Beginner account is Parent/Guardian" do
    scenario 'Creates junior with beginner as parent' do
      visit("/signup")

      # Check if first page was loaded
      expect(page).to have_content("Your Profile Type")
      
      # Selecting 13-18 years old student
      find(:css, "#formulate-global-1_student[value='student']").set(true)
  
      # Click to load next screen
      click_button("Next")
  
      # Check if FORM was loaded
      expect(page).to have_content("Basic Profile")
  
      # Fill the form
      fill_in("firstName",                  with: "Junior")
      fill_in("lastName",                   with: "Student")
      fill_in("dateOfBirth",                with: junior_birthdate)
      fill_in("studentSchoolName",          with: "Junior School")
      fill_in("studentParentGuardianName",  with: "%s %s" % [ beginner_account.first_name, beginner_account.last_name] )
      fill_in("studentParentGuardianEmail", with: beginner_account.email)
      select "Friend", :from => "referredBy"
  
      # Click to load next screen
      click_button("Next")
  
      # Check if USE TERMS was loaded
      expect(page).to have_content("Use Terms")
  
      # Agree with use terms
      find(:css, "#dataTermsAgreedTo").set(true)
  
      # Click to load next screen
      click_button("Next")
      
      # Check if Mail/Password screen was loaded
      expect(page).to have_content("Set your email and password")
      
      # Fill email and password
      fill_in("email", with: "junior-student@email.com")
      fill_in("password", with: "@student1234")
  
      # Submit the form
      find(:css, '#formulate-global-13').click()
  
      # Testing for error message
      expect(page).not_to have_content("Parent guardian email cannot match your (or any other student's) email")
    end
  end
end
