module TeamSubmissionController
  extend ActiveSupport::Concern

  def new
    SeasonToggles.team_submissions(
      open:   -> { respond_according_to_presence },
      closed: -> { notify_on_dashboard },
    )
  end

  def show
    @team_submission = TeamSubmission.friendly.find(params[:id])
    @team = @team_submission.team

    @code_checklist = @team_submission.code_checklist

    unless @code_checklist.present?
      @code_checklist = @team_submission.build_code_checklist
    end

    SeasonToggles.team_submissions(
      open:   -> { render piece_or_full_edit },
      closed: -> { notify_on_dashboard }
    )
  end

  private
  def notify_on_dashboard
    redirect_to [current_scope, :dashboard],
      alert: "Sorry, submissions are not editable at this time"
  end

  def respond_according_to_presence
    if current_team.submission.present?
      redirect_to [current_scope, current_team.submission]
    else
      @team_submission = current_team.team_submissions.build
      render "team_submissions/new"
    end
  end

  def piece_or_full_edit
    if params.fetch(:piece) { false }
      "team_submissions/pieces/#{params.fetch(:piece)}"
    else
      "edit"
    end
  end
end
