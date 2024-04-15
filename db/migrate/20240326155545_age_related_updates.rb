class AgeRelatedUpdates < ActiveRecord::Migration[6.1]
  Account.reset_column_information
  if Account.column_names.exclude?("meets_minimum_age_requirement")
    def up
      add_column :accounts, :meets_minimum_age_requirement, :boolean
      change_column_null :accounts, :date_of_birth, true
    end

    def down
      # NOOP
    end
  end
end
