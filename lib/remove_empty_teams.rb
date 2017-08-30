module RemoveEmptyTeams
  def self.execute
    teams = Team.left_outer_joins(:memberships).where(memberships: { id: nil })
    puts "Deleting #{teams.count} empty teams out of #{Team.count} total teams"
    teams.destroy_all
  end
end
