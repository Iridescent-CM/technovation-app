class Team < ActiveRecord::Base
  has_many :season_registrations, as: :registerable
  has_many :seasons, through: :season_registrations

  belongs_to :division

  has_many :memberships, as: :joinable, dependent: :destroy
  has_many :members, through: :memberships, source_type: "Account"

  has_many :submissions, dependent: :destroy

  has_many :team_member_invites

  validates :name, uniqueness: true, presence: true
  validates :description, presence: true
  validates :division, presence: true

  def pending_invitee_emails
    team_member_invites.pending.flat_map(&:invitee_email)
  end

  def add_member(member)
    if !!member and not members.include?(member)
      members << member
      save
    end
  end
end
