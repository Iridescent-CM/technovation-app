class Rubric < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  validates_presence_of :competition, :identify_problem, :address_problem, :functional, :external_resources, :match_features, :interface, :description, :market, :competition, :revenue, :branding, :pitch

  before_save :calculate_score
  before_save :calculate_stage

  enum stage: [
    :quarterfinal,
    :semifinal,
    :final,
  ]

  scope :by_year, ->(year) {
    where("extract(year from created_at) = ?", year)
  }

  scope :quarterfinal, ->(year = Setting.year) {
    by_year(year).where(stage: Rubric.stages[:quarterfinal])
  }

  scope :semifinal, ->(year = Setting.year) {
    by_year(year).where(stage: Rubric.stages[:semifinal])
  }

  def calculate_score
    CalculateScore.call(self)
  end

  def calculate_stage
    self.stage = Setting.nextJudgingRound.first
  end
end
