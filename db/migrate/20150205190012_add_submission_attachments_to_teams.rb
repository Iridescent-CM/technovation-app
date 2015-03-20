class AddSubmissionAttachmentsToTeams < ActiveRecord::Migration
  def up
  	change_table :teams do |t|
      t.string :code
      t.string :pitch
      t.string :demo

      t.attachment :logo
      t.attachment :plan
    end
  end

  def down
    remove_attachment :teams, :logo
    remove_attachment :teams, :plan
  end
end
