class PopulateProgramLengths < ActiveRecord::Migration[6.1]
  def up
    ProgramLength.create(length: "Less than 6 weeks")
    ProgramLength.create(length: "6-9 weeks")
    ProgramLength.create(length: "10-12 weeks")
    ProgramLength.create(length: "13-15 weeks")
    ProgramLength.create(length: "16+ weeks")
  end

  def down
    ProgramLength.delete_all
  end
end
