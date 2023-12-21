class StateClause
  def self.for(value, countries, table_name)
    state = State.for(value, countries)

    "lower(unaccent(#{table_name}.state_province)) like " +
      "'#{state.search_name}%'"
  end
end
