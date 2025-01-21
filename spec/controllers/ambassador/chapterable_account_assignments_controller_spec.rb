require "rails_helper"

RSpec.describe Ambassador::ChapterableAccountAssignmentsController do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }
  let(:chapter) { chapter_ambassador.chapter }
  let(:student_profile) { FactoryBot.create(:student_profile, :unaffiliated_chapter) }

  before do
    allow(AccountMailer).to receive_message_chain(:chapterable_assigned, :deliver_later)

    sign_in(chapter_ambassador)
  end

  describe "POST #create" do
    context "when a chapter ambassador assigns an unaffiliated student to their chapter" do
      it "sets 'no chapter selected' to nil for the student's account" do
        post :create, params: {
          account_id: student_profile.account.id,
          chapterable: "#{chapter.id},Chapter"
        }

        expect(student_profile.account.reload.no_chapterable_selected).to be_nil
      end

      it "assigns the student to the chapter ambassador's chapter" do
        post :create, params: {
          account_id: student_profile.account.id,
          chapterable: "#{chapter.id},Chapter"
        }

        expect(student_profile.account.reload.current_chapter).to eq(chapter)
      end

      it "makes a call to send the chapter assigned email to the student" do
        expect(AccountMailer).to receive_message_chain(:chapterable_assigned, :deliver_later)

        post :create, params: {
          account_id: student_profile.account.id,
          chapterable: "#{chapter.id},Chapter"
        }
      end
    end
  end
end
