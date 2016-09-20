module RegionalAccount
  def self.call(ambassador)
    accounts = Account.includes(:seasons).references(:seasons).where("seasons.year = ?", Season.current.year)

    if ambassador.country == "US"
      accounts.where(state_province: ambassador.state_province)
    else
      accounts.where(country: ambassador.country)
    end
  end
end
