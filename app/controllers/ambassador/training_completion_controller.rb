module Ambassador
  class TrainingCompletionController < AmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded

    def show
      current_ambassador.complete_training!
      redirect_to send("#{current_scope}_training_path"),
        success: "Thank you for completing the checkpoint!"
    end
  end
end
