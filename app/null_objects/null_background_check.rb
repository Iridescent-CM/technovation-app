class NullBackgroundCheck < NullObject
  def id; 0; end
  def updated_at; 0; end
  def status; "none"; end
  def clear?; false; end
  def pending?; false; end
  def consider?; false; end
  def suspended?; false; end
end