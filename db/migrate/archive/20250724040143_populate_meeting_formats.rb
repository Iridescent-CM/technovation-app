class PopulateMeetingFormats < ActiveRecord::Migration[6.1]
  def up
    MeetingFormat.create(name: "In Person")
    MeetingFormat.create(name: "Virtual")
    MeetingFormat.create(name: "Hybrid")
  end

  def down
    MeetingFormat.delete_all
  end
end
