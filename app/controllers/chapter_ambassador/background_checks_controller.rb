module ChapterAmbassador
  class BackgroundChecksController < ChapterAmbassadorController
    include BackgroundCheckController
    include BackgroundCheckInvitationController

    layout "chapter_ambassador_rebrand"

    private

    def current_profile
      current_ambassador
    end
  end
end
