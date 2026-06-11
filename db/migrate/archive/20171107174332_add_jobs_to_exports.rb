class AddJobsToExports < ActiveRecord::Migration[5.1]
  def change
    add_column :exports, :job_id, :string
  end
end
