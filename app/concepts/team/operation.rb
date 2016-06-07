require "reform/form/validation/unique_validator"

class Team < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Team, :create

    contract do
      property :name
      property :description
      property :division_id
      property :region_id

      validates :name, unique: true, presence: true
      validates :division_id, presence: true
      validates :region_id, presence: true
    end

    def process(params)
      validate(params[:team]) do |f|
        f.save

        register_in_current_year!
      end
    end

    private
    def register_in_current_year!
      season = Season.find_or_create_by(year: Time.current.year,
                                        starts_at: Time.current - 30.days)
      model.registrations.create!(season: season)
    end
  end
end
