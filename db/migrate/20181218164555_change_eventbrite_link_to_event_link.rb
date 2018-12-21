class ChangeEventbriteLinkToEventLink < ActiveRecord::Migration[5.1]
  def up
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    enable_extension "hstore"

    rename_column :regional_pitch_events, :eventbrite_link, :event_link
  end

  def down
    rename_column :regional_pitch_events, :event_link, :eventbrite_link
  end
end
