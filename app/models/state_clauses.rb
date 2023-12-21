class StateClauses
  def self.for(values:, countries:, table_name:, operator:)
    Array(values).map { |value|
      state = State.for(value, countries)

      "lower(unaccent(#{table_name}.state_province)) like " +
        "'#{state.search_spec}%'"
    }.join(" #{operator} ")
  end
end
