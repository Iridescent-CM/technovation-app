class AgeRelatedUpdates < ActiveRecord::Migration[6.1]
  def up
    if Account.column_names.exclude?("meets_minimum_age_requirement")
      add_column :accounts, :meets_minimum_age_requirement, :boolean
      change_column_null :accounts, :date_of_birth, true
    end
  end

  def down
    # NOOP
  end
end
