class RegisterToCurrentSeasonJob < ActiveJob::Base
  queue_as :default

  def perform(record)
    return false if perform_not_needed?(record)

    update_season_data_with_resets(record)

    prepare_student_for_current_season(record) if is_student?(record)
    prepare_mentor_for_current_season(record)  if is_mentor?(record)
    prepare_judge_for_current_season(record)   if is_judge?(record)

    record_registration_activity(record) if record.respond_to?(:create_activity)
  end

  private
  def perform_not_needed?(record)
    if record.respond_to?(:season_registered_at)
      record.seasons.include?(Season.current.year) &&
        record.season_registered_at &&
          record.season_registered_at.to_date >= ImportantDates.registration_opens
    else
      record.seasons.include?(Season.current.year)
    end
  end

  def is_student?(record)
    record.respond_to?(:student_profile) && record.student_profile.present?
  end

  def is_mentor?(record)
    record.respond_to?(:mentor_profile) && record.mentor_profile.present?
  end

  def is_judge?(record)
    record.respond_to?(:judge_profile) && record.judge_profile.present?
  end

  def update_season_data_with_resets(record)
    update_data = {
      seasons: (record.seasons << Season.current.year),
    }

    if record.respond_to?(:season_registered_at)
      update_data = update_data.merge({
        season_registered_at: Time.current,
      })
    end

    record.update_columns(update_data)
  end

  def prepare_student_for_current_season(record)
    notify_airbrake_on_invalid_location(record)

    profile = record.student_profile

    subscribe_to_newsletter(record, :student)

    RegistrationMailer.welcome_student(record).deliver_later

    if profile.reload.parental_consent.nil?
      profile.parental_consents.create!
    end

    if profile.reload.parental_consent.pending? &&
        !profile.parent_guardian_email.blank?
      ParentMailer.consent_notice(profile.id).deliver_later
    end
  end

  def prepare_mentor_for_current_season(record)
    notify_airbrake_on_invalid_location(record)

    subscribe_to_newsletter(record, :mentor, with_location: true)
  end

  def prepare_judge_for_current_season(record)
    notify_airbrake_on_invalid_location(record)

    subscribe_to_newsletter(record, :judge, with_location: true)
  end

  def record_registration_activity(record)
    key_name = record.class.name.underscore
    activity_key = "#{key_name}.register_current_season"
    activity_options = { key: activity_key }

    unless record.activities.where(activity_options).exists?
      record.create_activity(activity_options)
    end
  end

  def subscribe_to_newsletter(record, list_scope, options = {})
    args = [
      record.email,
      record.full_name,
      "#{list_scope.to_s.upcase}_LIST_ID",
    ]

    args.push(location_data(record)) if options[:with_location]

    SubscribeEmailListJob.perform_later(*args)
  end

  def location_data(record)
    [
      { Key: 'City',
        Value: record.city },
      { Key: 'State/Province',
        Value: record.state_code },
      { Key: 'Country',
        Value: FriendlyCountry.(record, prefix: false) },
    ]
  end

  def notify_airbrake_on_invalid_location(record)
    if !record.valid_address? || !record.valid_coordinates?
      Airbrake.notify(
        "RegisterToCurrentSeasonJob - Invalid record address or coordinates",
        {
          id: record.id,
          city: record.city,
          state_province: record.state_province,
          country: record.country,
          latitude: record.latitude,
          longitude: record.longitude,
          valid_address: record.valid_address?,
          valid_coordinates: record.valid_coordinates?
        }
      )
    end
  end
end