class Student::ParentalConsentNoticesController < StudentController
  def new
    @student_profile = current_student.student_profile
  end

  def create
    if profile_params
      @student_profile = current_student.student_profile
      @student_profile.assign_attributes(profile_params)
      @student_profile.validate_parent_email

      unless @student_profile.validate_parent_email && @student_profile.save
        render :new and return
      end
    else
      ParentMailer.consent_notice(current_student.student_profile).deliver_later
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
