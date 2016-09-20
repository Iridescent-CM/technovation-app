module RegionalAmbassador
  class AccountExportsController < RegionalAmbassadorController
    def create
      ExportRegionalAccountsJob.perform_later(current_ambassador)

      redirect_to regional_ambassador_accounts_path,
        success: t("controllers.regional_ambassador.account_exports.create.success")
    end
  end
end
