class NewRegistrationController < ApplicationController
  after_action :update_registration_invite, only: :create
  after_action :assign_ambassador_to_chapterable, only: :create

  layout "new_registration"

  def show
    if SeasonToggles.registration_closed?
      if params[:invite_code].present?
        invite = RegistrationInviteCodeValidator.new(invite_code: params[:invite_code]).call

        if !invite.valid?
          redirect_to "/", error: "This invitation is no longer valid"
        end
      elsif params[:team_invite_code].present?
        invite = TeamInviteCodeValidator.new(team_invite_code: params[:team_invite_code]).call

        if !invite.valid?
          redirect_to "/", error: "This team invitation is no longer valid"
        end
      else
        redirect_to "/"
      end
    end
  end

  def create
    case params[:profileType]
    when "student"
      @profile = StudentProfile.new(student_params)
    when "parent"
      @profile = StudentProfile.new(parent_params)
    when "mentor"
      @profile = MentorProfile.new(mentor_params)
    when "judge"
      @profile = JudgeProfile.new(judge_params)
    when "chapter_ambassador"
      @profile = ChapterAmbassadorProfile.new(chapter_ambassador_params)
    when "club_ambassador"
      @profile = ClubAmbassadorProfile.new(club_ambassador_params)
    end

    if @profile.save
      TeamMemberInvite.match_registrant(@profile)

      SignIn.call(
        @profile.account,
        self,
        enable_redirect: false
      )
    else
      errors = ValidationErrorMessagesConverter.new(errors: @profile.errors)

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
      school_company_name: registration_params[:mentorSchoolCompanyName],
      job_title: registration_params[:mentorJobTitle],
      bio: registration_params[:mentorBio],
      expertise_ids: registration_params["mentorExpertises"],
      mentor_type_ids: registration_params["mentorTypes"],
      account_attributes: account_attributes.merge({
        phone_number: registration_params[:phoneNumber],
        gender: registration_params[:gender],
        meets_minimum_age_requirement: registration_params[:meetsMinimumAgeRequirement]
      })
    }
  end

  def judge_params
    {
      company_name: registration_params[:judgeSchoolCompanyName],
      job_title: registration_params[:judgeJobTitle],
      judge_type_ids: registration_params["judgeTypes"],
      account_attributes: account_attributes.merge({
        phone_number: registration_params[:phoneNumber],
        gender: registration_params[:gender],
        meets_minimum_age_requirement: registration_params[:meetsMinimumAgeRequirement]
      })
    }
  end

  def chapter_ambassador_params
    {
      job_title: registration_params[:chapterAmbassadorJobTitle],
      organization_status: registration_params[:chapterAmbassadorOrganizationStatus],
      account_attributes: account_attributes.merge({
        phone_number: registration_params[:phoneNumber],
        gender: registration_params[:gender],
        meets_minimum_age_requirement: registration_params[:meetsMinimumAgeRequirement]
      })
    }
  end

  def club_ambassador_params
    {
      job_title: registration_params[:clubAmbassadorJobTitle],
      account_attributes: account_attributes.merge({
        phone_number: registration_params[:phoneNumber],
        gender: registration_params[:gender],
        meets_minimum_age_requirement: registration_params[:meetsMinimumAgeRequirement]
      })
    }
  end

  def account_attributes
    {
      first_name: registration_params[:firstName],
      last_name: registration_params[:lastName],
      date_of_birth: registration_params[:dateOfBirth],
      referred_by: registration_params[:referredBy].nil? ? nil : registration_params[:referredBy].to_i,
      referred_by_other: registration_params[:referredByOther],
      terms_agreed_at: registration_params[:dataTermsAgreedTo].present? ? Time.current : nil,
      email: registration_params[:email],
      password: registration_params[:password]
    }
  end

  def registration_params
    params.require(:new_registration).permit(
      :inviteCode,
      :profileType,
      :firstName,
      :lastName,
      :dateOfBirth,
      :meetsMinimumAgeRequirement,
      :phoneNumber,
      :gender,
      :email,
      :password,
      :dataTermsAgreedTo,
      :referredBy,
      :referredByOther,
      :studentParentGuardianName,
      :studentParentGuardianEmail,
      :studentSchoolName,
      :mentorType,
      :mentorSchoolCompanyName,
      :mentorJobTitle,
      :mentorBio,
      :judgeSchoolCompanyName,
      :judgeJobTitle,
      :chapterAmbassadorJobTitle,
      :chapterAmbassadorBio,
      :chapterAmbassadorOrganizationStatus,
      :clubAmbassadorJobTitle,
      mentorExpertises: [],
      mentorTypes: [],
      judgeTypes: []
    )
  end

  def update_registration_invite
    if params[:inviteCode].present?
      UpdateRegistrationInviteJob.perform_later(
        invite_code: params[:inviteCode],
        account_id: @profile.account.id
      )
    end
  end

  def assign_ambassador_to_chapterable
    if params[:inviteCode].present? &&
        (params[:profileType] == "chapter_ambassador" || params[:profileType] == "club_ambassador")

      AssignAmbassadorToChapterableJob.perform_later(
        invite_code: params[:inviteCode],
        ambassador_profile_id: @profile.id
      )
    end
  end
end
