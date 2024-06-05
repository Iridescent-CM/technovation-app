require "rails_helper"

RSpec.describe ChapterProgramInformation do
  describe "#complete?" do
    let(:chapter_program_information) do
      ChapterProgramInformation.new(
        child_safeguarding_policy_and_process: child_safeguarding_policy_and_process,
        team_structure: team_structure,
        external_partnerships: external_partnerships,
        start_date: start_date,
        program_model: program_model,
        number_of_low_income_or_underserved_calculation: number_of_low_income_or_underserved_calculation,
        program_length: program_length,
        participant_count_estimate: participant_count_estimate,
        low_income_estimate: low_income_estimate,
        organization_types: organization_types,
        meeting_times: meeting_times,
        meeting_facilitators: meeting_facilitators
      )
    end

    let(:child_safeguarding_policy_and_process) { "Sample safety policy" }
    let(:team_structure) { "Sample team structure" }
    let(:external_partnerships) { "Sample partnership" }
    let(:start_date) { Time.now }
    let(:program_model) { "Sample model" }
    let(:number_of_low_income_or_underserved_calculation) { "10" }
    let(:program_length) { ProgramLength.new }
    let(:participant_count_estimate) { ParticipantCountEstimate.new }
    let(:low_income_estimate) { LowIncomeEstimate.new }
    let(:organization_types) { [OrganizationType.new] }
    let(:meeting_times) { [MeetingTime.new] }
    let(:meeting_facilitators) { [MeetingFacilitator.new] }

    context "when all of the program info has been completed" do
      let(:child_safeguarding_policy_and_process) { "My safety policy" }
      let(:team_structure) { "My team team" }
      let(:external_partnerships) { "Some external partner" }
      let(:start_date) { Time.now }
      let(:program_model) { "My program model" }
      let(:number_of_low_income_or_underserved_calculation) { "900" }
      let(:program_length) { ProgramLength.new }
      let(:participant_count_estimate) { ParticipantCountEstimate.new }
      let(:low_income_estimate) { LowIncomeEstimate.new }
      let(:organization_types) { [OrganizationType.new] }
      let(:meeting_times) { [MeetingTime.new] }
      let(:meeting_facilitators) { [MeetingFacilitator.new] }

      it "returns true" do
        expect(chapter_program_information.complete?).to eq(true)
      end
    end

    context "when the child safeguarding policy is missing" do
      let(:child_safeguarding_policy_and_process) { nil }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end

    context "when the team structure is missing" do
      let(:team_structure) { nil }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end

    context "when external partnerships are missing" do
      let(:external_partnerships) { nil }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end
    context "when the start date is missing" do
      let(:start_date) { nil }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end

    context "when the program model policy is missing" do
      let(:program_model) { nil }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end

    context "when the low income/underserved calculation is missing" do
      let(:number_of_low_income_or_underserved_calculation) { nil }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end

    context "when the program length is missing" do
      let(:program_length) { nil }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end

    context "when the particpant count is missing" do
      let(:participant_count_estimate) { nil }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end

    context "when the low income estimate is missing" do
      let(:low_income_estimate) { nil }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end

    context "when there are no organization types" do
      let(:organization_types) { [] }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end

    context "when there are no meeeting types" do
      let(:meeting_times) { [] }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end

    context "when there are no meeting facilitars" do
      let(:meeting_facilitators) { [] }

      it "returns false" do
        expect(chapter_program_information.complete?).to eq(false)
      end
    end
  end
end
