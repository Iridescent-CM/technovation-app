require "./app/null_objects/null_profile"

class NullAccount < NullObject
  def id; nil; end
  def name; 'null account'; end
  def mentor_profile; ::NullProfile.new; end
  def judge_profile; ::NullProfile.new; end
  def student_profile; ::NullProfile.new; end
  def current_certificates; NullCertificates.new; end
  def update_column(*); false; end
  def reload; self; end
  def authenticated?; false; end

  class NullCertificates
    def destroy_all; false; end
  end
end
