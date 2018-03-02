class State
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def search_name
    case value
    when "DIF"
      "cdmx"
    when "BCS"
      "b.c.s."
    else
      value.downcase
    end
  end
end
