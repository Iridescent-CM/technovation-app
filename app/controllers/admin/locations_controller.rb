module Admin
  class LocationsController < AdminController
    include LocationController

    private

    def db_record
      @db_record ||= if account_id = params.fetch(:account_id) { false }
        Account.find(account_id)
      else
        Team.find(params.fetch(:team_id))
      end
    end
  end
end
