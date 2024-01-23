module Admin
  class ChapterAmbassadorProfileAdditionsController < AdminController
    def create
      account = Account.find(params.fetch(:account_id))
      chapter_ambassador_profile_addition_result = ChapterAmbassadorProfileAddition.new(account: account).call

      redirect_to admin_participant_path(account),
        flash: chapter_ambassador_profile_addition_result.message
    end
  end
end
