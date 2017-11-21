module RegionalAmbassador
  class ActivitiesController < RegionalAmbassadorController
    def index
      trackable_user_ids = Account.current
        .not_staff
        .in_region(current_ambassador)
        .pluck(:id) - [current_ambassador.account_id]

      trackable_team_ids = Team.current
        .in_region(current_ambassador)
        .pluck(:id)

      @activities = PublicActivity::Activity.distinct
        .where("
            (activities.trackable_id IN (?) AND activities.trackable_type = ?) OR
            (activities.trackable_id IN (?) AND activities.trackable_type = ?)
          ",
          trackable_user_ids,
          "Account",
          trackable_team_ids,
          "Team"
        )
        .order("created_at desc")
        .page(params[:page])
    end
  end
end
