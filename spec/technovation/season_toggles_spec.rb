require "rails_helper"

RSpec.describe SeasonToggles do
  before do
    redis = Redis.new
    redis.flushdb
  end

  describe ".configure" do
    it "fixes the order of attributes for judging round dependency" do
      # judging is on
      SeasonToggles.judging_round = :qf

      # judging is turned off, but passed after the dependent setting
      SeasonToggles.configure({
        select_regional_pitch_event: true,
        judging_round: :off,
      })

      # dependent setting was set correctly
      expect(SeasonToggles.select_regional_pitch_event?).to be true
    end
  end

  describe ".team_submissions_editable=" do
    it "raises exception for bad input" do
      expect_bad_input_raises_error(
        method: :team_submissions_editable,
        valid_input: valid_bools.join(" | ")
      )
    end

    it "accepts valid booleans" do
      expect_good_input_works(
        valid_input: valid_bools,
        method: :team_submissions_editable
      )
    end
  end

  describe ".team_submissions_editable?" do
    it "is true when team submissions are editable" do
      SeasonToggles.team_submissions_editable = "oN"
      expect(SeasonToggles.team_submissions_editable?).to be true
    end

    it "is false when team submissions are not editable" do
      SeasonToggles.team_submissions_editable = "No"
      expect(SeasonToggles.team_submissions_editable?).to be false
    end

    it "cannot be true when judging is enabled" do
      SeasonToggles.configure({
        team_submissions_editable: true,
        judging_round: :qf,
      })
      expect(SeasonToggles.team_submissions_editable?).to be false
    end
  end

  describe ".team_building_enabled?" do
    it "cannot be true when judging is enabled" do
      SeasonToggles.configure({
        team_building_enabled: true,
        judging_round: :qf,
      })
      expect(SeasonToggles.team_building_enabled?).to be false
    end
  end

  describe ".display_scores?" do
    it "cannot be true when judging is enabled" do
      SeasonToggles.configure({
        display_scores: true,
        judging_round: :qf,
      })
      expect(SeasonToggles.display_scores?).to be false
    end
  end


  %w{mentor student}.each do |scope|
    describe ".#{scope}_survey_link=" do
      it "takes a hash and returns values" do
        SeasonToggles.public_send("#{scope}_survey_link=", {
          text: "Hello World",
          url: "https://google.com",
        })

        expect(SeasonToggles.survey_link(scope, "text")).to eq("Hello World")
        expect(SeasonToggles.survey_link(scope, "url")).to eq("https://google.com")
      end

      it "sets changed_at when configured" do
        SeasonToggles.set_survey_link(scope, "Hello World", "https://google.com")

        expect(SeasonToggles.survey_link(scope, "changed_at")).not_to be_nil
      end

      it "updates changed_at when changed" do
        Timecop.freeze(Time.current)    # won't register changes faster than 1 second
        SeasonToggles.set_survey_link(scope, "Hello World", "https://google.com")

        Timecop.freeze(Time.now + 1.second) do
          last_changed = SeasonToggles.survey_link(scope, "changed_at")
          SeasonToggles.set_survey_link(scope, "Goodbye World", "https://google.com")
          expect(SeasonToggles.survey_link(scope, "changed_at")).to be > last_changed
        end

        Timecop.freeze(Time.now + 2.seconds) do
          last_changed = SeasonToggles.survey_link(scope, "changed_at")
          SeasonToggles.set_survey_link(scope, "Goodbye World", "https://yahoo.com")
          expect(SeasonToggles.survey_link(scope, "changed_at")).to be > last_changed
        end
      end

      it "leaves changed_at when not changed" do
        Timecop.freeze(Time.current)
        SeasonToggles.set_survey_link(scope, "Hello World", "https://google.com")

        Timecop.freeze(Time.now + 1.second) do
          last_changed = SeasonToggles.survey_link(scope, "changed_at")
          SeasonToggles.set_survey_link(scope, "Hello World", "https://google.com")
          expect(SeasonToggles.survey_link(scope, "changed_at")).to eq(last_changed)
        end
      end
    end

    describe ".survey_link_available?" do
      it "returns true if the text and url are present" do
        SeasonToggles.public_send("#{scope}_survey_link=", {
          text: "Hello World",
          url: "https://google.com",
        })

        expect(SeasonToggles.survey_link_available?(scope)).to be true
      end

      it "returns false if unset" do
        expect(SeasonToggles.survey_link_available?(scope)).to be false
      end

      it "returns false if the text or url are blank" do
        [{ url: "https://google.com" },
         { text: "Hello, World" },
         { text: "", url: "https://..." },
         { text: "hello...", url: "" }].each do |bad|
          SeasonToggles.public_send("#{scope}_survey_link=", bad)
          expect(SeasonToggles.survey_link_available?(scope)).to be false
        end
      end
    end
  end

  describe ".judging_round=" do
    context "valid input" do
      it "allows a specific set of values" do
        expect_good_input_works(
          method: :judging_round,
          valid_input: valid_judging_rounds +
            %i{QF SF qF Sf QuarteRfinals quaRter_fiNals sEmifinals sEmi_finals oFf}
        )
      end

      it "reads back #judging_round" do
        valid_judging_rounds.each do |jr|
          SeasonToggles.judging_round = jr
          expect(SeasonToggles.judging_round).to eq(jr)
        end
      end

      it "aliases #current_judging_round for #judging_round" do
        valid_judging_rounds.each do |jr|
          SeasonToggles.judging_round = jr
          expect(SeasonToggles.current_judging_round).to eq(jr)
        end
      end

      it "reads back from #quarterfinals_judging?" do
        SeasonToggles.judging_round = :qf
        expect(SeasonToggles.quarterfinals_judging?).to be true

        SeasonToggles.judging_round = :quaRter_fiNals
        expect(SeasonToggles.quarterfinals_judging?).to be true

        SeasonToggles.judging_round = :sf
        expect(SeasonToggles.quarterfinals_judging?).to be false

        SeasonToggles.judging_round = :semi_Finals
        expect(SeasonToggles.quarterfinals_judging?).to be false

        SeasonToggles.judging_round = :ofF
        expect(SeasonToggles.quarterfinals_judging?).to be false
      end

      it "reads back from #semifinals_judging?" do
        SeasonToggles.judging_round = :sf
        expect(SeasonToggles.semifinals_judging?).to be true

        SeasonToggles.judging_round = :semI_fiNals
        expect(SeasonToggles.semifinals_judging?).to be true

        SeasonToggles.judging_round = :qf
        expect(SeasonToggles.semifinals_judging?).to be false

        SeasonToggles.judging_round = :quarteR_Finals
        expect(SeasonToggles.semifinals_judging?).to be false

        SeasonToggles.judging_round = :ofF
        expect(SeasonToggles.semifinals_judging?).to be false
      end

      it "aliases semifinals? and quarterfinals? appropriately" do
        SeasonToggles.judging_round = :ofF
        expect(SeasonToggles.semifinals?).to be false
        expect(SeasonToggles.quarterfinals?).to be false

        SeasonToggles.judging_round = :qf
        expect(SeasonToggles.semifinals?).to be false
        expect(SeasonToggles.quarterfinals?).to be true

        SeasonToggles.judging_round = :sf
        expect(SeasonToggles.semifinals?).to be true
        expect(SeasonToggles.quarterfinals?).to be false
      end
    end

    context "bad input" do
      it "raises an exception" do
        expect_bad_input_raises_error(
          method: :judging_round,
          valid_input: valid_judging_rounds.join(' | ')
        )
      end
    end
  end

  describe ".select_regional_pitch_event" do
    context "valid input" do
      it "allows a collection of 'boolean' words and booleans" do
        expect_good_input_works(
          method: "select_regional_pitch_event",
          valid_input: valid_bools + %i{On oFf yEs nO tRue fAlse}
        )
      end

      it "reads back a boolean from .select_regional_pitch_event?" do
        valid_truthy.each do |on|
          SeasonToggles.select_regional_pitch_event=on
          expect(SeasonToggles.select_regional_pitch_event?).to be true
        end

        valid_falsey.each do |off|
          SeasonToggles.select_regional_pitch_event=off
          expect(SeasonToggles.select_regional_pitch_event?).to be false
        end
      end

      it "cannot be true while judging is enabled" do
        SeasonToggles.configure({
          select_regional_pitch_event: true,
          judging_round: :sf,
        })
        expect(SeasonToggles.select_regional_pitch_event?).to be false
      end
    end

    context "bad input" do
      it "raises an exception" do
        expect_bad_input_raises_error(
          method: "select_regional_pitch_event",
          valid_input: valid_bools.join(' | ')
        )
      end
    end
  end

  %i(student mentor judge regional_ambassador).each do |scope|
    describe ".#{scope}_signup=" do
      context "valid input" do
        it "allows a collection of 'boolean' words and booleans" do
          expect_good_input_works(
            method: "#{scope}_signup",
            valid_input: valid_bools + %i{On oFf yEs nO tRue fAlse}
          )
        end

        it "reads back a boolean from ##{scope}_signup?" do
          SeasonToggles.enable_signup(scope)
          expect(SeasonToggles.signup_enabled?(scope)).to be true

          SeasonToggles.disable_signup(scope)
          expect(SeasonToggles.signup_enabled?(scope)).to be false
        end

        next unless %i{student mentor}.include?(scope)
        context "student, mentor" do
          it "cannot be true while judging is enabled" do
            SeasonToggles.configure({
              "#{scope}_signup" => true,
              judging_round: :Qf,
            })
            expect(SeasonToggles.signup_enabled?(scope)).to be false
          end
        end
      end

      context "bad input" do
        it "raises an exception" do
          expect_bad_input_raises_error(
            method: "#{scope}_signup",
            valid_input: valid_bools.join(' | ')
          )
        end
      end
    end
  end

  def valid_bools
    SeasonToggles::BooleanToggler::VALID_BOOLS
  end

  def valid_truthy
    SeasonToggles::BooleanToggler::VALID_TRUTHY
  end

  def valid_falsey
    SeasonToggles::BooleanToggler::VALID_FALSEY
  end

  def valid_judging_rounds
    SeasonToggles::JudgingRoundToggles::VALID_JUDGING_ROUNDS
  end

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
end
