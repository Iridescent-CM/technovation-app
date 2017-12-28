class NullObject < BasicObject
  def method_missing(method_name, *args, &block)
    if nil.respond_to?(method_name)
      nil.send(method_name, *args, &block)
    else
      send(method_name, *args, &block)
    end
  end
end
