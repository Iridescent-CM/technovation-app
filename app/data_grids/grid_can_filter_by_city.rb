module GridCanFilterByCity
  def self.call(grid)
    country = grid.country[0]
    state = grid.state_province[0]

    grid.state_province.one? and CS.get(country, state).any?
  end
end
