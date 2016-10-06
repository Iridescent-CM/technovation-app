class TeamSubmission < ActiveRecord::Base
  after_commit -> { SeasonRegistration.register(self) }, on: :create

  scope :current, -> { joins(season_registrations: :season).where("seasons.year = ?", Season.current.year) }

  belongs_to :team

  has_many :season_registrations, dependent: :destroy, as: :registerable
  has_many :seasons, through: :season_registrations

  def after_registration
  end
end
