require "rails_helper"

describe SeasonFlag do
  let(:season_flag) { SeasonFlag.new(account) }
  let(:account) { instance_double(Account, scope_name: scope_name, seasons: seasons) }
  let(:scope_name) { "Judge" }
  let(:seasons) { [2010] }

  before do
    allow(Season).to receive_message_chain(:current, :year).and_return(2021)
  end

  describe "#text" do
    context "when account type (scope_name) is student" do
      let(:scope_name) { "student" }

      context "when the student is new - the current season is their first/only season" do
        let(:seasons) { [2021] }

        it "returns the string 'New student'" do
          expect(season_flag.text).to eq("New student")
        end
      end

      context "when the student participated in a previous season, and not the current season" do
        let(:seasons) { [2020, 2021] }

        it "returns the string 'Returning student'" do
          expect(season_flag.text).to eq("Returning student")
        end
      end

      context "when the student participated in a previous season, but not the current season" do
        let(:seasons) { [2010] }

        it "returns the string 'Past student'" do
          expect(season_flag.text).to eq("Past student")
        end
      end
    end
  end
end
