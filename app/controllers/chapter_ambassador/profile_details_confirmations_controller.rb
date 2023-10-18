module ChapterAmbassador
  class ProfileDetailsConfirmationsController < ApplicationController
    def create
      @chapter_ambassador_profile = ChapterAmbassadorProfile.new(
        chapter_ambassador_profile_params
      )

      if @chapter_ambassador_profile.save
        remove_cookie(CookieNames::ADMIN_PERMISSION_TOKEN)
        ProfileCreating.execute(@chapter_ambassador_profile, self)
      else
        render "chapter_ambassador/signups/new"
      end
    end

    def update
      @chapter_ambassador_profile = ChapterAmbassadorProfile.find(
        chapter_ambassador_profile_params.fetch(:id)
      )

      if ProfileUpdating.execute(
          @chapter_ambassador_profile,
          :chapter_ambassador,
          chapter_ambassador_profile_params
      )

        remove_cookie(CookieNames::ADMIN_PERMISSION_TOKEN)
        remove_cookie(CookieNames::SIGNUP_TOKEN)

        SignIn.(
          @chapter_ambassador_profile.account,
          self,
          message: "Thank you! Welcome to Technovation!"
        )
      else
        render "chapter_ambassador/signups/new"
      end
    end

    private
    def chapter_ambassador_profile_params
      params.require(:chapter_ambassador_profile).permit(
        :id,
        :organization_company_name,
        :job_title,
        :bio,
        account_attributes: [
          :id,
          :first_name,
          :last_name,
          :email,
          :date_of_birth,
          :gender,
          :password,
        ]
      ).tap do |tapped|
        tapped[:status] = :approved
        tapped[:account_attributes][:skip_existing_password] = true
        if action_name == "create"
          tapped[:account_attributes][:email] = UserInvitation.find_by!(
            admin_permission_token: get_cookie(CookieNames::ADMIN_PERMISSION_TOKEN)
          ).email
        end
      end
    end
  end
end
