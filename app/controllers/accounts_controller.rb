class AccountsController < ApplicationController
  include AccountController

  before_filter :authenticate_account!

  helper_method :current_account

  def edit
    account
  end

  def update
    if account.update_attributes(account_params)
      redirect_to account_path,
                  success: t('controllers.accounts.update.success')
    else
      render :edit
    end
  end

  private
  def account
    @account ||= Account.find_with_token(cookies.fetch(:auth_token) { "" })
  end

  def current_account
    @current_account ||= Account.find_with_token(cookies.fetch(:auth_token) { "" })
  end

  def authenticate_account!
    unless current_account.authenticated?
      save_redirected_path
      go_to_signin("user")
    end
  end
end
