class AddAssignmentByToChapterableAccountAssignments < ActiveRecord::Migration[6.1]
  def change
    add_column :chapterable_account_assignments, :assignment_by_id, :integer
    add_column :chapterable_account_assignments, :assignment_by_type, :string

    add_index :chapterable_account_assignments, [:assignment_by_id, :assignment_by_type],
      name: :index_chapterable_account_assignments_on_assignment_by
  end
end
