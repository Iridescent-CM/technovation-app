require "spec_helper"
require "./app/models/date_based_setting"

class TestDateSetting < DateBasedSetting
  def self.open!(prefix, date)
    reset_setting("#{prefix}KeyMethod", date)
  end
end

RSpec.describe "Set a date based setting" do
  let(:setting) { double(:Setting) }

  before do
    allow(DateBasedSetting).to receive(:setting) { setting }
    allow(setting).to receive(:find_by) { nil }
  end

  it "can set openers with custom arguments" do
    expect(setting).to receive(:create!).with({
      key: "prefixKeyMethod",
      value: Date.today.to_s
    })

    TestDateSetting.open!(:prefix, Date.today)
  end
end
