class NullChapterAmbassador < NullObject
  def random_id; 0; end
  def name; nil; end
  def provided_intro?; false; end
  def scope_name; nil; end
  def profile_image; OpenStruct.new(thumb: OpenStruct.new(url: '')); end
  def program_name; nil; end
end
