class PopulateMeetingFacilitators < ActiveRecord::Migration[6.1]
  def up
    MeetingFacilitator.create(name: "Volunteer community mentors")
    MeetingFacilitator.create(name: "Volunteer corporate mentors")
    MeetingFacilitator.create(name: "Teachers")
    MeetingFacilitator.create(name: "Paid staff")
    MeetingFacilitator.create(name: "College students or faculty")
    MeetingFacilitator.create(name: "Parents")
  end

  def down
    MeetingFacilitator.delete_all
  end
end
