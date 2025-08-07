class ChangeTechnovationAlumnaToPastTechnovationStudent < ActiveRecord::Migration[6.1]
  def change
    MentorType.find_by(name: "Technovation alumna").update(name: "Past Technovation student")
  end
end
