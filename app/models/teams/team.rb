class Team < ActiveRecord::Base
  has_many :season_registrations, as: :registerable
  has_many :seasons, through: :season_registrations

  belongs_to :division

  has_many :memberships, as: :joinable, dependent: :destroy
  has_many :members, through: :memberships, source_type: "Account"

  has_many :submissions, dependent: :destroy

  validates :name, uniqueness: true, presence: true
  validates :description, presence: true
  validates :division, presence: true

  def member_names
    members.collect(&:full_name)
  end
end
