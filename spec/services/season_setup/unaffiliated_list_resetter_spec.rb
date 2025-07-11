require "rails_helper"

RSpec.describe SeasonSetup::UnaffiliatedListResetter do
  let(:unaffiliated_list_resetter) { SeasonSetup::UnaffiliatedListResetter.new }
  let(:account) { FactoryBot.create(:account) }

  describe "#call" do
    context "when an account is on the unaffilated list (i.e. `no_chapterable_selected`)" do
      before do
        account.update(no_chapterable_selected: true)
      end

      it "resets `no_chapterable_selected`" do
        unaffiliated_list_resetter.call

        expect(account.reload.no_chapterable_selected?).to eq(false)
      end
    end

    context "when an account doesn't have any chapterables in their region (i.e. `no_chapterables_available`)" do
      before do
        account.update(no_chapterables_available: true)
      end

      it "resets `no_chapterables_available`" do
        unaffiliated_list_resetter.call

        expect(account.reload.no_chapterables_available?).to eq(false)
      end
    end
  end
end
