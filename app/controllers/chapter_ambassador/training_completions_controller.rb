module ChapterAmbassador
  class TrainingCompletionsController < ChapterAmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout "chapter_ambassador_rebrand"

    def show
      current_ambassador.complete_training!
      redirect_to chapter_ambassador_trainings_path,
        success: "Thank you for completing the checkpoint!"
    end
  end
end
