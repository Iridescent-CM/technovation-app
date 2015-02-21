class Users::ConfirmationsController < Devise::ConfirmationsController
  protected
  def after_resending_confirmation_instructions_path_for(resource_name)
    if signed_in?
      flash[:notice] = "Confirmation Email Sent" #this is optional since devise already sets the flash message
      root_path
    else
      new_session_path(resource_name)
    end
  end
end
