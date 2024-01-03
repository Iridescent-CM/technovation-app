class CityClauses
  def self.for(values:, table_name:, operator:)
    values.flatten.map { |v|
      v = (v === "Mexico City") ? "Ciudad de México" : v
      v = v.gsub("'", "''")
      "lower(unaccent(#{table_name}.city)) = lower(unaccent('#{v}'))"
    }.join(" #{operator} ")
  end
end
