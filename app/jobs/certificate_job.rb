require 'fill_pdfs'

class CertificateJob < ActiveJob::Base
  queue_as :default

  def perform(account_id, team_id = nil)
    account = Account.find(account_id)

    team = if team_id
             Team.find(team_id)
           else
             nil
           end

    FillPdfs.(account, team)
  end
end