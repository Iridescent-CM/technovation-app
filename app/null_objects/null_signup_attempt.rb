class NullSignupAttempt < NullObject
  def id; 0; end
  def latitude; 0.0; end
  def longitude; 0.0; end
  def coordinates; [0.0, 0.0]; end
  def valid_coordinates?; false; end
end