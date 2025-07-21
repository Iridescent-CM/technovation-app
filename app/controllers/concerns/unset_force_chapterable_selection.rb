module UnsetForceChapterableSelection
  extend ActiveSupport::Concern

  included do
    skip_before_action :require_chapterable_selection, only: :unset_force_chapterable_selection
  end

  def unset_force_chapterable_selection
    current_account.update(force_chapterable_selection: false)

    redirect_to send(:"#{current_account.scope_name}_dashboard_path")
  end
end
