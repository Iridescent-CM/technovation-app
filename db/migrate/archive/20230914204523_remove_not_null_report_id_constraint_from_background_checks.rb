class RemoveNotNullReportIdConstraintFromBackgroundChecks < ActiveRecord::Migration[6.1]
  def change
    change_column_null :background_checks, :report_id, true
  end
end
