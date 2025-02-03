require "rails_helper"

RSpec.describe NullChapterable do
  let(:null_chapter) { NullChapterable.new }

  describe "#name" do
    it "returns nil" do
      expect(null_chapter.name).to eq(nil)
    end
  end

  describe "#summary" do
    it "returns nil" do
      expect(null_chapter.summary).to eq(nil)
    end
  end

  describe "#chapter_program_information" do
    it "returns an empty chapter_program_information result set" do
      expect(null_chapter.chapter_program_information).to eq(ChapterProgramInformation.none)
    end
  end

  describe "#build_chapter_program_information" do
    it "returns an empty chapter_program_information result set" do
      expect(null_chapter.build_chapter_program_information).to eq(ChapterProgramInformation.none)
    end
  end
end
