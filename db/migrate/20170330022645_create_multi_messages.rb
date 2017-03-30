class CreateMultiMessages < ActiveRecord::Migration
  def change
    enable_extension 'hstore'

    create_table :multi_messages do |t|
      t.references :sender, polymorphic: true, null: false
      t.references :regarding, polymorphic: true, null: false
      t.hstore :recipients, null: false
      t.string :subject
      t.text :body, null: false
      t.datetime :sent_at
      t.datetime :delivered_at

      t.timestamps null: false
    end
  end
end
