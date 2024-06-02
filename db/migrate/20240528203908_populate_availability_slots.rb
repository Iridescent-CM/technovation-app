class PopulateAvailabilitySlots < ActiveRecord::Migration[6.1]
  def up
    AvailabilitySlot.create(time: "9am EST")
    AvailabilitySlot.create(time: "1PM EST")
  end

  def down
    AvailabilitySlot.delete_all
  end
end
