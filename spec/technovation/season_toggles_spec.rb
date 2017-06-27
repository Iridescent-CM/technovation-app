require "fakeredis"
needs "technovation"
require "season_toggles"

RSpec.describe SeasonToggles do
  def expect_bad_input_raises_error(options)
    [nil, "", " ", "foo"].each do |bad|
      expect {
        SeasonToggles.public_send("#{options[:method]}=", bad)
      }.to raise_error(
        SeasonToggles::InvalidInput,
        "No toggle exists for #{bad}. Use one of: #{options[:valid_input]}"
      )
    end
  end

  def expect_good_input_works(options)
    options[:valid_input].each do |good|
      expect {
        SeasonToggles.public_send("#{options[:method]}=", good)
      }.not_to raise_error
    end
  end

  describe "#judging_round=" do
    context "valid input" do
      it "allows a specific set of values" do
        expect_good_input_works(
          method: :judging_round,
          valid_input: SeasonToggles::VALID_JUDGING_ROUNDS +
            %i{QF SF qF Sf QuarteRfinals quaRter_fiNals sEmifinals sEmi_finals oFf}
        )
      end

      it "reads back #current_judging_round" do
        SeasonToggles::VALID_JUDGING_ROUNDS.each do |jr|
          SeasonToggles.judging_round = jr
          expect(SeasonToggles.judging_round).to eq(jr)
        end
      end
    end

    context "bad input" do
      it "raises an exception" do
        expect_bad_input_raises_error(
          method: :judging_round,
          valid_input: SeasonToggles::VALID_JUDGING_ROUNDS.join('|')
        )
      end
    end
  end

  describe "#student_signup=" do
    context "valid input" do
      it "allows a collection of 'boolean' words and booleans" do
        expect_good_input_works(
          method: :student_signup,
          valid_input: SeasonToggles::VALID_BOOLS +
            %i{On oFf yEs nO tRue fAlse}
        )
      end

      it "reads back a boolean from #student_signup?" do
        SeasonToggles::VALID_TRUTHY.each do |on|
          SeasonToggles.student_signup = on
          expect(SeasonToggles.student_signup?).to be true
        end

        SeasonToggles::VALID_FALSEY.each do |off|
          SeasonToggles.student_signup = off
          expect(SeasonToggles.student_signup?).to be false
        end
      end
    end

    context "bad input" do
      it "raises an exception" do
        expect_bad_input_raises_error(
          method: :student_signup,
          valid_input: SeasonToggles::VALID_BOOLS.join('|')
        )
      end
    end
  end
end
