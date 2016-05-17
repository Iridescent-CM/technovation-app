class Rubric < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  validates_presence_of :competition, :identify_problem, :address_problem, :functional, :external_resources, :match_features, :interface, :description, :market, :competition, :revenue, :branding, :pitch

  before_save :calculate_score
  before_save :protect_stage_from_fraud

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

  private
  def calculate_score
    CalculateScore.call(self)
  end

  def protect_stage_from_fraud
    self.stage ||= Setting.judgingRound

    if stage_allowed?
      true
    elsif stage == Setting.judgingRound
      self.stage = nil
    else
      self.stage = Setting.judgingRound
      protect_stage_from_fraud
    end
  end

  def stage_allowed?
    team &&
      team.public_send("is_#{stage}ist?") &&
        user.public_send("#{stage}_judge?")
  end
end
