class Team < ActiveRecord::Base
  has_many :season_registrations, as: :registerable
  has_many :seasons, through: :season_registrations

  belongs_to :division
  belongs_to :region

  has_many :memberships, as: :joinable
  has_many :members, through: :memberships

  has_many :submissions

  validates :name, uniqueness: true, presence: true
  validates :description, presence: true
  validates :division, presence: true
  validates :region, presence: true
end
