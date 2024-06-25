class NullChapter < NullObject
  def name
    nil
  end

  def summary
    nil
  end

  def chapter_program_information
    ChapterProgramInformation.none
  end

  def build_chapter_program_information
    ChapterProgramInformation.none
  end
end
