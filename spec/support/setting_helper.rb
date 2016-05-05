require "ostruct"

module SettingHelper
  def stub_submissions_to_open_on(date)
    # Stub the submissions open/close dates
    # Yes, this knowledge needs to be improved
    setting_record = OpenStruct.new(value: date.to_s)
    setting = double(:setting, :find_by! => setting_record)
    allow(Submissions).to receive(:setting) { setting }
  end
end
