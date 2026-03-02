class CreateGadgetType < ActiveRecord::Migration[6.1]
  def change
    create_table :gadget_types do |t|
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
