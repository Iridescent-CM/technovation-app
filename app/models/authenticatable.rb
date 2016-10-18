require 'active_support/concern'

module Authenticatable
  extend ActiveSupport::Concern

  included do
    belongs_to :account
  end

  def authenticated?
    true
  end
end
