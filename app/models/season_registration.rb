class SeasonRegistration < ActiveRecord::Base
  enum status: %i{pending active dropped_out}

  belongs_to :season
  belongs_to :registerable, polymorphic: true

  def self.register(registerable, season = Season.current)
    if not exists?(registerable: registerable, season: season)
      create(registerable: registerable, season: season)

      if season == Season.current and registerable.respond_to?(:parent_guardian_email)
        RegistrationMailer.welcome_student(registerable).deliver_later

        if registerable.parent_guardian_email.present?
          ParentMailer.consent_notice(registerable).deliver_later
        end
      end
    end
  end
end
