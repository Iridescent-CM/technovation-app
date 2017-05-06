module Legacy
  module V2
    class Student::ParentalConsentNoticesController < StudentController
      def create
        if profile_params
          current_student.assign_attributes(profile_params)
          current_student.validate_parent_email

          unless current_student.validate_parent_email && current_student.save
            render :new and return
          end
        else
          ParentMailer.consent_notice(current_student.id).deliver_later
        end

        flash[:success] = t("controllers.student.parental_consent_notices.create.success")
        redirect_to student_dashboard_path
      end

      private
      def profile_params
        if params.fetch(:student_profile) { false }
          params.require(:student_profile).permit(:parent_guardian_email, :parent_guardian_name)
        end
      end
    end
  end
end
