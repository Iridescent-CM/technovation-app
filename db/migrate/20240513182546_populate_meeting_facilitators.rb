class PopulateMeetingFacilitators < ActiveRecord::Migration[6.1]
  def up
    MeetingFacilitator.create(name: "Volunteer community mentors", order: 1)
    MeetingFacilitator.create(name: "Volunteer corporate mentors", order: 2)
    MeetingFacilitator.create(name: "Teachers", order: 3)
    MeetingFacilitator.create(name: "Paid staff", order: 4)
    MeetingFacilitator.create(name: "College students or faculty", order: 5)
    MeetingFacilitator.create(name: "Parents", order: 6)
  end

  def down
    MeetingFacilitator.delete_all
  end
end
