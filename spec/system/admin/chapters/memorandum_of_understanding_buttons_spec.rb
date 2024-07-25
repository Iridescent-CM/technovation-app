require "rails_helper"

RSpec.describe "Admin MOU buttons" do
  context "when a chapter has been created with a legal contact" do
    let(:legal_contact) { FactoryBot.create(:legal_contact) }
    let(:chapter) { FactoryBot.create(:chapter, legal_contact: legal_contact) }

    before do
      sign_in(:admin)
    end

    context "when the legal contact does not have an MOU" do
      before do
        legal_contact.legal_document.delete
      end

      it "displays a 'Send MOU' button" do
        visit admin_chapter_path(chapter)

        expect(page).to have_button("Send MOU")
      end
    end

    context "when the legal contact's MOU has not been signed" do
      before do
        legal_contact.legal_document.update_columns(signed_at: nil, status: "sent")
      end

      it "displays a 'Void MOU' button" do
        visit admin_chapter_path(chapter)

        expect(page).to have_button("Void MOU")
      end
    end

    context "when the legal contact's MOU has been signed" do
      before do
        legal_contact.legal_document.update_column(:signed_at, Time.now)
      end

      it "does not display a 'Send MOU' button" do
        visit admin_chapter_path(chapter)

        expect(page).not_to have_button("Send MOU")
      end

      it "does not display a 'Void MOU' button" do
        visit admin_chapter_path(chapter)

        expect(page).not_to have_button("Void MOU")
      end
    end
  end
end
