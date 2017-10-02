class TeamNameUniquenessValidator < ActiveModel::Validator
  def validate(record)
    current_conflicts = Team.current
      .where("lower(name) = ?", record.name.downcase)
      .where.not(id: record.id)

    past_conflicts = Team.past
      .where("lower(name) = ?", record.name.downcase)
      .where.not(id: record.id)

    if record.name_uniqueness_exceptions.any?
      past_conflicts = past_conflicts.where.not(name: record.name_uniqueness_exceptions)
    end

    if current_conflicts.exists? || past_conflicts.exists?
      record.errors.add(:name, :taken)
    end
  end
end
