module ClubAmbassador
  class ClubCurrentLocationsController < AmbassadorController
    layout "club_ambassador_rebrand"

    def show
      state = FriendlySubregion.call(current_account.current_club, prefix: false)
      state_code = FriendlySubregion.call(current_account.current_club, {
        prefix: false,
        short_code: true
      })

      friendly_country = FriendlyCountry.new(current_account.current_club)

      render json: {
        city: current_account.current_club.city,
        state: state,
        state_code: state_code,
        country: friendly_country.country_name,
        country_code: friendly_country.as_short_code
      }
    end
  end
end
