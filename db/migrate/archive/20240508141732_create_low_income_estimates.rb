class CreateLowIncomeEstimates < ActiveRecord::Migration[6.1]
  def change
    create_table :low_income_estimates do |t|
      t.string :percentage
      t.integer :order

      t.timestamps
    end
  end
end
