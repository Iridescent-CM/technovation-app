module Admin
  class SpecialsController < AdminController
    def show
      accounts = Account.where(id: [29481, 46986])

      json = accounts.map { |account|
        {
          account: account,
          mentor: account.mentor_profile,
          team_ids: account.mentor_profile.team_ids,
          background_check: account.mentor_profile.background_check,
          consent_waiver: account.mentor_profile.consent_waiver,
        }
      }

      render json: json
    end
  end
end
