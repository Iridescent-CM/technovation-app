require "rails_helper"

RSpec.describe Chapter do
  let(:chapter) { FactoryBot.build(:chapter) }

  describe "delegations" do
    it "delegates #seasons_legal_agreement_is_valid_for to the legal contact" do
      expect(chapter.seasons_legal_agreement_is_valid_for)
        .to eq(chapter.legal_contact.seasons_legal_agreement_is_valid_for)
    end
  end

  describe "#onboarded?" do
    let(:chapter) do
      Chapter.new(
        name: chapter_name,
        summary: chapter_summary,
        organization_headquarters_location: organization_headquarters_location,
        primary_contact: chapter_primary_contact,
        chapter_links: chapter_links
      )
    end

    let(:chapter_name) { "Sample Chapter" }
    let(:chapter_summary) { "Sample chapter summary." }
    let(:organization_headquarters_location) { "Sample HQ" }
    let(:chapter_primary_contact) { ChapterAmbassadorProfile.new }
    let(:chapter_links) { [RegionalLink.new] }

    before do
      allow(chapter).to receive(:legal_document)
        .and_return(legal_document)
      allow(chapter).to receive(:chapter_program_information)
        .and_return(chapter_program_information)
    end

    let(:legal_document) { instance_double(Document, signed?: legal_document_signed) }
    let(:legal_document_signed) { true }
    let(:chapter_program_information) { instance_double(ChapterProgramInformation, complete?: program_info_complete) }
    let(:program_info_complete) { true }

    context "when all onboarding steps have been completed" do
      let(:chapter_name) { "Technovation Osaka" }
      let(:chapter_summary) { "Our awesome chapter." }
      let(:organization_headquarters_location) { "Osaka, Japan" }
      let(:chapter_primary_contact) { ChapterAmbassadorProfile.new }
      let(:chapter_links) { [RegionalLink.new] }
      let(:legal_document_signed) { true }
      let(:program_info_complete) { true }

      it "returns true" do
        expect(chapter.onboarded?).to eq(true)
      end
    end

    context "when the legal document has not been signed" do
      let(:legal_document_signed) { false }

      it "returns false" do
        expect(chapter.onboarded?).to eq(false)
      end
    end

    context "when the chapter info is incomplete" do
      let(:chapter_name) { nil }
      let(:chapter_summary) { nil }

      it "returns false" do
        expect(chapter.onboarded?).to eq(false)
      end
    end

    context "when the chapter's HQ location is missing" do
      let(:organization_headquarters_location) { nil }

      it "returns false" do
        expect(chapter.onboarded?).to eq(false)
      end
    end

    context "when the program info is incomplete" do
      let(:program_info_complete) { false }

      it "returns false" do
        expect(chapter.onboarded?).to eq(false)
      end
    end
  end

  describe "#legal_document_signed?" do
    before do
      allow(chapter).to receive_message_chain(:legal_document, :signed?).and_return(legal_document_signed)
    end

    context "when the legal document has been signed" do
      let(:legal_document_signed) { true }

      it "returns true" do
        expect(chapter.legal_document_signed?).to eq(true)
      end
    end

    context "when the legal document has not been signed" do
      let(:legal_document_signed) { false }

      it "returns false" do
        expect(chapter.legal_document_signed?).to eq(false)
      end
    end
  end

  describe "#chapter_info_complete?" do
    let(:chapter) do
      Chapter.new(
        name: chapter_name,
        summary: chapter_summary,
        primary_contact: chapter_primary_contact,
        chapter_links: chapter_links
      )
    end

    let(:chapter_name) { "Sample Chapter" }
    let(:chapter_summary) { "Sample chapter summary." }
    let(:chapter_primary_contact) { ChapterAmbassadorProfile.new }
    let(:chapter_links) { [RegionalLink.new] }

    context "when all of the chapter info has been completed" do
      let(:chapter_name) { "Technovation Tokyo" }
      let(:chapter_summary) { "We are Technovation Tokyo." }
      let(:chapter_primary_contact) { ChapterAmbassadorProfile.new }
      let(:chapter_links) { [RegionalLink.new] }

      it "returns true" do
        expect(chapter.chapter_info_complete?).to eq(true)
      end
    end

    context "when the chapter name is missing" do
      let(:chapter_name) { nil }

      it "returns false" do
        expect(chapter.chapter_info_complete?).to eq(false)
      end
    end

    context "when the chapter summary is missing" do
      let(:chapter_summary) { nil }

      it "returns false" do
        expect(chapter.chapter_info_complete?).to eq(false)
      end
    end

    context "when the chapter's primary contact is missing" do
      let(:chapter_primary_contact) { nil }

      it "returns false" do
        expect(chapter.chapter_info_complete?).to eq(false)
      end
    end

    context "when the chapter doesn't have any chapter links" do
      let(:chapter_links) { [] }

      it "returns false" do
        expect(chapter.chapter_info_complete?).to eq(false)
      end
    end
  end

  describe "#location_complete?" do
    let(:chapter) do
      Chapter.new(
        organization_headquarters_location: organization_headquarters_location
      )
    end

    let(:organization_headquarters_location) { "Sample location" }

    context "when the chapter's HQ location is provided" do
      let(:organization_headquarters_location) { "Tokyo, Japan" }

      it "returns true" do
        expect(chapter.location_complete?).to eq(true)
      end
    end

    context "when the chapter's HQ location is not provided" do
      let(:organization_headquarters_location) { nil }

      it "returns true" do
        expect(chapter.location_complete?).to eq(false)
      end
    end
  end

  describe "#program_info_complete?" do
    before do
      allow(chapter).to receive_message_chain(:chapter_program_information, :complete?).and_return(program_info_complete)
    end

    context "when the program info has been completed" do
      let(:program_info_complete) { true }

      it "returns true" do
        expect(chapter.program_info_complete?).to eq(true)
      end
    end

    context "when the program info has not been completed" do
      let(:program_info_complete) { false }

      it "returns false" do
        expect(chapter.program_info_complete?).to eq(false)
      end
    end
  end
end
