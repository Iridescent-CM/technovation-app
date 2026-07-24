# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::DashboardsController, "password expiry redirect" do
  it "redirects expired admins to the password change form" do
    admin = FactoryBot.create(:admin)
    admin.account.update_columns(password_changed_at: 91.days.ago)
    sign_in(admin)

    get :show

    expect(response).to redirect_to(new_admin_password_path)
  end

  it "allows admins with a fresh password" do
    admin = FactoryBot.create(:admin)
    admin.account.update_columns(password_changed_at: 1.day.ago)
    sign_in(admin)

    get :show

    expect(response).to be_successful
  end
end
