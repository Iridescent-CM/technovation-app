module Admin
  class CurrentLocationsController < AdminController
    def show
      record = if account_id = params.fetch(:account_id) { false }
        Account.find(account_id)
      else
        Team.find(params.fetch(:team_id))
      end

      state = FriendlySubregion.call(record, prefix: false)
      state_code = FriendlySubregion.call(record, {
        prefix: false,
        short_code: true
      })

      friendly_country = FriendlyCountry.new(record)

      render json: {
        city: record.city,
        state: state,
        state_code: state_code,
        country: friendly_country.country_name,
        country_code: friendly_country.as_short_code
      }
    end
  end
end
