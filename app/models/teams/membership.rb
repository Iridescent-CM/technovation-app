class Membership < ActiveRecord::Base
  belongs_to :member, polymorphic: true
  belongs_to :joinable, polymorphic: true

  delegate :address_details, to: :member, prefix: true
end
