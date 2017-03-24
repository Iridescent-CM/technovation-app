class AmbassadorMailer < ApplicationMailer
  def approved(ambassador)
    @season_year = Season.current.year
    @root_url = root_url
    @training_url = "http://iridescentlearning.org/internet-safety/"

    I18n.with_locale(ambassador.locale) do
      mail to: ambassador.email
    end
  end

  def declined(ambassador)
    @first_name = ambassador.first_name
    @status = "declined"

    I18n.with_locale(ambassador.locale) do
      mail to: ambassador.email
    end
  end

  def confirm_team_removed(account, event, team)
    @name = account.first_name
    @event = event
    @team_name = team.name
    @event_url = regional_ambassador_regional_pitch_event_url(event)

    I18n.with_locale(account.locale) do
      mail to: account.email,
           subject: "You removed #{@team_name} from your event: #{@event.name}"
    end
  end

  def confirm_team_added(account, event, team)
    @name = account.first_name
    @event = event
    @team_name = team.name
    @event_url = regional_ambassador_regional_pitch_event_url(event)

    I18n.with_locale(account.locale) do
      mail to: account.email,
           subject: "You added #{@team_name} to your event: #{@event.name}"
    end
  end

  def team_left_event(account, event, team)
    @name = account.first_name
    @event = event
    @team_name = team.name
    @event_url = regional_ambassador_regional_pitch_event_url(event)

    I18n.with_locale(account.locale) do
      mail to: account.email,
           subject: "#{@team_name} left your event: #{@event.name}"
    end
  end

  def judge_left_event(account, event, judge)
    @name = account.first_name
    @event = event
    @judge_name = judge.full_name
    @event_url = regional_ambassador_regional_pitch_event_url(event)

    I18n.with_locale(account.locale) do
      mail to: account.email,
           subject: "Judge #{@judge_name} left your event: #{@event.name}"
    end
  end

  def team_joined_event(account, event, team)
    @name = account.first_name
    @event = event
    @team_name = team.name
    @event_url = regional_ambassador_regional_pitch_event_url(event)

    I18n.with_locale(account.locale) do
      mail to: account.email,
           subject: "#{@team_name} joined your event: #{@event.name}"
    end
  end

  def judge_joined_event(account, event, judge)
    @name = account.first_name
    @event = event
    @judge_name = judge.full_name
    @event_url = regional_ambassador_regional_pitch_event_url(event)

    I18n.with_locale(account.locale) do
      mail to: account.email,
           subject: "Judge #{@judge_name} joined your event: #{@event.name}"
    end
  end

  def spam(*)
  end

  def pending(*)
  end
end
