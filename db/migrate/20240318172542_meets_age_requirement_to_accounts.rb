class MeetsAgeRequirementToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :meets_minimum_age_requirement, :boolean
  end
end
