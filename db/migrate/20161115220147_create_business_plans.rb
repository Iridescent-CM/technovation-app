class CreateBusinessPlans < ActiveRecord::Migration[4.2]
  def change
    create_table :business_plans do |t|
      t.string :uploaded_file
      t.string :remote_file_url
      t.references :team_submission, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
