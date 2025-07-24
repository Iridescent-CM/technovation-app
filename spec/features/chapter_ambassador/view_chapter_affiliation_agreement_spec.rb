require "rails_helper"

RSpec.feature "Chapter Ambassadors view the chapter affiliation agreement tab" do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

  scenario "A Chapter Ambassador assigned to a chapter with a signed chapter affiliation agreement" do
    sign_in(chapter_ambassador)

    click_link "Chapter Profile"
    click_link "Chapter Affiliation Agreement"

    expect(page).to have_content("Your legal contact has signed the Chapter Affiliation Agreement!")
  end

  scenario "A Chapter Ambassador assigned to a chapter with a sent (not signed) chapter affiliation agreement" do
    chapter_ambassador.chapter.legal_contact.chapter_affiliation_agreement.update(sent_at: Time.now, signed_at: nil)

    sign_in(chapter_ambassador)

    click_link "Chapter Profile"
    click_link "Chapter Affiliation Agreement"

    expect(page).to have_content("#{chapter_ambassador.chapter.organization_name} working with this chapter")
    expect(page).to have_content("Legal Contact: #{chapter_ambassador.chapter.legal_contact.full_name}")
    expect(page).to have_content("Chapter Affiliation Agreement Status: Not signed")
  end

  scenario "A Chapter Ambassador assigned to a chapter with no legal contact" do
    chapter_ambassador.chapter.legal_contact.destroy

    sign_in(chapter_ambassador)

    click_link "Chapter Profile"
    click_link "Chapter Affiliation Agreement"

    expect(page).to have_content("#{chapter_ambassador.chapter.organization_name} working with this chapter")
    expect(page).to have_content("Legal Contact: No legal contact has been added yet")
    expect(page).to have_content("Chapter Affiliation Agreement Status: Not sent (no legal contact has been setup yet)")
  end

  scenario "A Chapter Ambassador not assigned to a chapter" do
    chapter_ambassador.chapter.program_information.destroy
    chapter_ambassador.reload
    chapter_ambassador.chapter.destroy

    sign_in(chapter_ambassador)

    click_link "Chapter Profile"
    click_link "Chapter Affiliation Agreement"

    expect(page).to have_content("You are not associated with a chapter. Please contact support@technovation.org for support.")
  end
end
