module Admin::ChapterAmbassadors
  class OffPlatformChapterVolunteerAgreementController < AdminController
    def create
      @chapter_ambassador = ChapterAmbassadorProfile.find(params[:chapter_ambassador_id])

      if @chapter_ambassador.chapter_volunteer_agreement.present?
        redirect_to admin_participant_path(@chapter_ambassador.account),
          error: "This chapter ambassador already has an active chapter volunteer agreement"
      else
        @chapter_ambassador.documents.create(
          full_name: @chapter_ambassador.full_name,
          email_address: @chapter_ambassador.email,
          active: true,
          season_signed: Season.current.year,
          season_expires: Season.current.year + 1,
          status: "off-platform"
        )

        redirect_to admin_participant_path(@chapter_ambassador.account),
          success: "Successfully created an off-platform chapter volunteer agreement this chapter ambassador"
      end
    end
  end
end
