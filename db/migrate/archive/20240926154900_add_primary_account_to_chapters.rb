class AddPrimaryAccountToChapters < ActiveRecord::Migration[6.1]
  def change
    add_reference :chapters, :primary_account, null: true, foreign_key: {to_table: :accounts}
  end
end
