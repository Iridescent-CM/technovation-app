require "spec_helper"
require "timecop"

RSpec.describe "Submissions" do
  class Submissions
    attr_reader :open_on
    attr_reader :close_on

    def initialize(options = {})
      @open_on = options[:open_on] || options[:close_on] - 30
      @close_on = options[:close_on] || open_on + 30
    end

    def open?
      open_on <= Date.today && close_on > Date.today
    end
  end

  it "is open after the submission open date" do
    submissions = Submissions.new(open_on: Date.new(2016, 4, 1))

    Timecop.freeze(Date.new(2016, 4, 1)) do
      expect(submissions.open?).to be true
    end
  end

  it "is not open before the submission open date" do
    submissions = Submissions.new(open_on: Date.new(2016, 4, 1))

    Timecop.freeze(Date.new(2016, 3, 31)) do
      expect(submissions.open?).to be false
    end
  end

  it "is open before the submission close date" do
    submissions = Submissions.new(close_on: Date.new(2016, 4, 2))

    Timecop.freeze(Date.new(2016, 4, 1)) do
      expect(submissions.open?).to be true
    end
  end

  it "is open on the close date" do
    skip "Not sure if it should be open or not ON the close date"
  end

  it "is not open after the submission close date" do
    submissions = Submissions.new(close_on: Date.new(2016, 4, 2))

    Timecop.freeze(Date.new(2016, 4, 3)) do
      expect(submissions.open?).to be false
    end
  end

  it "is open between the open and close on dates" do
    submissions = Submissions.new(open_on: Date.new(2016, 4, 1),
                                  close_on: Date.new(2016, 4, 2))

    Timecop.freeze(Date.new(2016, 3, 31)) do
      expect(submissions.open?).to be false
    end

    Timecop.freeze(Date.new(2016, 4, 1)) do
      expect(submissions.open?).to be true
    end

    Timecop.freeze(Date.new(2016, 4, 3)) do
      expect(submissions.open?).to be false
    end
  end
end
