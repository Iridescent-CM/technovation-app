require "rails_helper"

RSpec.describe Chapter do
  let(:chapter) { FactoryBot.build(:chapter) }

  describe "delegations" do
    it "delegates #seasons_chapter_affiliation_agreement_is_valid_for to the legal contact" do
      expect(chapter.seasons_chapter_affiliation_agreement_is_valid_for)
        .to eq(chapter.legal_contact.seasons_chapter_affiliation_agreement_is_valid_for)
    end
  end

  describe "#incomplete_onboarding_tasks" do
    before do
      allow(chapter).to receive(:affiliation_agreement_complete?).and_return(true)
      allow(chapter).to receive(:chapter_info_complete?).and_return(true)
      allow(chapter).to receive(:location_complete?).and_return(true)
      allow(chapter).to receive(:program_info_complete?).and_return(true)
    end

    context "when all required onboarding tasks have been completed" do
      it "returns returns an empty array" do
        expect(chapter.incomplete_onboarding_tasks).to be_empty
      end
    end

    context "when the chapter affiliation has not been signed" do
      before do
        allow(chapter).to receive(:affiliation_agreement_complete?).and_return(false)
      end

      it "returns returns an array that contains 'Chapter Affiliation Agreement'" do
        expect(chapter.incomplete_onboarding_tasks).to contain_exactly("Chapter Affiliation Agreement")
      end
    end

    context "when the public info has not been completed" do
      before do
        allow(chapter).to receive(:chapter_info_complete?).and_return(false)
      end

      it "returns returns an array that contains 'Public Info'" do
        expect(chapter.incomplete_onboarding_tasks).to contain_exactly("Public Info")
      end
    end

    context "when chapter location is not complete" do
      before do
        allow(chapter).to receive(:location_complete?).and_return(false)
      end

      it "returns returns an array that contains 'Chapter Location'" do
        expect(chapter.incomplete_onboarding_tasks).to contain_exactly("Chapter Location")
      end
    end

    context "when program info is not complete" do
      before do
        allow(chapter).to receive(:program_info_complete?).and_return(false)
      end

      it "returns returns an array that contains 'Program Info'" do
        expect(chapter.incomplete_onboarding_tasks).to contain_exactly("Program Info")
      end
    end
  end

  context "callbacks" do
    context "#after_update" do
      describe "updating the onboarded status" do
        let(:chapter) { FactoryBot.create(:chapter, primary_contact: chapter_ambassador.account) }
        let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }

        before do
          allow(chapter).to receive(:affiliation_agreement)
            .and_return(affiliation_agreement)
          allow(chapter).to receive(:program_information)
            .and_return(program_information)
        end

        let(:affiliation_agreement) { instance_double(Document, complete?: affiliation_agreement_complete) }
        let(:affiliation_agreement_complete) { true }
        let(:program_information) { instance_double(ProgramInformation, complete?: program_info_complete) }
        let(:program_info_complete) { true }

        context "when all onboarding steps have been completed" do
          let(:affiliation_agreement_complete) { true }
          let(:program_info_complete) { true }

          before do
            chapter.save
          end

          it "returns true" do
            expect(chapter.onboarded?).to eq(true)
          end
        end

        context "when the affiliation agreement has not been signed" do
          let(:affiliation_agreement_complete) { false }

          before do
            chapter.save
          end

          it "returns false" do
            expect(chapter.onboarded?).to eq(false)
          end
        end

        context "when the chapter's name is missing" do
          before do
            chapter.update(name: nil)
          end

          it "returns false" do
            expect(chapter.onboarded?).to eq(false)
          end
        end

        context "when the chapter's summary is missing" do
          before do
            chapter.update(summary: nil)
          end

          it "returns false" do
            expect(chapter.onboarded?).to eq(false)
          end
        end

        context "when the chapter has no chapter links" do
          before do
            chapter.update(chapter_links: [])
          end

          it "returns false" do
            expect(chapter.onboarded?).to eq(false)
          end
        end

        context "when the chapter's HQ location is missing" do
          before do
            chapter.update(organization_headquarters_location: nil)
          end

          it "returns false" do
            expect(chapter.onboarded?).to eq(false)
          end
        end

        context "when the chapter's program info is incomplete" do
          let(:program_info_complete) { false }

          before do
            chapter.save
          end

          it "returns false" do
            expect(chapter.onboarded?).to eq(false)
          end
        end
      end
    end
  end

  describe "#affiliation_agreement_complete?" do
    context "when an affiliation agreement exists" do
      before do
        allow(chapter).to receive_message_chain(:affiliation_agreement, :complete?).and_return(affiliation_agreement_complete)
      end

      context "when the affiliation agreement has been signed" do
        let(:affiliation_agreement_complete) { true }

        it "returns true" do
          expect(chapter.affiliation_agreement_complete?).to eq(true)
        end
      end

      context "when the affiliation agreement has not been signed" do
        let(:affiliation_agreement_complete) { false }

        it "returns false" do
          expect(chapter.affiliation_agreement_complete?).to eq(false)
        end
      end
    end

    context "when an affiliation agreement doesn't exist" do
      before do
        allow(chapter).to receive(:affiliation_agreement).and_return(nil)
      end

      it "returns false" do
        expect(chapter.affiliation_agreement_complete?).to eq(false)
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
    let(:chapter_primary_contact) { Account.new }
    let(:chapter_links) { [ChapterLink.new] }

    context "when all of the chapter info has been completed" do
      let(:chapter_name) { "Technovation Tokyo" }
      let(:chapter_summary) { "We are Technovation Tokyo." }
      let(:chapter_primary_contact) { Account.new }
      let(:chapter_links) { [ChapterLink.new] }

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
      allow(chapter).to receive_message_chain(:program_information, :complete?).and_return(program_info_complete)
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
