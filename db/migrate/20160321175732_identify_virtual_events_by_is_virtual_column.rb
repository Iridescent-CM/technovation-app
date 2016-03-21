class IdentifyVirtualEventsByIsVirtualColumn < ActiveRecord::Migration
  def change
    Event.update_all(is_virtual: false)

    Event.where(name: 'Virtual Judging').update_all(is_virtual: true)
  end
end
