class RegisterToCurrentSeasonJob < ActiveJob::Base
  queue_as :default

  def perform(record)
    return false if already_registered_for_season?(record)

    update_season_data_with_resets(record)

    if is_student?(record) && !is_mentor?(record)
      prepare_student_for_current_season(record)
    end

    prepare_mentor_for_current_season(record)  if is_mentor?(record)
    prepare_judge_for_current_season(record)   if is_judge?(record)

    record_registration_activity(record) if record.respond_to?(:create_activity)
  end

  private

  def already_registered_for_season?(record)
    record.seasons.include?(Season.current.year)
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
    student_profile = record.student_profile

    subscribe_to_newsletter(record, :student)

    if student_profile.division.junior? || student_profile.division.senior?
      RegistrationMailer.welcome_student(record).deliver_later
    elsif student_profile.division.beginner?
      RegistrationMailer.welcome_parent(record).deliver_later
    end

    if student_profile.reload.parental_consent.nil?
      student_profile.parental_consents.create!
    end

    if student_profile.reload.parental_consent.pending? &&
        !student_profile.parent_guardian_email.blank?
      ParentMailer.consent_notice(student_profile.id).deliver_later
    end

    student_profile.media_consents.create(season: Season.current.year)

    if record.seasons.many?
      record.update(division: Division.for_account(record))
    end

    student_profile.save # fire commit hooks, if needed
  end

  def prepare_mentor_for_current_season(record)
    subscribe_to_newsletter(record, :mentor)

    RegistrationMailer.welcome_mentor(record.id).deliver_later

    record.mentor_profile.update(training_completed_at: nil)
    record.mentor_profile.save # fire commit hooks, if needed
  end

  def prepare_judge_for_current_season(record)
    subscribe_to_newsletter(record, :judge)

    if SeasonToggles.judge_registration_open?
      if record.returning?
        RegistrationMailer.welcome_returning_judge(record.id).deliver_later
      else
        RegistrationMailer.welcome_judge(record.id).deliver_later
      end
    end

    record.judge_profile.update(completed_training_at: nil)
    record.judge_profile.save # fire commit hooks, if needed
  end

  def record_registration_activity(record)
    key_name = record.class.name.underscore
    activity_key = "#{key_name}.register_current_season"
    activity_options = { key: activity_key }

    unless record.activities.where(activity_options).exists?
      record.create_activity(activity_options)
    end
  end

  def subscribe_to_newsletter(record, profile_type)
    SubscribeAccountToEmailListJob.perform_later(
      account_id: record.id,
      profile_type: profile_type.to_s
    )
  end
end
