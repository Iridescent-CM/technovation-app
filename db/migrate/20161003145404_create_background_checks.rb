class CreateBackgroundChecks < ActiveRecord::Migration[4.2]
  def change
    create_table :background_checks do |t|
      t.string :candidate_id, null: false
      t.string :report_id, null: false
      t.references :account, index: true, foreign_key: true, null: false
      t.integer :status, null: false, default: 0

      t.timestamps null: false
    end
    add_index :background_checks, :candidate_id
    add_index :background_checks, :report_id
  end
end
