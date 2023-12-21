module GridCanFilterByState
  def self.call(grid)
    (grid.admin or grid.allow_state_search) and
      grid.country.one? and
      CS.get(grid.country[0]).any?
  end
end
