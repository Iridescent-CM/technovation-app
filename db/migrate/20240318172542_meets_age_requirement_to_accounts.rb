class MeetsAgeRequirementToAccounts < ActiveRecord::Migration[6.1]
  Account.reset_column_information
  if Account.column_names.exclude?("meets_minimum_age_requirement")
    def change
      add_column :accounts, :meets_minimum_age_requirement, :boolean
    end
  end
end
