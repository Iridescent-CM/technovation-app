require "rails_helper"

RSpec.describe "Tasks: surveys namespace" do

  let!(:past_student_who_took) {
    Timecop.travel(1.year.ago) do
      student = FactoryBot.create(:student, :past).account
      student.took_program_survey!
      student
    end
  }

  let!(:past_student_who_ignored) {
    Timecop.travel(1.year.ago) do
      student = FactoryBot.create(:student, :past).account
      5.times.collect { student.reminded_about_survey! }
      student
    end
  }

  let!(:past_mentor_who_took) {
    Timecop.travel(1.year.ago) do
      mentor = FactoryBot.create(:mentor, :past).account
      mentor.took_program_survey!
      mentor
    end
  }

  let!(:past_mentor_who_ignored) {
    Timecop.travel(1.year.ago) do
      mentor = FactoryBot.create(:mentor, :past).account
      5.times.collect { mentor.reminded_about_survey! }
      mentor
    end
  }

  let!(:current_student_who_took) {
    Timecop.travel(3.days.ago) do
      student = FactoryBot.create(:student).account
      student.took_program_survey!
      student
    end
  }

  let!(:current_student_who_ignored) {
    Timecop.travel(3.days.ago) do
      student = FactoryBot.create(:student).account
      5.times.collect { student.reminded_about_survey! }
      student
    end
  }

  let!(:current_mentor_who_took) {
    Timecop.travel(3.days.ago) do
      mentor = FactoryBot.create(:mentor).account
      mentor.took_program_survey!
      mentor
    end
  }

  let!(:current_mentor_who_ignored) {
    Timecop.travel(3.days.ago) do
      mentor = FactoryBot.create(:mentor).account
      5.times.collect { mentor.reminded_about_survey! }
      mentor
    end
  }

  context "rails surveys:reset_all" do
    let(:task) { Rake::Task['surveys:reset_all'] }
    after(:each) { task.reenable }

    %w[student mentor].each do |type|
      it "resets current #{type} who took survey" do
        account = public_send("current_#{type}_who_took")

        expect(account.took_program_survey?).to be true

        task.invoke
        account.reload

        expect(account.took_program_survey?).to be false
        expect(account.needs_survey_reminder?).to be true
      end

      it "resets past #{type} who took survey" do
        account = public_send("past_#{type}_who_took")

        expect(account.took_program_survey?).to be true

        task.invoke
        account.reload

        expect(account.took_program_survey?).to be false

        Timecop.travel(3.days.ago) do
          RegisterToCurrentSeasonJob.perform_now(account)
        end

        expect(account.needs_survey_reminder?).to be true
      end

      it "resets current #{type} who ignored survey" do
        account = public_send("current_#{type}_who_ignored")

        expect(account.needs_survey_reminder?).to be false

        task.invoke
        account.reload

        expect(account.took_program_survey?).to be false
        expect(account.needs_survey_reminder?).to be true
      end

      it "resets past #{type} who ignored survey" do
        account = public_send("past_#{type}_who_ignored")

        expect(account.needs_survey_reminder?).to be false

        task.invoke
        account.reload

        expect(account.took_program_survey?).to be false

        Timecop.travel(3.days.ago) do
          RegisterToCurrentSeasonJob.perform_now(account)
        end

        expect(account.needs_survey_reminder?).to be true
      end
    end
  end

  context "rails surveys:reset_students" do
    let(:task) { Rake::Task['surveys:reset_students'] }
    after(:each) { task.reenable }

    it "resets current students who took survey" do
      account = current_student_who_took

      expect(account.took_program_survey?).to be true

      task.invoke
      account.reload

      expect(account.took_program_survey?).to be false
      expect(account.needs_survey_reminder?).to be true
    end

    it "resets past students who took survey" do
      account = past_student_who_took

      expect(account.took_program_survey?).to be true

      task.invoke
      account.reload

      expect(account.took_program_survey?).to be false

      Timecop.travel(3.days.ago) do
        RegisterToCurrentSeasonJob.perform_now(account)
      end

      expect(account.needs_survey_reminder?).to be true
    end

    it "resets current students who ignored survey" do
      account = current_student_who_ignored

      expect(account.needs_survey_reminder?).to be false

      task.invoke
      account.reload

      expect(account.took_program_survey?).to be false
      expect(account.needs_survey_reminder?).to be true
    end

    it "resets past students who ignored survey" do
      account = past_student_who_ignored

      expect(account.needs_survey_reminder?).to be false

      task.invoke
      account.reload

      expect(account.took_program_survey?).to be false

      Timecop.travel(3.days.ago) do
        RegisterToCurrentSeasonJob.perform_now(account)
      end

      expect(account.needs_survey_reminder?).to be true
    end

    it "doesn't touch mentors" do
      task.invoke

      expect(past_mentor_who_took.took_program_survey?).to be true
      expect(current_mentor_who_took.took_program_survey?).to be true

      Timecop.travel(3.days.ago) do
        RegisterToCurrentSeasonJob.perform_now(past_mentor_who_ignored)
      end

      expect(past_mentor_who_ignored.needs_survey_reminder?).to be false
      expect(current_mentor_who_ignored.needs_survey_reminder?).to be false
    end
  end

  context "rails surveys:reset_mentors" do
    let(:task) { Rake::Task['surveys:reset_mentors'] }
    after(:each) { task.reenable }

    it "resets current mentors who took survey" do
      account = current_mentor_who_took

      expect(account.took_program_survey?).to be true

      task.invoke
      account.reload

      expect(account.took_program_survey?).to be false
      expect(account.needs_survey_reminder?).to be true
    end

    it "resets past mentors who took survey" do
      account = past_mentor_who_took

      expect(account.took_program_survey?).to be true

      task.invoke
      account.reload

      expect(account.took_program_survey?).to be false

      Timecop.travel(3.days.ago) do
        RegisterToCurrentSeasonJob.perform_now(account)
      end

      expect(account.needs_survey_reminder?).to be true
    end

    it "resets current mentors who ignored survey" do
      account = current_mentor_who_ignored

      expect(account.needs_survey_reminder?).to be false

      task.invoke
      account.reload

      expect(account.took_program_survey?).to be false
      expect(account.needs_survey_reminder?).to be true
    end

    it "resets past mentors who ignored survey" do
      account = past_mentor_who_ignored

      expect(account.needs_survey_reminder?).to be false

      task.invoke
      account.reload

      expect(account.took_program_survey?).to be false

      Timecop.travel(3.days.ago) do
        RegisterToCurrentSeasonJob.perform_now(account)
      end

      expect(account.needs_survey_reminder?).to be true
    end

    it "doesn't touch students" do
      task.invoke

      expect(past_student_who_took.took_program_survey?).to be true
      expect(current_student_who_took.took_program_survey?).to be true

      Timecop.travel(3.days.ago) do
        RegisterToCurrentSeasonJob.perform_now(past_student_who_ignored)
      end

      expect(past_student_who_ignored.needs_survey_reminder?).to be false
      expect(current_student_who_ignored.needs_survey_reminder?).to be false
    end
  end
end
