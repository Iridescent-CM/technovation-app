class State
  attr_reader :value

  def self.for(value, countries)
    countries = Array(countries)

    if countries.include?("MX")
      MexicoState.new(value)
    elsif countries.include?("IN")
      IndiaState.new(value)
    elsif countries.include?("KE")
      KenyaState.new(value)
    elsif countries.include?("PT")
      PortugalState.new(value)
    else
      new(value)
    end
  end

  def initialize(value)
    @value = value.gsub("'", "''")
  end

  def search_spec
    format_map.fetch(value) { value.downcase }
  end

  def format_map
    {}
  end
end

class KenyaState < State
  def format_map
    {
      "10" => "kajiado",
      "13" => "kiambu",
      "16" => "kisii",
      "17" => "kisumu",
      "20" => "laikipia",
      "28" => "mombasa",
      "30" => "nairobi",
      "31" => "nakuru",
      "44" => "uasin",
    }
  end
end

class PortugalState < State
  def format_map
    {
      "01" => "aveiro",
      "03" => "braga",
      "05" => "castelo branco",
      "06" => "coimbra",
      "07" => "evora",
      "08" => "faro",
      "10" => "leiria",
      "11" => "lisbon",
      "13" => "porto",
      "14" => "santarem",
      "15" => "setubal",
      "30" => "madeira"
    }
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
