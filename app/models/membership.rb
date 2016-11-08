class Membership < ActiveRecord::Base
  scope :current, ->(account) { where("joinable_id IN (?)", account.teams.current.pluck(:id)) }

  belongs_to :member, polymorphic: true
  belongs_to :joinable, polymorphic: true

  delegate :address_details, :city, :state_province, :country, :email,
    to: :member,
    prefix: true
end
