class NullConsentWaiver < NullObject
  def status; "none"; end
  def destroy; false; end
  def paranoid?; false; end
end
