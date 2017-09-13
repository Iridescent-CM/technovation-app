module RemoveEmptyTeams
  def self.call(logger = Logger.new("/dev/null"))
    teams = Team.left_outer_joins(:memberships).where(memberships: { id: nil })
    logger.info(
      "Deleting #{teams.count} empty teams out of #{Team.count} total teams"
    )
    teams.destroy_all
  end
end
