class PopulateMeetingTimes < ActiveRecord::Migration[6.1]
  def up
    MeetingTime.create(time: "During school")
    MeetingTime.create(time: "After school")
    MeetingTime.create(time: "In the evenings")
    MeetingTime.create(time: "On the weekend")
  end

  def down
    MeetingTime.delete_all
  end
end
