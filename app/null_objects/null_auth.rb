class NullAuth < NullObject
  def id; "GUEST"; end
  def authenticated?; false; end
  def admin?; false; end
  def can_be_a_mentor?(*); false; end
  def can_be_a_judge?; false; end
  def terms_agreed?; false; end

  def scope_name; 'application'; end
  def team; nil; end
  def teams; []; end

  def locale; I18n.default_locale; end

  def admin_profile; ::NullProfile.new; end
  def judge_profile; ::NullProfile.new; end
  def mentor_profile; ::NullProfile.new; end
  def chapter_ambassador_profile; ::NullProfile.new; end
  def student_profile; ::NullProfile.new; end
end
