class LearnWorldsController < ApplicationController
  def sso
    if current_account.learn_worlds_user_id.present?
      sso_result = LearnWorlds::ApiClient.new.sso(account: current_account)

      if sso_result.success?
        redirect_to sso_result.redirect_url
      else
        redirect_to student_dashboard_path,
          flash: {error: t("controllers.learn_worlds.sso.error")}
      end
    elsif current_account.student?
      redirect_to student_dashboard_path,
        flash: {error: "Sorry, the beginner curriculum is currently unavailable."}
    elsif current_account.is_a_mentor?
      redirect_to mentor_dashboard_path,
        flash: {error: "Sorry, the beginner curriculum is currently unavailable."}
    end
  end
end
