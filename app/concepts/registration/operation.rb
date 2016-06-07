class Registration < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Registration, :create

    contract do
      property :registerable
      property :season

      validates :registerable, presence: true
      validates :season, presence: true
    end

    def process(params)
      registration_params = params_defaulted_to_current_season(params)
      validate(registration_params) do |f|
        f.save
      end
    end

    private
    def params_defaulted_to_current_season(params)
      season = Season::Current.({}).model
      params.deep_merge(registration: { season: season })[:registration]
    end
  end
end
