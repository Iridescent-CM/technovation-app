class SeasonRegistration < ActiveRecord::Base
  enum status: %i{pending active dropped_out}

  belongs_to :season
  belongs_to :registerable, polymorphic: true

  def self.register(registerable, season = Season.current)
    if not exists?(registerable: registerable, season: season)
      create(registerable: registerable, season: season)

      if season == Season.current and
          registerable.respond_to?(:student_profile) and
            registerable.student_profile.present?

        RegistrationMailer.welcome_student(registerable).deliver_later

        profile = registerable.student_profile

        if profile.parent_guardian_email and profile.parental_consent.nil?
          ParentMailer.consent_notice(profile).deliver_later
        end
      end
    end
  end
end
