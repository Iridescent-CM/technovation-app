module Admin
  class AccountExportsController < AdminController
    def create
      ExportAccountsJob.perform_later(current_admin, params)

      redirect_to admin_accounts_path,
        success: t("controllers.regional_ambassador.account_exports.create.success")
    end
  end
end
