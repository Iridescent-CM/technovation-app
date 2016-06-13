class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :authentication, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
