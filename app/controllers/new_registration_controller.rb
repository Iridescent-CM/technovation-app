class NewRegistrationController < ApplicationController
  layout "new_registration"

  def show
  end

  def create
    case params[:profileType]
    when "student"
      profile = StudentProfile.new(student_params)
    when "parent"
      profile = StudentProfile.new(parent_params)
    when "mentor"
      profile = MentorProfile.new(mentor_params)
    end

    if profile.save
      case params[:profileType]
      when "mentor"
        RegistrationMailer.welcome_mentor(profile.account.id).deliver_later
      end

      SignIn.call(
        profile.account,
        self,
        message: "Welcome to Technovation!",
        redirect_to: "student_dashboard_path"
      )
    else
      errors = ValidationErrorMessagesConverter.new(errors: profile.errors)

      render json: {
        errors: errors.individual_errors,
        full_error_messages: errors.full_errors
      }, status: :unprocessable_entity
    end
  end

  private

  def student_params
    {
      parent_guardian_name: registration_params[:studentParentGuardianName],
      parent_guardian_email: registration_params[:studentParentGuardianEmail],
      school_name: registration_params[:studentSchoolName],
      account_attributes: account_attributes
    }
  end

  def parent_params
    {
      parent_guardian_name: registration_params[:studentParentGuardianName],
      parent_guardian_email: registration_params[:email],
      school_name: registration_params[:studentSchoolName],
      account_attributes: account_attributes.merge({parent_registered: true})
    }
  end

  def mentor_params
    {
      mentor_type: registration_params[:mentorType],
      school_company_name: registration_params[:mentorSchoolCompanyName],
      job_title: registration_params[:mentorJobTitle],
      bio: registration_params[:mentorBio],
      expertise_ids: registration_params["mentorExpertises"],
      account_attributes: account_attributes.merge({gender: registration_params[:gender]})
    }
  end

  def account_attributes
    {
      first_name: registration_params[:firstName],
      last_name: registration_params[:lastName],
      date_of_birth: registration_params[:dateOfBirth],
      referred_by: registration_params[:referredBy].to_i,
      terms_agreed_at: registration_params[:dataTermsAgreedTo].present? ? Time.current : nil,
      email: registration_params[:email],
      password: registration_params[:password]
    }
  end

  def registration_params
    params.require(:new_registration).permit(
      :profileType,
      :firstName,
      :lastName,
      :dateOfBirth,
      :gender,
      :email,
      :password,
      :dataTermsAgreedTo,
      :referredBy,
      :studentParentGuardianName,
      :studentParentGuardianEmail,
      :studentSchoolName,
      :mentorType,
      :mentorSchoolCompanyName,
      :mentorJobTitle,
      :mentorBio,
      mentorExpertises: []
    )
  end
end
