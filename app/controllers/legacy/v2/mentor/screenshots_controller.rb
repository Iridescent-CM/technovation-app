module Legacy
  module V2
    module Mentor
      class ScreenshotsController < MentorController
        include ActionView::Helpers::AssetTagHelper

        def index
          screenshots = current_team.current_team_submission.screenshots.map do |s|
            {
              id: s.id,
              image_url: s.image_url,
              image_alt: image_alt(s.image_url),
              sort_position: s.sort_position,
              delete_url: mentor_screenshot_url(s, team_id: current_team.id),
            }
          end

          render json: screenshots
        end

        def destroy
          screenshot = Screenshot.find(params[:id])

          if current_team.current_team_submission.screenshots.include?(screenshot)
            screenshot.destroy
            head 200
          else
            head 403
          end
        end
      end
    end
  end
end
