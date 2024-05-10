class CreateChapterProgramInformationOrganizationTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :chapter_program_information_organization_types do |t|
      t.references :chapter_program_information, foreign_key: {to_table: :chapter_program_information}, index: {name: "chapter_program_information_id"}
      t.references :organization_type, foreign_key: true, index: {name: "organization_type_id"}

      t.timestamps
    end
  end
end
