class PopulateTechnicalSkills < ActiveRecord::Migration[7.0]
  def up
    TechnicalSkill.create!(name: "App Inventor", order: 1)
    TechnicalSkill.create!(name: "Code.org", order: 2)
    TechnicalSkill.create!(name: "Java", order: 3)
    TechnicalSkill.create!(name: "Scratch", order: 4)
    TechnicalSkill.create!(name: "Swift", order: 5)
    TechnicalSkill.create!(name: "Thunkable", order: 6)
    TechnicalSkill.create!(name: "I am comfortable with most coding languages", order: 7)
    TechnicalSkill.create!(name: "None of the above", order: 8)
  end

  def down
    TechnicalSkill.delete_all
  end
end
