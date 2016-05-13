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

  scope :has_judge, -> (user) {where('user_id = ?', user.id)}
  scope :has_team, -> (team) {where('team_id = ?', team.id)}
  scope :quarter_finals, -> { where(stage: 0) }

  def calculate_score
    CalculateScore.call(self)
  end

  def calculate_stage
    self.stage = Setting.nextJudgingRound.first
  end
end
