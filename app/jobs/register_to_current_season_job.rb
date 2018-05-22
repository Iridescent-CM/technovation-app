class RegisterToCurrentSeasonJob < ActiveJob::Base
  queue_as :default

  def perform(record)
    unless record.seasons.include?(Season.current.year)
      update_data = {
        seasons: (record.seasons << Season.current.year)
      }

      if record.respond_to?(:season_registered_at)
        update_data = update_data.merge({
          season_registered_at: Time.current
        })
      end

      record.update_columns(update_data)

      if record.respond_to?(:student_profile)
        if (profile = record.student_profile).present?
          SubscribeEmailListJob.perform_later(
            record.email,
            record.full_name,
            "STUDENT_LIST_ID"
          )

          RegistrationMailer.welcome_student(record).deliver_later

          if profile.reload.parental_consent.nil?
            profile.parental_consents.create!
          end

          if profile.reload.parental_consent.pending? and
              not profile.parent_guardian_email.blank?
            ParentMailer.consent_notice(profile.id).deliver_later
          end
        end
      end

      if record.respond_to?(:mentor_profile) and
          record.mentor_profile.present?
        SubscribeEmailListJob.perform_later(
          record.email,
          record.full_name,
          "MENTOR_LIST_ID",
          [
            { Key: 'City',
              Value: record.city },
            { Key: 'State/Province',
              Value: record.state_province },
            { Key: 'Country',
              Value: FriendlyCountry.(record, prefix: false) },
          ]
        )
      end

      if record.respond_to?(:judge_profile) and
          record.judge_profile.present?
        SubscribeEmailListJob.perform_later(
          record.email,
          record.full_name,
          "JUDGE_LIST_ID",
          [
            { Key: 'City',
              Value: record.city },
            { Key: 'State/Province',
              Value: record.state_province },
            { Key: 'Country',
              Value: FriendlyCountry.(record, prefix: false) },
          ]
        )
      end

      if record.respond_to?(:create_activity)
        activity_hash = { key: "#{record.class.name.underscore}.register_current_season" }

        unless record.activities.where(activity_hash).exists?
          record.create_activity(activity_hash)
        end
      end
    end
  end
end
