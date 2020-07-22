module ChapterAmbassador
  class BackgroundChecksController < ChapterAmbassadorController
    include BackgroundCheckController
    private
    def current_profile
      current_ambassador
    end
  end
end
