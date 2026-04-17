class PopulateLowIncomeEstimates < ActiveRecord::Migration[6.1]
  def up
    LowIncomeEstimate.create(percentage: "5", order: 1)
    LowIncomeEstimate.create(percentage: "10", order: 2)
    LowIncomeEstimate.create(percentage: "20", order: 3)
    LowIncomeEstimate.create(percentage: "30", order: 4)
    LowIncomeEstimate.create(percentage: "40", order: 5)
    LowIncomeEstimate.create(percentage: "50", order: 6)
    LowIncomeEstimate.create(percentage: "60", order: 7)
    LowIncomeEstimate.create(percentage: "70", order: 8)
    LowIncomeEstimate.create(percentage: "80", order: 9)
    LowIncomeEstimate.create(percentage: "90", order: 10)
    LowIncomeEstimate.create(percentage: "100", order: 11)
  end

  def down
    LowIncomeEstimate.delete_all
  end
end
