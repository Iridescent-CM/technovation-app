module ControllerHelpers
  def sign_in(user = double('user', consent_signed_at: DateTime.now, is_registered?: true))
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(BgCheckController).to receive(:bg_check_required?).and_return(false)
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end
