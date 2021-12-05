class LearnWorldsController < ApplicationController
  def sso
    sso_result = LearnWorlds::ApiClient.new.sso(account: current_account)

    if sso_result.success?
      redirect_to sso_result.redirect_url
    else
      redirect_to student_dashboard_path,
        flash: {error: t("controllers.learn_worlds.sso.error")}
    end
  end
end
