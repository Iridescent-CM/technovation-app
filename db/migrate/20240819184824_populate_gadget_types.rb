class PopulateGadgetTypes < ActiveRecord::Migration[6.1]
  def up
    GadgetType.create(name: "Micro:bit", order: 1)
    GadgetType.create(name: "Arduino", order: 2)
    GadgetType.create(name: "Raspberry Pi", order: 3)
    GadgetType.create(name: "Other", order: 4)
  end

  def down
    GadgetType.delete_all
  end
end
