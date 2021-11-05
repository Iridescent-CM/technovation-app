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
      render json: {errors: profile.errors}, status: :unprocessable_entity
    end
  end

  private

  def student_params
    {
      parent_guardian_name: registration_params[:parentName],
      school_name: registration_params[:schoolName],
      account_attributes: account_attributes
    }
  end

  def parent_params
    {
      parent_guardian_name: registration_params[:parentName],
      parent_guardian_email: registration_params[:accountEmail],
      school_name: registration_params[:schoolName],
      account_attributes: account_attributes
    }
  end

  def mentor_params
    {
      mentor_type: registration_params[:mentorType],
      school_company_name: registration_params[:companyName],
      job_title: registration_params[:jobTitle],
      bio: registration_params[:mentorSummary],
      expertise_ids: registration_params["mentorExpertises"],
      account_attributes: account_attributes.merge({gender: registration_params[:gender]})
    }
  end

  def account_attributes
    {
      first_name: registration_params[:firstName],
      last_name: registration_params[:lastName],
      date_of_birth: registration_params[:birthday],
      referred_by: registration_params[:referredBy].to_i,
      terms_agreed_at: registration_params[:dataTermsAgreedTo].present? ? Time.current : nil,
      email: registration_params[:accountEmail],
      password: registration_params[:password]
    }
  end

  def registration_params
    params.require(:new_registration).permit(
      :profileType,
      :firstName,
      :lastName,
      :birthday,
      :gender,
      :accountEmail,
      :password,
      :dataTermsAgreedTo,
      :referredBy,
      :parentName,
      :parentEmail,
      :schoolName,
      :companyName,
      :jobTitle,
      :mentorType,
      :mentorSummary,
      mentorExpertises: []
    )
  end
end
