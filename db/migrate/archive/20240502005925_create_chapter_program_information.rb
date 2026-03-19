class CreateChapterProgramInformation < ActiveRecord::Migration[6.1]
  def change
    create_table :chapter_program_information do |t|
      t.references :chapter, foreign_key: true
      t.text :child_safeguarding_policy_and_process
      t.text :team_structure
      t.text :external_partnerships
      t.date :start_date
      t.date :launch_date
      t.text :program_model
      t.text :number_of_low_income_or_underserved_calculation

      t.timestamps
    end
  end
end
