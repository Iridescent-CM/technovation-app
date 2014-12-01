class SettingsController < ApplicationController
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true

  def create
    Setting.create(params[setting_params])
  end

  private
    def setting_params
      params.require(:key, :value).permit
    end

end
