module ScreenshotController
  extend ActiveSupport::Concern

  included do
    include ActionView::Helpers::AssetTagHelper
    include ActionView::RecordIdentifier
  end

  def index
    render(json: current_team.submission.screenshots.map do |s|
      {
        id: s.id,
        src: s.image_url,
        name: s.image.identifier,
        large_img_url: s.image_url(:large),
      }
    end)
  end

  def create
    submission = current_team.submission
    screenshot = submission.screenshots.create!(
      screenshot_params[:screenshots_attributes]
    )

    # TODO: why is submission.screenshots.create returning an array ??
    screenshot = Array(screenshot).first

    current_team.create_activity(
      trackable: current_account,
      key: "submission.update",
      parameters: { piece: "screenshots" },
      recipient: submission,
    )

    if request.xhr?
      render json: {
        id: screenshot.id,
        src: screenshot.image_url,
        name: screenshot.image.identifier,
        large_img_url: screenshot.image_url(:large),
      }
    else
      redirect_to send("#{current_scope}_submission_path", submission)
    end
  end

  def destroy
    screenshot = Screenshot.find(params[:id])

    if current_team.submission.screenshots.include?(screenshot)
      screenshot.destroy
      current_team.create_activity(
        trackable: current_account,
        key: "submission.update",
        parameters: { piece: "screenshots" },
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
      screenshots_attributes: :image,
    ).tap do |t|
      if Array(t[:screenshots_attributes])[0].dig("0")
        t[:screenshots_attributes] = Array(
          t[:screenshots_attributes]
        )[0].dig("0")
      end
    end
  end
end
