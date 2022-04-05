require "rails_helper"

describe JudgeQuestionsForSubmissionScore do
  let(:judge_questions_for_submission_score) {
    JudgeQuestionsForSubmissionScore.new(submission_score).call
  }
  let(:submission_score) { instance_double(SubmissionScore) }
  let(:season) { 2021 }
  let(:division) { "senior" }

  before do
    allow(submission_score).to receive(:seasons).and_return([season])
    allow(submission_score).to receive(:team_division_name).and_return(division)
  end

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
      allow(submission_score).to receive(:ideation_1).and_return(submission_score_for_ideation_1)
    end

    it "returns a list of questions" do
      expect(judge_questions_for_submission_score).to eq(questions)
    end

    it "returns the questions with the score field populated with the submission score value" do
      expect(judge_questions_for_submission_score.first.score).to eq(submission_score_for_ideation_1)
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

          judge_questions_for_submission_score
        end
      end

      context "when it's the junior division" do
        let(:division) { "junior" }

        it "calls the appropriate class to get the 2022 junior questions" do
          expect(Judging::TwentyTwentyTwo::JuniorQuestions).to receive_message_chain(:new, :call)

          judge_questions_for_submission_score
        end
      end

      context "when it's the beginner division" do
        let(:division) { "beginner" }

        it "calls the appropriate class to get the 2022 beginner questions" do
          expect(Judging::TwentyTwentyTwo::BeginnerQuestions).to receive_message_chain(:new, :call)

          judge_questions_for_submission_score
        end
      end
    end
  end

  context "when the submission score is before the 2020 season" do
    let(:season) { 2015 }

    it "raises an error indicating that there are no questions for this season" do
      expect { judge_questions_for_submission_score }.to raise_error(/Questions for the 2015 season don't exist/)
    end
  end

  context "when the submisison score is for a future season (that questions haven't been setup for yet)" do
    let(:season) { 2050 }

    it "raises an error indicating that questions need to be setup" do
      expect { judge_questions_for_submission_score }.to raise_error(/Questions for the 2050 season haven't been setup yet/)
    end
  end
end
