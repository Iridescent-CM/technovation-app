class RegistrationMailer < ApplicationMailer
  def invitation(user_invitation_id)
    invitation = UserInvitation.find(user_invitation_id)
    invite_code = invitation.admin_permission_token

    if invite_code.present?
      @name = invitation.name
      @registration_type = invitation.profile_type
      @url = signup_url(invite_code: invite_code)

      mail to: invitation.email,
        subject: t("registration_mailer.invitation.subject")
    else
      raise AdminPermissionTokenNotPresent,
        "UserInvitation ID: #{invitation.id}"
    end
  end

  def welcome_mentor(account_id)
    account = Account.joins(:mentor_profile).find(account_id)

    @first_name = account.first_name

    @root_url = mentor_dashboard_url(mailer_token: account.mailer_token)

    @season_year = Season.current.year

    @consent_url = new_mentor_consent_waiver_url(
      token: account.consent_token,
      mailer_token: account.mailer_token
    )

    @background_check_url = new_mentor_background_check_url(mailer_token: account.mailer_token)

    I18n.with_locale(account.locale) do
      mail to: account.email,
        subject: t("registration_mailer.welcome_mentor.subject",
          season_year: Season.current.year)
    end
  end

  def welcome_judge(account_id)
    account = Account.joins(:judge_profile).find(account_id)

    @first_name = account.first_name
    @root_url = judge_dashboard_url(mailer_token: account.mailer_token)
    @season_year = Season.current.year
    @judging_start_date = "#{ImportantDates.quarterfinals_judging_begins.strftime("%B")} #{ImportantDates.quarterfinals_judging_begins.day.ordinalize}"

    I18n.with_locale(account.locale) do
      mail to: account.email,
        subject: t("registration_mailer.welcome_judge.subject",
          season_year: Season.current.year)
    end
  end

  def welcome_returning_judge(account_id)
    account = Account.joins(:judge_profile).find(account_id)

    @first_name = account.first_name
    @root_url = judge_dashboard_url(mailer_token: account.mailer_token)
    @season_year = Season.current.year
    @judging_start_date = "#{ImportantDates.quarterfinals_judging_begins.strftime("%B")} #{ImportantDates.quarterfinals_judging_begins.day.ordinalize}"

    I18n.with_locale(account.locale) do
      mail to: account.email,
        subject: t("registration_mailer.welcome_returning_judge.subject",
          season_year: Season.current.year)
    end
  end

  def welcome_student(student)
    merge_vars = {
      REGISTRATION_OPENS: ImportantDates.registration_opens.strftime("%B %Y"),
      OFFICIAL_START_OF_SEASON: ImportantDates.official_start_of_season.strftime("%B %d, %Y"),
      TEAM_REGISTRATION_DEADLINE: ImportantDates.team_registration_deadline.strftime("%B %d, %Y"),
      SEASON_SUBMISSION_DEADLINE: Season.submission_deadline,
      SEASON_SUBMISSIONS_OPEN_MONth: ImportantDates.official_start_of_season.strftime("%B"),
      SEASON_YEAR: Season.current.year,
      ROOT_URL: root_url(mailer_token: student.mailer_token),
      DASHBOARD_URL: student_dashboard_url(mailer_token: student.mailer_token),
      PROGRAM_TIMELINE_URL: ENV.fetch("PROGRAM_TIMELINE_URL"),
      MENTOR_RESOURCES_URL: ENV.fetch("MENTOR_RESOURCES_URL"),
      INTERNET_SAFETY_URL: ENV.fetch("INTERNET_SAFETY_URL"),
      FAQ_URL: ENV.fetch("FAQ_URL"),
      SUBMISSION_GUIDELINES_URL: ENV.fetch("SUBMISSION_GUIDELINES_URL"),
      COMPETITION_RULES_URL: ENV.fetch("COMPETITION_RULES_URL")
    }

    I18n.with_locale(student.locale) do
      mail to: student.email,
        subject: t("registration_mailer.welcome_student.subject", season_year: Season.current.year) do |f|
        f.html { render_email_template("registration-student", merge_vars:) }
      end
    end
  end

  def welcome_parent(student)
    @registration_opens = ImportantDates.registration_opens.strftime("%B %Y")
    @official_start_of_season = ImportantDates.official_start_of_season.strftime("%B %d, %Y")
    @team_registration_deadline = ImportantDates.team_registration_deadline.strftime("%B %d, %Y")
    @season_submission_deadline = Season.submission_deadline
    @season_submissions_open_month = ImportantDates.official_start_of_season.strftime("%B")
    @season_year = Season.current.year
    @root_url = root_url(mailer_token: student.mailer_token)
    @dashboard_url = student_dashboard_url(mailer_token: student.mailer_token)
    @technovation_url = "http://technovationchallenge.org/about/"
    @internet_safety_url = ENV.fetch("INTERNET_SAFETY_URL")
    @faq_url = ENV.fetch("FAQ_URL")
    @parent_resources_url = ENV.fetch("PARENT_RESOURCES_URL")
    @submission_guidelines_url = ENV.fetch("SUBMISSION_GUIDELINES_URL")
    @program_timeline_url = ENV.fetch("PROGRAM_TIMELINE_URL")

    I18n.with_locale(student.locale) do
      mail to: student.email,
        subject: t("registration_mailer.welcome_student.subject", season_year: @season_year)
    end
  end
end
