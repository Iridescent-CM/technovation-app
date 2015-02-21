class AddSubmissionAttachmentsToTeams < ActiveRecord::Migration
  def up
  	change_table :teams do |t|
      t.attachment :code
      t.attachment :logo
      t.string :pitch
      t.string :demo
      t.attachment :plan
    end
  end

  def down
    remove_attachment :teams, :code
    remove_attachment :teams, :logo
    remove_attachment :teams, :plan
  end
end
