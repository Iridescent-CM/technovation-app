class SignatureController < ApplicationController
  before_action :find_user, except: [:status, :resend]
  skip_before_filter :verify_consent
  skip_before_filter :verify_survey_done
  skip_before_filter :verify_bg_check

  def status
    if current_user == nil
      redirect_to :root
    end
  end

  def create
    @user.consent_signed_at = DateTime.now
    @user.save!
    SignatureMailer.confirmation_email(@user).deliver
    flash[:notice] = 'Signature signed! Thanks!'

    if current_user.nil? 
      render 'index'
    else
      redirect_to :root
    end
  end

  def resend
    if current_user.consent_signed_at.nil?
      unless current_user.consent_sent_at.nil?
        sent_mins_ago = ((DateTime.now - current_user.consent_sent_at.to_datetime) * 60 * 24).round
        if sent_mins_ago < 10
          flash[:alert] = "Please wait at least #{10 - sent_mins_ago} more minutes before attempting to resend"
          redirect_to :back
          return
        end
      end
      SignatureMailer.signature_email(current_user).deliver
      flash[:notice] = 'Consent email resent!'
      current_user.consent_sent_at = DateTime.now
      current_user.save!
    end
    redirect_to :back
  end

  # allowed for everyone
  def verify_authorized
    true
  end

  def find_user
    if SignatureController.valid? params[:hash]
      @user = User.find_by_id(params[:hash].split('.')[0].to_i)
      if @user != nil
        return true
      end
    end
    redirect_to '/'
  end

  def self.link(user)
    Rails.application.routes.url_helpers.url_for(
      controller: :signature,
      action: :index,
      hash: SignatureController.generate(user.id),
    )
  end

  def self.generate(user_id)
    message = user_id.to_s
    hmac = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha1'),
      Rails.application.secrets.secret_key_base,
      message)
    message + '-' + hmac
  end

  def self.valid?(token)
    message, signature = token.split('-')
    hmac = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha1'),
      Rails.application.secrets.secret_key_base,
      message)
    signature == hmac
  end
end
