class AddLowIncomeEstimateToChapterProgramInformation < ActiveRecord::Migration[6.1]
  def change
    add_reference :chapter_program_information, :low_income_estimate, foreign_key: true
  end
end
