class DivisionsDecorator
  include Enumerable

  def initialize(collection)
    @collection = Array(collection)
  end

  def each(&block)
    @collection.each { |i| block.call(DivisionDecorator.new(i)) }
  end
end

class DivisionDecorator
  def initialize(division)
    @division = division
  end

  def name
    @division.name.titleize
  end
end
