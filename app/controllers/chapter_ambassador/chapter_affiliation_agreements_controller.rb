module ChapterAmbassador
  class ChapterAffiliationAgreementsController < ChapterAmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout "chapter_ambassador_rebrand"
  end
end
