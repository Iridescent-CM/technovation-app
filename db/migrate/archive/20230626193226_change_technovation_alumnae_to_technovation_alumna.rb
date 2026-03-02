class ChangeTechnovationAlumnaeToTechnovationAlumna < ActiveRecord::Migration[6.1]
  def change
    MentorType.find_by(name: "Technovation alumnae").update(name: "Technovation alumna")
  end
end
