class AddAttachmentScreenshot1Screenshot2Screenshot3Screenshot4Screenshot5ToTeams < ActiveRecord::Migration
  def self.up
    change_table :teams do |t|
      t.attachment :screenshot1
      t.attachment :screenshot2
      t.attachment :screenshot3
      t.attachment :screenshot4
      t.attachment :screenshot5
    end
  end

  def self.down
    remove_attachment :teams, :screenshot1
    remove_attachment :teams, :screenshot2
    remove_attachment :teams, :screenshot3
    remove_attachment :teams, :screenshot4
    remove_attachment :teams, :screenshot5
  end
end
