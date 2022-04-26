require "rails_helper"

describe JudgeQuestions do
  let(:judge_questions) {
    JudgeQuestions.new(season: season, division: division).call
  }
  let(:season) { 2021 }
  let(:division) { "senior" }

  describe "#call" do
    let(:season) { 2022 }
    let(:division) { "beginner" }
    let(:questions) {
      [
        Question.new(
          idx: 1,
          section: "ideation",
          field: :ideation_1,
          worth: 5,
          text: "Ideation question"
        )
      ]
    }
    let(:submission_score_for_ideation_1) { 5 }

    before do
      allow(Judging::TwentyTwentyTwo::BeginnerQuestions).to receive_message_chain(:new, :call).and_return(questions)
    end

    it "returns a list of questions" do
      expect(judge_questions).to eq(questions)
    end
  end

  describe "getting the correct questions for a given season and division" do
    before do
      allow(Judging::TwentyTwentyTwo::SeniorQuestions).to receive_message_chain(:new, :call).and_return([])
      allow(Judging::TwentyTwentyTwo::JuniorQuestions).to receive_message_chain(:new, :call).and_return([])
      allow(Judging::TwentyTwentyTwo::BeginnerQuestions).to receive_message_chain(:new, :call).and_return([])
    end

    context "when it's the 2022 season" do
      let(:season) { 2022 }

      context "when it's the senior division" do
        let(:division) { "senior" }

        it "calls the appropriate class to get the 2022 senior questions" do
          expect(Judging::TwentyTwentyTwo::SeniorQuestions).to receive_message_chain(:new, :call)

          judge_questions
        end
      end

      context "when it's the junior division" do
        let(:division) { "junior" }

        it "calls the appropriate class to get the 2022 junior questions" do
          expect(Judging::TwentyTwentyTwo::JuniorQuestions).to receive_message_chain(:new, :call)

          judge_questions
        end
      end

      context "when it's the beginner division" do
        let(:division) { "beginner" }

        it "calls the appropriate class to get the 2022 beginner questions" do
          expect(Judging::TwentyTwentyTwo::BeginnerQuestions).to receive_message_chain(:new, :call)

          judge_questions
        end
      end

      context "when no division is provided" do
        let(:division) { nil }

        it "calls the appropriate class to get the 2022 senior questions (this is to retain existing behavior)" do
          expect(Judging::TwentyTwentyTwo::SeniorQuestions).to receive_message_chain(:new, :call)

          judge_questions
        end
      end
    end
  end

  context "when the submission score is before the 2020 season" do
    let(:season) { 2015 }

    it "raises an error indicating that there are no questions for this season" do
      expect { judge_questions }.to raise_error(/Questions for the 2015 season don't exist/)
    end
  end

  context "when the submisison score is for a future season (that questions haven't been setup for yet)" do
    let(:season) { 2050 }

    it "raises an error indicating that questions need to be setup" do
      expect { judge_questions }.to raise_error(/Questions for the 2050 season haven't been setup yet/)
    end
  end
end
