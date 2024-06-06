module ChapterAmbassador
  class ProgramInformationController < ChapterAmbassadorController
    skip_before_action :require_chapter_and_chapter_ambassador_onboarded

    layout "chapter_ambassador_rebrand"
  end
end
