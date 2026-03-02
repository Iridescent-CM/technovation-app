class SetUnseasonedEventsTo2017 < ActiveRecord::Migration[5.1]
  def up
    RegionalPitchEvent.where(seasons: []).update_all(seasons: [2017])
  end

  def down
    RegionalPitchEvent.by_season(2017).update_all(seasons: [])
  end
end
