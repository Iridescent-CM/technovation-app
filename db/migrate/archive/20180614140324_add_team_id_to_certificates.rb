class AddTeamIdToCertificates < ActiveRecord::Migration[5.1]
  def change
    add_reference :certificates, :team, foreign_key: true
  end
end
