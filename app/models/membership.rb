class Membership < ActiveRecord::Base
  scope :current, ->(account) {
    where("joinable_id IN (?)", account.teams.current.pluck(:id))
  }

  after_destroy -> {
    joinable.reconsider_division_with_save
  }

  belongs_to :member, polymorphic: true
  belongs_to :joinable, polymorphic: true, touch: true

  delegate :address_details, :city, :state_province, :country, :email,
    to: :member,
    prefix: true
end
