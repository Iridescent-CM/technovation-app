class CreateMeetingFormats < ActiveRecord::Migration[6.1]
  def change
    create_table :meeting_formats do |t|
      t.string :name

      t.timestamps
    end
  end
end
