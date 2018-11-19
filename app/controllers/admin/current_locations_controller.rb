module Admin
  class CurrentLocationsController < AdminController
    def show
      if account_id = params.fetch(:account_id) { false }
        record = Account.find(account_id)
      else
        record = Team.find(params.fetch(:team_id))
      end

      state = FriendlySubregion.(
        OpenStruct.new(
          state_province: record.state_province,
          country: record.country
        ),
        prefix: false,
      )

      country = FriendlyCountry.new(record).country_name

      render json: {
        city: record.city,
        state: state,
        state_code: record.state_province,
        country: country,
        country_code: record.country_code,
      }
    end
  end
end