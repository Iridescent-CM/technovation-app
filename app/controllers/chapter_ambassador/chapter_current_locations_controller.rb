module ChapterAmbassador
  class ChapterCurrentLocationsController < ChapterAmbassadorController
    def show
      state = FriendlySubregion.call(current_account.current_chapter, prefix: false)
      state_code = FriendlySubregion.call(current_account.current_chapter, {
        prefix: false,
        short_code: true
      })

      friendly_country = FriendlyCountry.new(current_account.current_chapter)

      render json: {
        city: current_account.current_chapter.city,
        state: state,
        state_code: state_code,
        country: friendly_country.country_name,
        country_code: friendly_country.as_short_code
      }
    end
  end
end
