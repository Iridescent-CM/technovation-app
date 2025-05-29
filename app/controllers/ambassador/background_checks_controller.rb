module Ambassador
  class BackgroundChecksController < AmbassadorController
    include BackgroundCheckController
    include BackgroundCheckInvitationController

    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout :set_layout_for_current_ambassador

    private

    def set_layout_for_current_ambassador
      "#{current_scope}_rebrand"
    end

    def current_profile
      current_ambassador
    end
  end
end
