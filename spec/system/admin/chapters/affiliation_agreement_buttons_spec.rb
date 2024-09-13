require "rails_helper"

RSpec.describe "Admin 'Chapter Affiliation Agreement' buttons" do
  context "when a chapter has been created with a legal contact" do
    let(:legal_contact) { FactoryBot.create(:legal_contact) }
    let(:chapter) { FactoryBot.create(:chapter, legal_contact: legal_contact) }

    before do
      sign_in(:admin)
    end

    context "when the legal contact does not have a chapter affiliation agreement" do
      before do
        legal_contact.chapter_affiliation_agreement.delete
      end

      it "displays a 'Send Chapter Affiliation Agreement' button" do
        visit admin_chapter_path(chapter)

        expect(page).to have_button("Send Chapter Affiliation Agreement")
      end

      it "displays the section to create an off-platform affiliation agreeemnt" do
        visit admin_chapter_path(chapter)

        expect(page).to have_content("Create Off-platform Affiliation Agreement")
        expect(page).to have_select(
          nil,
          with_options: [
            "Valid for 1 season",
            "Valid for 2 seasons",
            "Valid for 3 seasons"
          ]
        )
        expect(page).to have_button("Submit")
      end
    end

    context "when the legal contact's chapter affiliation agreement has not been signed" do
      before do
        legal_contact.chapter_affiliation_agreement.update_columns(signed_at: nil, status: "sent")
      end

      it "displays a 'Void Chapter Affiliation Agreement' button" do
        visit admin_chapter_path(chapter)

        expect(page).to have_button("Void Chapter Affiliation Agreement")
      end
    end

    context "when the legal contact's chapter affiliation agreement has been signed" do
      before do
        legal_contact.chapter_affiliation_agreement.update_column(:signed_at, Time.now)
      end

      it "does not display a 'Send Chapter Affiliation Agreement' button" do
        visit admin_chapter_path(chapter)

        expect(page).not_to have_button("Send Chapter Affiliation Agreement")
      end

      it "does not display a 'Void Chapter Affiliation Agreement' button" do
        visit admin_chapter_path(chapter)

        expect(page).not_to have_button("Void Chapter Affiliation Agreement")
      end
    end
  end
end
