class TeamNameUniquenessValidator < ActiveModel::Validator
  def validate(record)
    current_conflicts = Team.current
      .where("lower(name) = ?", record.name.downcase)
      .where.not(id: record.id)

    past_conflicts = Team.past
      .where("lower(name) = ?", record.name.downcase)
      .where.not(id: record.id)
      .where.not(
        name: record.members.flat_map { |m|
          m.past_teams.pluck(:name)
        }.uniq
      )

    if current_conflicts.exists? || past_conflicts.exists?
      record.errors.add(:name, :taken)
    end
  end
end
