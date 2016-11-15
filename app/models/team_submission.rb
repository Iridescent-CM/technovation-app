class TeamSubmission < ActiveRecord::Base
  enum stated_goal: %w{
    Poverty
    Environment
    Peace
    Equality
    Education
    Health
  }

  attr_accessor :step

  after_commit -> { SeasonRegistration.register(self) }, on: :create

  mount_uploader :source_code, FileProcessor

  scope :current, -> { joins(season_registrations: :season).where("seasons.year = ?", Season.current.year) }

  belongs_to :team
  has_many :screenshots
  has_one :business_plan

  has_many :season_registrations, dependent: :destroy, as: :registerable
  has_many :seasons, through: :season_registrations

  validates :app_description, length: {
    minimum: 100,
    tokenizer: ->(d) { d.scan(/\S+/) },
    too_short: "must have at least %{count} words",
  }, if: -> { step == "app_description" }
end
