class AddOrganizerToEvents < ActiveRecord::Migration
  def change
    add_column :events, :organizer, :string
  end
end
