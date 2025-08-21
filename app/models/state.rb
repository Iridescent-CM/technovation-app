class State
  attr_reader :value

  def self.for(value, countries)
    countries = Array(countries)

    if countries.include?("MX")
      StateProvinces::MexicoState.new(value)
    elsif countries.include?("IN")
      StateProvinces::IndiaState.new(value)
    elsif countries.include?("KE")
      StateProvinces::KenyaState.new(value)
    elsif countries.include?("PT")
      StateProvinces::PortugalState.new(value)
    elsif countries.include?("KG")
      StateProvinces::KyrgyzstanState.new(value)
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
