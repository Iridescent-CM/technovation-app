module TeamSubmissionController
  extend ActiveSupport::Concern

  included do
    helper_method :piece_name
    layout :determine_layout

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
      redirect_to send("#{current_scope}_team_submission_section_path",
        @team_submission,
        section: SubmissionSection::SECTION_NAMES[1]
      ),
        success: t("controllers.team_submissions.create.success")
    else
      render "team_submissions/new"
    end
  end

  def edit
    unless SeasonToggles.team_submissions_editable? or piece_name == 'pitch_presentation'
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

    @source_code_uploader = FileUploader.new
    @source_code_uploader.success_action_redirect = send(
      "#{current_scope}_team_submission_file_upload_confirmation_url",
      team_id: @team.id,
      back: request.fullpath
    )

    if @team_submission.present?
      begin
        render "team_submissions/pieces/#{piece_name}"
      rescue ActionView::MissingTemplate,
              ActionController::ParameterMissing
        redirect_to send("#{current_scope}_team_submission_path", @team_submission)
      end
    else
      redirect_to send("new_#{current_scope}_team_submissions_path")
    end
  end

  def show
    @team_submission = TeamSubmission.friendly.find(params[:id])
    @team = @team_submission.team

    @uploader = ImageDirectUploader.new
    @uploader.success_action_redirect = send(
      "#{current_scope}_team_photo_upload_confirmation_url",
      team_id: @team.id,
      back: request.fullpath
    )

    @source_code_uploader = FileUploader.new
    @source_code_uploader.success_action_redirect = send(
      "#{current_scope}_team_submission_file_upload_confirmation_url",
      team_id: @team.id,
      back: request.fullpath
    )

    if SeasonToggles.team_submissions_editable? or piece_name == 'pitch_presentation'
      render piece_or_full_edit
    else
      notify_on_dashboard
    end
  end

  def update
    @team_submission = current_team.submission

    if team_submission_params[:screenshots]
      handle_screenshots_update(@team_submission)
    elsif team_submission_params[:pitch_video_link]
      handle_video_link_review(@team_submission, :pitch_video_link)
    elsif team_submission_params[:demo_video_link]
      handle_video_link_review(@team_submission, :demo_video_link)
    elsif @team_submission.update(team_submission_params)
      if request.xhr? && team_submission_params[:pitch_presentation]
        piece_name = "pitch_presentation"
      elsif request.xhr? && team_submission_params[:business_plan]
        piece_name = "business_plan"
      else
        piece_name = params.fetch(:piece, "")
      end

      if @team_submission.saved_change_to_app_name?
        @team_submission.reload
      end

      current_team.create_activity(
        trackable: current_account,
        key: "submission.update",
        parameters: { piece: piece_name },
        recipient: @team_submission,
      )

      if request.xhr?
        render json: {}
      else
        redirect_to send("#{current_scope}_team_submission_section_path",
          @team_submission,
          section: SubmissionSection.new(piece_name, self)
        ),
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
  def handle_screenshots_update(submission)
    team_submission_params[:screenshots].each_with_index do |id, i|
      screenshot = submission.screenshots.find(id)
      screenshot.update(sort_position: i)
    end

    current_team.create_activity(
      trackable: current_account,
      key: "submission.update",
      parameters: { piece: "screenshots" },
      recipient: submission,
    )

    render json: {}
  end

  def handle_video_link_review(submission, method)
    @team_submission = submission
    @method = method
    @review_value = team_submission_params[method]
    render 'team_submission_video_link_reviews/new'
  end

  def determine_layout
    if action_name == "new" ||
        action_name == "create"
      "application"
    else
      "submissions"
    end
  end

  def piece_name
    params.fetch(:piece) { "" }
  end

  def notify_on_dashboard
    redirect_to send("#{current_scope}_dashboard_path"),
      alert: "Sorry, submissions are not editable at this time"
  end

  def respond_according_to_presence
    if current_team.submission.present?
      redirect_to send("#{current_scope}_team_submission_path", current_team.submission)
    else
      @team_submission = current_team.team_submissions.build
      render "team_submissions/new"
    end
  end

  def piece_or_full_edit
    if params.fetch(:piece) { false }
      "team_submissions/pieces/#{params.fetch(:piece)}"
    else
      section = get_cookie(CookieNames::LAST_VISITED_SUBMISSION_SECTION) ||
        SubmissionSection::SECTION_NAMES[1]

      if section.to_s.downcase == "marketing"
        section = "pitch"
      end

      "team_submissions/sections/#{section}"
    end
  end

  def team_submission_params
    if SeasonToggles.team_submissions_editable?
      params.require(:team_submission).permit(
        :team_id,
        :integrity_affirmed,
        :source_code,
        :source_code_external_url,
        :business_plan,
        :pitch_presentation,
        :app_name,
        :app_description,
        :learning_journey,
        :ai,
        :ai_description,
        :climate_change,
        :climate_change_description,
        :solves_hunger_or_food_waste,
        :solves_hunger_or_food_waste_description,
        :uses_open_ai,
        :uses_open_ai_description,
        :demo_video_link,
        :pitch_video_link,
        :submission_type,
        :development_platform_other,
        :development_platform,
        :app_inventor_app_name,
        :app_inventor_gmail,
        :thunkable_project_url,
        :thunkable_account_email,
        screenshots: [],
        screenshots_attributes: [
          :id,
          :image,
        ],
      )
    else
      params.require(:team_submission).permit(
        :pitch_presentation,
      )
    end
  end
end
