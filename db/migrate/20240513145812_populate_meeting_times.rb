class PopulateMeetingTimes < ActiveRecord::Migration[6.1]
  def up
    MeetingTime.create(time: "During school", order: 1)
    MeetingTime.create(time: "After school", order: 2)
    MeetingTime.create(time: "In the evenings", order: 3)
    MeetingTime.create(time: "On the weekend", order: 4)
  end

  def down
    MeetingTime.delete_all
  end
end
