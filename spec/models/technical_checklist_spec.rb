require "rails_helper"

RSpec.describe TechnicalChecklist do
  it "counts the total verified" do
    tc = TechnicalChecklist.create!({
      used_canvas_verified: true,
      used_sharing_verified: true,
      used_sms_phone_verified: true,
    })

    expect(tc.total_verified).to eq(3)
  end
end
