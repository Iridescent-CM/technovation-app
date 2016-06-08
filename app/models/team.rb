class Team < ActiveRecord::Base
  has_many :season_registrations, as: :registerable
  has_many :seasons, through: :season_registrations

  belongs_to :division
  belongs_to :region

  has_many :memberships, as: :joinable
  has_many :members, through: :memberships, source_type: "TeamMember"
end
