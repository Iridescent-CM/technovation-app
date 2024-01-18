module ChapterAmbassadorProfileAdditionController
  extend ActiveSupport::Concern

  def create
    account = Account.find(params.fetch(:account_id))
    chapter_ambassador_profile_addition_result = ChapterAmbassadorProfileAddition.new(account: account).call

    redirect_to send("#{current_scope}_participant_path", id: account.to_param),
      flash: chapter_ambassador_profile_addition_result.message
  end
end
