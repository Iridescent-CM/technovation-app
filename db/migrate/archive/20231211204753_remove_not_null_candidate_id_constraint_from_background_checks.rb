class RemoveNotNullCandidateIdConstraintFromBackgroundChecks < ActiveRecord::Migration[6.1]
  def change
    change_column_null :background_checks, :candidate_id, true
  end
end
