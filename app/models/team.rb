class Team < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {
    scope: :year,
    case_sensitive: false,
  }
  validates_presence_of :region, :year

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "64x64>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  enum division: {
    ms: 0,
    hs: 1,
    x: 2,
  }
  enum region: [
    :us,
    :mexico,
    :europe,
    :africa,
  ]
  has_many :team_requests

  has_many :members, -> {where 'team_requests.approved = ?', true}, {through: :team_requests, source: :user}
  has_many :pending, -> {where 'team_requests.approved != ?', true}, {through: :team_requests, source: :user}

  scope :old, -> {where 'year < ?', Setting.year}

  # division update logic
  def update_division!
    div = :x

    # team division is the age of the oldest student
    div = members.student
      .map(&:division)
      .max_by {|d| Team.divisions[d]}

    # or if there are too many / not-enough students
    student_count = members.student.count
    if student_count < 1 or student_count > 5
      div = :x
    end

    self.division = div
    self.save!
  end

  def ineligible?
    division.to_sym == :x
  end

  def check_empty!
    if members.count == 0
      team_requests.delete_all
      self.destroy
    end
  end

end
