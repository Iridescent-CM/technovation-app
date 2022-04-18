require "rails_helper"

describe JudgeQuestionsForSubmissionScore do
  let(:judge_questions_for_submission_score) {
    JudgeQuestionsForSubmissionScore.new(submission_score).call
  }
  let(:submission_score) { instance_double(SubmissionScore) }
  let(:submission_type) { TeamSubmission::MOBILE_APP_SUBMISSION_TYPE }
  let(:season) { 2021 }
  let(:division) { "senior" }

  before do
    allow(submission_score).to receive(:seasons).and_return([season])
    allow(submission_score).to receive(:team_division_name).and_return(division)
    allow(submission_score).to receive(:team_submission_submission_type).and_return(submission_type)
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

  describe "filtering questions based on submission type" do
    let(:division) { "senior" }
    let(:season) { 2022 }

    before do
      allow(Judging::TwentyTwentyTwo::SeniorQuestions).to receive_message_chain(:new, :call).and_return(questions)
    end

    let(:questions) { [mobile_app_question, ai_project_question] }
    let(:mobile_app_question) do
      Question.new(
        section: "demo",
        submission_type: TeamSubmission::MOBILE_APP_SUBMISSION_TYPE,
        text: "mobile app question 1"
      )
    end
    let(:ai_project_question) do
      Question.new(
        section: "demo",
        submission_type: TeamSubmission::AI_PROJECT_SUBMISSION_TYPE,
        text: "ai project question 1"
      )
    end

    context "when it's an AI Project" do
      let(:submission_type) { TeamSubmission::AI_PROJECT_SUBMISSION_TYPE }

      it "only returns AI Project questions" do
        expect(judge_questions_for_submission_score).to include(ai_project_question)
        expect(judge_questions_for_submission_score).not_to include(mobile_app_question)
      end
    end

    context "when it's a Mobile App" do
      let(:submission_type) { TeamSubmission::MOBILE_APP_SUBMISSION_TYPE }

      it "only returns Mobile App questions" do
        expect(judge_questions_for_submission_score).to include(mobile_app_question)
        expect(judge_questions_for_submission_score).not_to include(ai_project_question)
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
