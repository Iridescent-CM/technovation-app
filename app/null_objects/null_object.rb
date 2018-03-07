class NullObject < BasicObject
  def present?
    false
  end

  def blank?
    true
  end

  def nil?
    true
  end
end
