class CreateMeetingFacilitators < ActiveRecord::Migration[6.1]
  def change
    create_table :meeting_facilitators do |t|
      t.string :name

      t.timestamps
    end
  end
end
