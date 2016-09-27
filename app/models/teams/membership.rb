class Membership < ActiveRecord::Base
  belongs_to :member, polymorphic: true
  belongs_to :joinable, polymorphic: true

  delegate :address_details, :city, :state_province, :country,
    to: :member,
    prefix: true
end
