class UpdateCurrentAccountSeasonRegistrations < ActiveRecord::Migration[5.1]
  def up
    Account.current.find_each do |a|
      a.update_column(:season_registered_at, a.updated_at)
    end
  end
end
