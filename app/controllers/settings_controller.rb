class SettingsController < ApplicationController
  def create
    Setting.create(params[setting_params])
  end

  private
    def setting_params
      params.require(:key, :value).permit
    end

end
