class AddOffPlatformStatusToDocuments < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      ALTER TYPE document_status ADD VALUE 'off-platform' BEFORE 'voided'
    SQL
  end

  def down
    # NOOP
  end
end
