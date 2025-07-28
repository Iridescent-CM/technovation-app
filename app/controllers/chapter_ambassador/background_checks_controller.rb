module ChapterAmbassador
  class BackgroundChecksController < ChapterAmbassadorController
    include BackgroundCheckController
    include BackgroundCheckInvitationController

    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout "chapter_ambassador_rebrand"

    private

    def current_profile
      current_ambassador
    end
  end
end
