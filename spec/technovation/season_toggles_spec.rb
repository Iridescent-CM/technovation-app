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
