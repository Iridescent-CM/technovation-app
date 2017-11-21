class RegisterToCurrentSeasonJob < ActiveJob::Base
  queue_as :default

  def perform(record)
    unless record.seasons.include?(Season.current.year)
      update_data = {
        seasons: (record.seasons << Season.current.year)
      }

      if record.respond_to?(:season_registered_at)
        update_data = update_data.merge({ season_registered_at: Time.current })
      end

      record.update_columns(update_data)

      if record.respond_to?(:student_profile)
        if (profile = record.student_profile).present?
          RegistrationMailer.welcome_student(record).deliver_later

          if profile.parental_consent.nil?
            profile.parental_consents.create!
          end

          if profile.parental_consent.pending? and
              not profile.parent_guardian_email.blank?
            ParentMailer.consent_notice(profile.id).deliver_later
          end
        end
      end

      record.create_activity(
        key: "#{record.class.name.underscore}.register_current_season"
      )
    end
  end
end
