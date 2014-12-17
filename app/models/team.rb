class Team < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {
    scope: :year,
    case_sensitive: false,
  }
  validates_presence_of :division, :region, :year

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "64x64>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  enum division: [:ms, :hs]
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

  def update_division!
    puts 'updating division'
    d = :ms
    members.student.each do |s|
      if s.division == :hs
        d = :hs
      end
    end
    self.division = d
    self.save!
  end

  def ineligible?
    members.student.count > 5
  end

  def check_empty!
    if members.count == 0
      team_requests.delete_all
    end
    self.destroy
  end

end
