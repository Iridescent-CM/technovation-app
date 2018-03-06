class State
  attr_reader :value, :countries

  def initialize(value, countries)
    @value = value
    @countries = Array(countries)
  end

  def search_name
    if countries.include?("MX")
      case value
      when "DIF"
        "cdmx"
      when "BCS"
        "b.c.s."
      else
        value.downcase
      end
    elsif countries.include?("IN")
      case value
      when "TG"
        "telangana"
      else
        value.downcase
      end
    else
      value.downcase
    end
  end
end
