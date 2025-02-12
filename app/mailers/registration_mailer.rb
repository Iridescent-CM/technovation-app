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
    @registration_opens = ImportantDates.registration_opens.strftime("%B %Y")
    @official_start_of_season = ImportantDates.official_start_of_season.strftime("%B %d, %Y")
    @team_registration_deadline = ImportantDates.team_registration_deadline.strftime("%B %d, %Y")
    @season_submission_deadline = Season.submission_deadline
    @season_submissions_open_month = ImportantDates.official_start_of_season.strftime("%B")
    @season_year = Season.current.year
    @root_url = root_url(mailer_token: student.mailer_token)
    @dashboard_url = student_dashboard_url(mailer_token: student.mailer_token)
    @educational_training_url = "https://technovationchallenge.org/mentor-resources/"
    @internet_safety_url = "https://www.technovation.org/safety/internet-safety-training/"
    @in_person_safety_url = "https://www.technovation.org/safety/know-your-rights/"
    @faq_url = "https://iridescentsupport.zendesk.com/hc/en-us/categories/115000091348-Technovation"

    I18n.with_locale(student.locale) do
      mail to: student.email,
        subject: t("registration_mailer.welcome_student.subject",
          season_year: @season_year)
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
    @safety_url = "https://www.technovation.org/safety/internet-safety-training/"
    @faq_url = "https://iridescentsupport.zendesk.com/hc/en-us/categories/115000091348-Technovation"

    I18n.with_locale(student.locale) do
      mail to: student.email,
        subject: t("registration_mailer.welcome_student.subject", season_year: @season_year)
    end
  end
end
