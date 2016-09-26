module Admin
  class AccountsController < AdminController
    def index
      params[:per_page] = 25 if params[:per_page].blank?
      params[:type] = "All" if params[:type].blank?
      params[:season] = Season.current.year if params[:season].blank?

      accounts = Account.joins(season_registrations: :season)
                        .where("season_registrations.season_id = ?",
                               Season.find_by(year: params[:season]))

      accounts = case params[:type]
                  when "All"
                    accounts
                  else
                    accounts.where(type: "#{params[:type]}Account")
                  end

      @accounts = accounts.paginate(per_page: params[:per_page], page: params[:page])
    end

    def show
      @account = Account.find(params[:id])
    end
  end
end
