module ScreenshotController
  extend ActiveSupport::Concern

  included do
    include ActionView::Helpers::AssetTagHelper
    include ActionView::RecordIdentifier
  end

  def index
    screenshots = current_team.submission.screenshots.map do |s|
      {
        id: s.id,
        image_url: s.image_url,
        image_alt: image_alt(s.image_url),
        sort_position: s.sort_position,
        delete_url: send("#{current_scope}_screenshot_url", s),
      }
    end

    render json: screenshots
  end

  def create
    submission = current_team.submission
    submission.update(screenshot_params)
    screenshot = submission.screenshots.last
    current_account.create_activity(
      trackable: submission,
      key: "submission.update",
      recipient: submission,
    )

    respond_to do |format|
      format.html do
        redirect_to [current_scope, submission]
      end

      format.json do
        render json: {
          remove_url: send(
            "#{current_scope}_screenshot_path",
            screenshot,
            team_submission: {
              id: submission.id,
            }
          ),
          dom_id: dom_id(screenshot),
          image: {
            id: screenshot.id,
            alt: screenshot.image_identifier,
            url: screenshot.image_url,
            modal_url: screenshot.image_url(:large),
          },
        }
      end
    end
  end

  def destroy
    screenshot = Screenshot.find(params[:id])

    if current_team.submission.screenshots.include?(screenshot)
      screenshot.destroy
      current_account.create_activity(
        trackable: screenshot.team_submission,
        key: "submission.update",
        recipient: screenshot.team_submission,
      )
      render json: {}
    else
      render json: {}, status: 403
    end
  end

  private
  def screenshot_params
    params.require(:team_submission).permit(
      screenshots_attributes: [
        :id,
        :image,
      ],
    )
  end
end
