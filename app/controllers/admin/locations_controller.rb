module Admin
  class LocationsController < AdminController
    include LocationController

    private

    def db_record
      @db_record ||= if params.has_key?(:account_id)
        Account.find(params.fetch(:account_id))
      elsif params.has_key?(:team_id)
        Team.find(params.fetch(:team_id))
      elsif params.has_key?(:chapter_id)
        Chapter.find(params.fetch(:chapter_id))
      elsif params.has_key?(:club_id)
        Club.find(params.fetch(:club_id))
      end
    end
  end
end
