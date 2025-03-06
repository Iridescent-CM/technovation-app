class NullChapterableAccountAssignment < NullObject
  def chapterable
    NullChapterable.new
  end

  def primary
    false
  end

  def chapterable_id
    nil
  end

  def chapterable_type
    nil
  end
end
