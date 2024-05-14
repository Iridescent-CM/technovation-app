class CreateMeetingTimes < ActiveRecord::Migration[6.1]
  def change
    create_table :meeting_times do |t|
      t.string :time

      t.timestamps
    end
  end
end
