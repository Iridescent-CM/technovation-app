require "rails_helper"

RSpec.describe ProgramInformation do
  context "callbacks" do
    context "for chapters" do
      let(:chapter) { FactoryBot.create(:chapter) }
      let(:program_information) { chapter.program_information }

      context "#after_update" do
        it "makes a call to update the chapter's onboarding status when program information is updated" do
          expect(program_information.chapterable).to receive(:update_onboarding_status)

          program_information.update(organization_types: [OrganizationType.new(name: "NGO")])
        end
      end
    end

    context "for clubs" do
      let(:club) { FactoryBot.create(:club) }
      let(:program_information) { club.program_information }

      context "#after_update" do
        it "makes a call to update the club's onboarding status when program information is updated" do
          expect(program_information.chapterable).to receive(:update_onboarding_status)

          program_information.update(meeting_formats: [MeetingFormat.new(name: "Virtual")])
        end
      end
    end
  end

  describe "#complete?" do
    context "for chapters" do
      let(:chapter) { FactoryBot.create(:chapter) }
      let(:program_information) do
        ProgramInformation.new(
          chapterable: chapter,
          child_safeguarding_policy_and_process: child_safeguarding_policy_and_process,
          start_date: start_date,
          program_length: program_length,
          organization_types: organization_types,
          meeting_times: meeting_times,
          meeting_facilitators: meeting_facilitators
        )
      end

      let(:child_safeguarding_policy_and_process) { "Sample safety policy" }
      let(:start_date) { Time.now }
      let(:program_length) { ProgramLength.new }
      let(:organization_types) { [OrganizationType.new] }
      let(:meeting_times) { [MeetingTime.new] }
      let(:meeting_facilitators) { [MeetingFacilitator.new] }

      context "when all of the program info has been completed" do
        let(:child_safeguarding_policy_and_process) { "My safety policy" }
        let(:start_date) { Time.now }
        let(:program_length) { ProgramLength.new }
        let(:organization_types) { [OrganizationType.new] }
        let(:meeting_times) { [MeetingTime.new] }
        let(:meeting_facilitators) { [MeetingFacilitator.new] }

        it "returns true" do
          expect(program_information.complete?).to eq(true)
        end
      end

      context "when the child safeguarding policy is missing" do
        let(:child_safeguarding_policy_and_process) { nil }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end

      context "when the start date is missing" do
        let(:start_date) { nil }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end

      context "when the program length is missing" do
        let(:program_length) { nil }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end

      context "when there are no organization types" do
        let(:organization_types) { [] }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end

      context "when there are no meeeting times" do
        let(:meeting_times) { [] }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end

      context "when there are no meeting facilitars" do
        let(:meeting_facilitators) { [] }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end
    end

    context "for clubs" do
      let(:club) { FactoryBot.create(:club) }
      let(:program_information) do
        ProgramInformation.new(
          chapterable: club,
          start_date: start_date,
          program_length: program_length,
          meeting_times: meeting_times,
          meeting_facilitators: meeting_facilitators,
          meeting_formats: meeting_formats,
          work_related_ambassador: work_related_ambassador
        )
      end

      let(:start_date) { Time.now }
      let(:program_length) { ProgramLength.new }
      let(:meeting_times) { [MeetingTime.new] }
      let(:meeting_facilitators) { [MeetingFacilitator.new] }
      let(:meeting_formats) { [MeetingFormat.new] }
      let(:work_related_ambassador) { nil }

      context "when all of the program info has been completed" do
        let(:start_date) { Time.now }
        let(:program_length) { ProgramLength.new }
        let(:meeting_times) { [MeetingTime.new] }
        let(:meeting_facilitators) { [MeetingFacilitator.new] }
        let(:meeting_formats) { [MeetingFormat.new] }
        let(:work_related_ambassador) { true }

        it "returns true" do
          expect(program_information.complete?).to eq(true)
        end
      end

      context "when the start date is missing" do
        let(:start_date) { nil }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end

      context "when the program length is missing" do
        let(:program_length) { nil }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end

      context "when there are no meeting times" do
        let(:meeting_times) { [] }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end

      context "when there are no meeting facilitors" do
        let(:meeting_facilitators) { [] }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end

      context "when there are no meeting formats" do
        let(:meeting_formats) { [] }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end

      context "when the work based ambassador is missing" do
        let(:work_related_ambassador) { nil }

        it "returns false" do
          expect(program_information.complete?).to eq(false)
        end
      end
    end
  end
end
