class AmbassadorMailer < ApplicationMailer
  def approved(ambassador)
    @season_year = Season.current.year
    @root_url = root_url
    @training_url = "http://iridescentlearning.org/internet-safety/"
    mail to: ambassador.email
  end

  def declined(ambassador)
    @first_name = ambassador.first_name
    @status = ambassador.status
    mail to: ambassador.email
  end
end
