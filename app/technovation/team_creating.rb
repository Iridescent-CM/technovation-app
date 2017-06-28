class TeamCreating
  def initialize(attrs)
    @team = Team.new(attrs)
  end

  def save
    @team.save
  end

  def as_json
    @team.as_json(
      only: %i{id name},
      methods: :link_to_path
    )
  end

  def errors
    @team.errors
  end
end
