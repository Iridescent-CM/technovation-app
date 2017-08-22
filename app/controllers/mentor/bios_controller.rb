module Mentor
  class BiosController < MentorController
    def update
      if bio_params[:bio].blank?
        current_mentor.errors.add(:bio, :blank)
        render :edit
      elsif ProfileUpdating.execute(current_mentor, current_scope, bio_params)
        redirect_to mentor_dashboard_path, success: "Thank you for telling us more!"
      else
        render :edit
      end
    end

    private
    def bio_params
      params.require(:mentor_profile).permit(:bio)
    end
  end
end
