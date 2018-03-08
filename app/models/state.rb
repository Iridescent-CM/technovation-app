class State
  attr_reader :value

  def self.for(value, countries)
    countries = Array(countries)

    if countries.include?("MX")
      MexicoState.new(value)
    elsif countries.include?("IN")
      IndiaState.new(value)
    else
      new(value)
    end
  end

  def initialize(value)
    @value = value
  end

  def search_spec
    format_map.fetch(value) { value.downcase }
  end

  def format_map
    {}
  end
end

class MexicoState < State
  def format_map
    {
      "BCS" => "b.c.s.",
      "CMX" => "cdmx",
      "DIF" => "cdmx",
      "GUA" => "gto",
      "HID" => "hgo",
      "NLE" => "n.l.",
      "SLP" => "s.l.p.",
    }
  end
end

class IndiaState < State
  def format_map
    {
      "TG" => "telangana",
    }
  end
end
