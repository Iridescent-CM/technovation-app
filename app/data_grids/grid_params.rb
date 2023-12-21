module GridParams
  def self.for(grid_params, profile, options = {})
    round = SeasonToggles.current_judging_round(full_name: true)
    round = :quarterfinals if round.to_sym == :off
    is_admin = options.fetch(:admin)

    grid_params.merge(
      admin: is_admin,
      allow_state_search: is_admin || profile.country != "US",

      country: (
        if is_admin
          Array(grid_params[:country])
        else
          Array(profile.country)
        end
      ),

      state_province: (
        if !is_admin && profile.country_code == "US"
          Array(profile.state_province)
        else
          Array(grid_params[:state_province])
        end
      ),

      current_account: profile.account,
      current_judging_round: String(round)
    )
  end
end
