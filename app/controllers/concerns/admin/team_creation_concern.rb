module Admin::TeamCreationConcern
  extend ActiveSupport::Concern

  def create
    account = Account.find(params.fetch(:account_id))
    @team = Team.new(
      name: params.fetch(:team_name),
      division: Division.for(account)
    )

    if @team.save
      TeamCreating.execute(
        @team,
        account.student_profile || account.mentor_profile,
        self
      )
    else
      flash[:error] = "There was an error creating this team: #{@team.errors.full_messages.join(", ")}"

      redirect_back fallback_location: send(:"#{current_scope}_participant_path", account)
    end
  end
end
