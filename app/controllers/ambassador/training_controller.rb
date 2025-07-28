module Ambassador
  class TrainingController < AmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded
    layout :set_layout_for_current_ambassador
  end
end
