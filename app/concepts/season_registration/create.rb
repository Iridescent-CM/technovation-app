class SeasonRegistration < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model SeasonRegistration, :create

    contract do
      property :registerable
      property :season

      validates :registerable, presence: true
      validates :season, presence: true
    end

    def process(params)
      registration_params = params_defaulted_to_current_season(
                              params.fetch(:season_registration)
                            )
      validate(registration_params) do |f|
        f.save
      end
    end

    private
    def params_defaulted_to_current_season(params)
      params.merge(season: Season::Current.({}).model)
    end
  end
end
