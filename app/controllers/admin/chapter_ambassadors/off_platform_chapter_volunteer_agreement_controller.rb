module Admin::ChapterAmbassadors
  class OffPlatformChapterVolunteerAgreementController < AdminController
    def create
      @chapter_ambassador = ChapterAmbassadorProfile.find(params[:chapter_ambassador_id])

      if @chapter_ambassador.volunteer_agreement.present?
        redirect_to admin_participant_path(@chapter_ambassador.account),
          error: "This chapter ambassador already has an active chapter volunteer agreement"
      else
        @volunteer_agreement = @chapter_ambassador.build_volunteer_agreement(
          electronic_signature: @chapter_ambassador.full_name,
          off_platform: true
        )

        if @volunteer_agreement.save
          redirect_to admin_participant_path(@chapter_ambassador.account),
            success: "Successfully created an off-platform chapter volunteer agreement for #{@chapter_ambassador.full_name}"
        else
          redirect_to admin_participant_path(@chapter_ambassador.account),
            error: "Error creating an off-platform chapter volunteer agreement for #{@chapter_ambassador.full_name}"
        end
      end
    end
  end
end
