module ChapterAmbassador
  class ChapterLocationsController < ChapterAmbassadorController
    include LocationController

    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout "chapter_ambassador_rebrand"

    private

    def db_record
      @db_record ||= if params.has_key?(:chapter_id)
        Chapter.find(params.fetch(:chapter_id))
      end
    end
  end
end
