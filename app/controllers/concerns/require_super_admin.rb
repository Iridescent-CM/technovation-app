module RequireSuperAdmin
  extend ActiveSupport::Concern

  private

  def require_super_admin
    unless current_admin.super_admin?
      redirect_to root_path, alert: t("controllers.application.unauthorized")
    end
  end
end
