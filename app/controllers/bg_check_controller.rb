class BgCheckController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user
  skip_before_filter :verify_consent
  skip_before_filter :verify_bg_check
  skip_before_filter :verify_registered

  def index
  end

  def update

    @user.update_attributes(user_params)

    params = {
      first_name: @user.first_name,
      middle_name: @user.middle_name,
      last_name: @user.last_name,
      email: @user.email,
      phone: @user.phone,
      zipcode: @user.postal_code,
      dob: @user.birthday.to_s,
      ssn: @user.ssn,
      copy_requested: ((@user.mn_copy == '1') or (@user.ca_copy == '1')),
    }

    if @user.fcra_ok == '0'
      @user.errors.add :fcra_ok, 'You must acknowledge receipt'
    end

    if @user.drbi_ok == '0'
      @user.errors.add :drbi_ok, 'You must acknowledge receipt'
    end

    if @user.signature.blank?
      @user.errors.add :signature, 'You must sign the document'
    end

    if @user.middle_name.blank?
      @user.errors.add :middle_name, 'You must provide your middle name for the background check'
    end

    if !@user.errors.empty? or !@user.save
      flash.now[:alert] = 'Please correct the errors below'
    else
      if Rails.application.config.env[:checkr][:skip]
        @user.bg_check_id = 'fake'
        @user.bg_check_submitted = DateTime.now
        @user.save!
        flash[:notice] = 'Thank you for submitting the background check. Your account is now active.'
        redirect_to :root
        return
      else
        request = Typhoeus.post(
          'https://api.checkr.io/v1/candidates',
          userpwd: Rails.application.config.env[:checkr][:auth],
          params: params,
        )
        if request.success?
          data = JSON.parse(request.body)
          @user.bg_check_id = data['id']
          @user.save!
          report = Typhoeus.post(
            'https://api.checkr.io/v1/reports',
            userpwd: Rails.application.config.env[:checkr][:auth],
            params: {
              package: Rails.application.config.env[:checkr][:package],
              candidate_id: @user.bg_check_id,
            }
          )

          if report.success?
            @user.bg_check_submitted = DateTime.now
            @user.save!
            flash[:notice] = 'Thank you for submitting the background check. Your account is now active.'
            redirect_to :root
            return
          else
            flash.now[:alert] = "Error: #{report.body}"
          end

        else
          data = JSON.parse(request.body)
          flash.now[:alert] = data['error']
        end
      end
    end
    render 'index'
  end

  def self.bg_check_required?(user)
    !user.nil? and user.mentor? and user.home_country == 'US' and user.bg_check_id.nil?
  end

  private
  def check_user
    @user = current_user
    authorize @user
    if !BgCheckController.bg_check_required?(@user)
      redirect_to :root
    end
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :birthday,
      :postal_code,
      :ssn,

      :middle_name, :ssn, :phone,
      :fcra_ok, :drbi_ok,
      :mn_copy, :ca_copy,
      :signature
    )
  end

end
