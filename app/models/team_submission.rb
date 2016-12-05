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
  mount_uploader :pitch_presentation, FileProcessor

  scope :current, -> { joins(season_registrations: :season).where("seasons.year = ?", Season.current.year) }

  belongs_to :team
  has_many :screenshots, -> { order(:sort_position) }
  has_one :business_plan

  has_one :technical_checklist
  accepts_nested_attributes_for :technical_checklist

  has_many :season_registrations, dependent: :destroy, as: :registerable
  has_many :seasons, through: :season_registrations
end
