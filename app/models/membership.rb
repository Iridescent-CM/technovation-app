class Membership < ActiveRecord::Base
  after_destroy -> {
    Casting.delegating(team => DivisionChooser) do
      team.reconsider_division_with_save
    end
  }

  belongs_to :member, polymorphic: true
  belongs_to :team, touch: true

  delegate :address_details, :city, :state_province, :country, :email,
    to: :member,
    prefix: true

  validates :member_id, uniqueness: { scope: [:team_id, :member_type] }
end
