class NullChapterableAccountAssignment < NullObject
  def chapterable
    NullChapterable.new
  end
end
