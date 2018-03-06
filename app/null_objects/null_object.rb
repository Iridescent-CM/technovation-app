class NullObject < BasicObject
  def present?
    false
  end

  def blank?
    true
  end
end
