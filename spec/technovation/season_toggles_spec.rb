require "fakeredis"
needs "technovation"
require "season_toggles"

RSpec.describe SeasonToggles do
  describe "#student_signup=" do
    context "valid input" do
      it "allows a collection of 'boolean' words and booleans" do
        (%w{on off yes no true false} + [true, false]).each do |good|
          expect { SeasonToggles.student_signup = good }.not_to raise_error
        end
      end

      it "reads back a boolean from #student_signup?" do
        (%w{on yes true} + [true]).each do |on|
          SeasonToggles.student_signup = on
          expect(SeasonToggles).to be_student_signup
        end

        (%w{off no false} + [false]).each do |off|
          SeasonToggles.student_signup = off
          expect(SeasonToggles).not_to be_student_signup
        end
      end
    end

    context "bad input" do
      it "rasies an exception" do
        [nil, "", " ", "foo"].each do |bad|
          expect {
            SeasonToggles.student_signup = bad
          }.to raise_error(
            SeasonToggles::InvalidInput,
            "Use one of: #{SeasonToggles::VALID_BOOLS}"
          )
        end
      end
    end
  end
end
