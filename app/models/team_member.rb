class TeamMember < ActiveRecord::Base
  enum role: [ :student, :mentor, :coach ]
  has_many :memberships, as: :member
  has_many :teams, through: :memberships, source: :joinable, source_type: "Team"
end
