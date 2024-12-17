module Admin
  class ClubAmbassadorProfileAdditionsController < AdminController
    def create
      account = Account.find(params.fetch(:account_id))
      club_ambassador_profile_addition_result = ClubAmbassadorProfileAddition.new(account: account).call

      redirect_to admin_participant_path(account),
        flash: club_ambassador_profile_addition_result.message
    end
  end
end
