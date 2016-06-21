require 'active_support/concern'

module Authenticatable
  extend ActiveSupport::Concern

  included do
    belongs_to :authentication
  end

  def authenticated?
    true
  end

  def admin?
    false
  end
end
