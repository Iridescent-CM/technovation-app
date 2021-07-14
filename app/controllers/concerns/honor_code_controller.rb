module HonorCodeController
  extend ActiveSupport::Concern

  def show
    if current_team.submission.present?
      redirect_to 
        send("#{current_scope}_team_submission_path", 
          current_team.submission,
          piece: :honor_code
        )[
        current_scope,
        current_team.submission,
        piece: :honor_code,
      ]
    else
      redirect_to send("new_#{current_scope}_team_submission_path")
    end
  end
end
