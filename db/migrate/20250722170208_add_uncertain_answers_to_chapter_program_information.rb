class AddUncertainAnswersToChapterProgramInformation < ActiveRecord::Migration[6.1]
  def change
    MeetingTime.create(time: "Uncertain")
    ProgramLength.create(length: "Uncertain")
    MeetingFacilitator.create(name: "Uncertain")
  end
end
