module TeamSubmissionController
  extend ActiveSupport::Concern

  included do
    layout "submissions", except: :new
    helper_method :piece_name

    before_action -> {
      @submission_section = SubmissionSection.new(piece_name, self)
    }, only: [:edit, :show]
  end

  def new
    SeasonToggles.team_submissions(
      open:   -> { respond_according_to_presence },
      closed: -> { notify_on_dashboard },
    )
  end

  def create
    @team_submission = if current_team.submission.present?
                          current_team.submission
                        else
                          current_team.team_submissions.build(
                            team_submission_params
                          )
                        end

    if @team_submission.save
      current_team.create_activity(
        trackable: current_account,
        key: "submission.create",
        recipient: @team_submission,
      )
      redirect_to [current_scope, @team_submission],
        success: t("controllers.team_submissions.create.success")
    else
      render "team_submissions/new"
    end
  end

  def edit
    unless SeasonToggles.team_submissions_editable?
      redirect_to send("#{current_scope}_dashboard_path") and return
    end

    @team_submission = current_team.submission
    @team = current_team

    if params[:attributes]
      JSON.parse(params[:attributes]).each do |k, v|
        @team_submission.public_send("#{k}=", v)
      end

      @team_submission.valid?
    end

    @team_submission.screenshots.build

    unless @team_submission.business_plan.present?
      @team_submission.build_business_plan
    end

    unless @team_submission.pitch_presentation.present?
      @team_submission.build_pitch_presentation
    end

    if @team_submission.code_checklist.present?
      @code_checklist = @team_submission.code_checklist
    else
      @code_checklist = @team_submission.build_code_checklist
    end

    if @team_submission.present?
      begin
        render "team_submissions/pieces/#{piece_name}"
      rescue ActionView::MissingTemplate,
              ActionController::ParameterMissing
        redirect_to [current_scope, @team_submission]
      end
    else
      redirect_to [:new, current_scope, :team_submission]
    end
  end

  def show
    @team_submission = TeamSubmission.friendly.find(params[:id])
    @team = @team_submission.team

    @code_checklist = @team_submission.code_checklist

    unless @code_checklist.present?
      @code_checklist = @team_submission.build_code_checklist
    end

    unless @team_submission.business_plan.present?
      @team_submission.build_business_plan
    end

    @uploader = ImageUploader.new
    @uploader.success_action_redirect = send(
      "#{current_scope}_team_photo_upload_confirmation_url",
      team_id: @team.id,
      back: request.fullpath
    )

    SeasonToggles.team_submissions(
      open:   -> { render piece_or_full_edit },
      closed: -> { notify_on_dashboard }
    )
  end

  def update
    @team_submission = current_team.submission

    if team_submission_params[:screenshots]
      team_submission_params[:screenshots].each_with_index do |id, i|
        screenshot = @team_submission.screenshots.find(id)
        screenshot.update(sort_position: i)
      end

      render json: {}
    elsif @team_submission.update(team_submission_params)
      if @team_submission.saved_change_to_app_name?
        @team_submission.reload
      end

      current_team.create_activity(
        trackable: current_account,
        key: "submission.update",
        recipient: @team_submission,
      )

      if request.xhr?
        render json: {}
      else
        redirect_to [
          current_scope,
          @team_submission,
          :section,
          section: SubmissionSection.new(piece_name, self),
        ],
          success: t("controllers.team_submissions.update.success")
      end
    else
      redirect_to send("edit_#{current_scope}_team_submission_path",
        @team_submission,
        piece: params[:piece],
        attributes: @team_submission.attributes.to_json,
      )
    end
  end

  private
  def piece_name
    params.fetch(:piece) { "" }
  end

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
      section = get_cookie(:last_visited_submission_section) ||
        :ideation

      "team_submissions/sections/#{section}"
    end
  end

  def team_submission_params
    if SeasonToggles.team_submissions_editable?
      params.require(:team_submission).permit(
        :team_id,
        :integrity_affirmed,
        :source_code,
        :app_description,
        :app_name,
        :demo_video_link,
        :pitch_video_link,
        :development_platform_other,
        :development_platform,
        :app_inventor_app_name,
        :app_inventor_gmail,
        screenshots: [],
        screenshots_attributes: [
          :id,
          :image,
        ],
        business_plan_attributes: [
          :id,
          :uploaded_file,
        ],
        pitch_presentation_attributes: [
          :id,
          :uploaded_file,
        ],
      )
    else
      params.require(:team_submission).permit(
        pitch_presentation_attributes: [
          :id,
          :remote_file_url,
        ],
      )
    end
  end
end
