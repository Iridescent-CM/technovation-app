class PopulateProgramLengths < ActiveRecord::Migration[6.1]
  def up
    ProgramLength.create(length: "Less than 6 weeks", order: 1)
    ProgramLength.create(length: "6-9 weeks", order: 2)
    ProgramLength.create(length: "10-12 weeks", order: 3)
    ProgramLength.create(length: "13-15 weeks", order: 4)
    ProgramLength.create(length: "16+ weeks", order: 5)
  end

  def down
    ProgramLength.delete_all
  end
end
