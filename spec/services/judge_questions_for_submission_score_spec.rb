require "rails_helper"

describe JudgeQuestionsForSubmissionScore do
  let(:judge_questions_for_submission_score) {
    JudgeQuestionsForSubmissionScore
      .new(submission_score, judge_questions_constructor: judge_questions_constructor)
      .call
  }
  let(:submission_score) { instance_double(SubmissionScore) }
  let(:judge_questions_constructor) { double(JudgeQuestions) }
  let(:submission_type) { "" }
  let(:ai_usage) { true }
  let(:season) { 2021 }
  let(:division) { "senior" }

  before do
    allow(submission_score).to receive(:seasons).and_return([season])
    allow(submission_score).to receive(:team_division_name).and_return(division)
    allow(submission_score).to receive(:team_submission_submission_type).and_return(submission_type)
    allow(submission_score).to receive(:team_submission_ai_usage).and_return(ai_usage)
  end

  describe "#call" do
    before do
      allow(judge_questions_constructor).to receive_message_chain(:new, :call).and_return(questions)
      allow(submission_score).to receive(:ideation_1).and_return(submission_score_for_ideation_1)
    end

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

    it "returns a list of questions" do
      expect(judge_questions_for_submission_score).to eq(questions)
    end

    it "returns the questions with the score field populated with the submission score value" do
      expect(judge_questions_for_submission_score.first.score).to eq(submission_score_for_ideation_1)
    end
  end

  describe "filtering questions based on submission type" do
    before do
      allow(judge_questions_constructor).to receive_message_chain(:new, :call).and_return(questions)
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

  describe "filtering questions based on AI usage" do
    before do
      allow(judge_questions_constructor).to receive_message_chain(:new, :call).and_return(questions)
    end

    let(:questions) { [ai_usage_question, no_ai_usage_question, non_ai_usage_question] }
    let(:ai_usage_question) do
      Question.new(
        section: "demo",
        ai_usage: true,
        text: "AI usage question"
      )
    end
    let(:no_ai_usage_question) do
      Question.new(
        section: "demo",
        ai_usage: false,
        text: "no AI usage question"
      )
    end
    let(:non_ai_usage_question) do
      Question.new(
        section: "demo",
        text: "non-AI usage question"
      )
    end

    context "when the submission uses AI" do
      let(:ai_usage) { true }

      it "returns the AI usage question (and non-AI related questions, where ai_usage is not defined on the question)" do
        expect(judge_questions_for_submission_score).to include(ai_usage_question)
        expect(judge_questions_for_submission_score).to include(non_ai_usage_question)
        expect(judge_questions_for_submission_score).not_to include(no_ai_usage_question)
      end
    end

    context "when the submission does not use AI" do
      let(:ai_usage) { false }

      it "returns the no-AI usage question (and non-AI related questions, where ai_usage is not defined on the question)" do
        expect(judge_questions_for_submission_score).to include(no_ai_usage_question)
        expect(judge_questions_for_submission_score).to include(non_ai_usage_question)
        expect(judge_questions_for_submission_score).not_to include(ai_usage_question)
      end
    end
  end
end
