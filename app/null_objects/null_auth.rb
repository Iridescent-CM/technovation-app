class NullAuth
  def authenticated?; false; end
  def admin?; false; end
  def present?; false; end

  def scope_name; 'application'; end
  def team; nil; end
  def teams; []; end

  def locale; I18n.default_locale; end

  def admin_profile; NullProfile.new; end
  def judge_profile; NullProfile.new; end
  def mentor_profile; NullProfile.new; end
  def regional_ambassador_profile; NullProfile.new; end
  def student_profile; NullProfile.new; end
end
