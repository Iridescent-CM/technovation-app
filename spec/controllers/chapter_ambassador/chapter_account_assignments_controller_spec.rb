require "rails_helper"

RSpec.describe ChapterAmbassador::ChapterAccountAssignmentsController do
  let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador) }
  let(:chapter) { chapter_ambassador.chapter }
  let(:student_profile) { FactoryBot.create(:student_profile, :unaffiliated_chapter) }

  before do
    allow(AccountMailer).to receive_message_chain(:chapter_assigned, :deliver_later)

    sign_in(chapter_ambassador)
  end

  describe "POST #create" do
    context "when a Chapter Ambassador assigns an unaffiliated student to their chapter" do
      it "sets 'no chapter selected' to nil for the student's account" do
        post :create, params: {
          account_id: student_profile.account.id,
          chapter_account_assignment: {
            chapter_id: chapter.id
          }
        }

        expect(student_profile.account.reload.no_chapterable_selected).to be_nil
      end

      it "assigns the student to the Chapter Ambassador's chapter" do
        post :create, params: {
          account_id: student_profile.account.id,
          chapter_account_assignment: {
            chapter_id: chapter.id
          }
        }

        expect(student_profile.account.reload.current_chapter).to eq(chapter)
      end

      it "makes a call to send the chapter assigned email to the student" do
        expect(AccountMailer).to receive_message_chain(:chapter_assigned, :deliver_later)

        post :create, params: {
          account_id: student_profile.account.id,
          chapter_account_assignment: {
            chapter_id: chapter.id
          }
        }
      end
    end
  end
end
