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
      account_attributes: account_attributes
    }
  end

  def account_attributes
    {
      first_name: registration_params[:firstName],
      last_name: registration_params[:lastName],
      date_of_birth: registration_params[:birthday],
      email: registration_params[:accountEmail],
      terms_agreed_at: registration_params[:dataTermsAgreedTo].present? ? Time.current : nil,
      password: registration_params[:password]
    }
  end

  def registration_params
    params.require(:new_registration).permit(
      :profileType,
      :firstName,
      :lastName,
      :birthday,
      :accountEmail,
      :password,
      :dataTermsAgreedTo,
      :parentName,
      :parentEmail,
      :schoolName
    )
  end
end
