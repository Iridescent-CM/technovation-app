class SeasonRegistration < ActiveRecord::Base
  enum status: %i{pending active dropped_out}

  belongs_to :season
  belongs_to :registerable, polymorphic: true

  def self.register(registerable, season = Season.current)
    if not exists?(registerable: registerable, season: season)
      create(registerable: registerable, season: season)

      if season == Season.current and registerable.respond_to?(:student_profile)
        RegistrationMailer.welcome_student(registerable).deliver_later
      end
    end
  end
end
