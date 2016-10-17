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
    @status = ambassador.status

    I18n.with_locale(ambassador.locale) do
      mail to: ambassador.email
    end
  end

  def spam(*)
  end

  def pending(*)
  end
end
