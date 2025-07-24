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

  describe "#program_information" do
    it "returns an empty program_information result set" do
      expect(null_chapter.program_information).to eq(ProgramInformation.none)
    end
  end

  describe "#build_program_information" do
    it "returns an empty program_information result set" do
      expect(null_chapter.build_program_information).to eq(ProgramInformation.none)
    end
  end
end
