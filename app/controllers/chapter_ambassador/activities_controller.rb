module ChapterAmbassador
  class ActivitiesController < ChapterAmbassadorController
    include DatagridController

    use_datagrid with: ActivitiesGrid,

      html_scope: ->(scope, user, params) {
        trackable_user_ids = Account.current
          .not_staff
          .in_region(user)
          .pluck(:id) - [user.account_id]

        trackable_team_ids = Team.current
          .in_region(user)
          .pluck(:id)

        scope.where("
            (activities.trackable_id IN (?) AND
              activities.trackable_type = ?) OR

            (activities.trackable_id IN (?) AND
              activities.trackable_type = ?)
          ",
          trackable_user_ids,
          "Account",
          trackable_team_ids,
          "Team",
        )
        .page(params[:page])
      }

    private
    def grid_params
      params[:activities_grid] ||= {}
    end
  end
end
