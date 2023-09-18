class NullBackgroundCheck < NullObject
  def id; 0; end
  def updated_at; 0; end
  def status; "none"; end
  def new_record?; false; end
  def clear?; false; end
  def pending?; false; end
  def consider?; false; end
  def suspended?; false; end
  def paranoid?; false; end
  def invitation_sent?; false; end
end
