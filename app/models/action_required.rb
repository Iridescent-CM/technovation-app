class ActionRequired
  attr_reader :action

  def initialize(action)
    @action = action
    freeze
  end

  def to_s
    name
  end

  def name
    action
  end

  def message
    case action
    when :join_team then "You must join a team first"
    else
      "[Error] ActionRequired#message is missing for `:#{action}`"
    end
  end
end
