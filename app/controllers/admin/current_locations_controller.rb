module Admin
  class CurrentLocationsController < AdminController
    def show
      record = if params.has_key?(:account_id)
        Account.find(params.fetch(:account_id))
      elsif params.has_key?(:team_id)
        Team.find(params.fetch(:team_id))
      elsif params.has_key?(:chapter_id)
        Chapter.find(params.fetch(:chapter_id))
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
