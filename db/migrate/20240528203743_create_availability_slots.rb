class CreateAvailabilitySlots < ActiveRecord::Migration[6.1]
  def change
    create_table :availability_slots do |t|
      t.string :time

      t.timestamps
    end
  end
end
