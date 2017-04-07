class CreateJobs < ActiveRecord::Migration[4.2]
  def change
    create_table :jobs do |t|
      t.string :job_id
      t.string :status

      t.timestamps null: false
    end
  end
end
