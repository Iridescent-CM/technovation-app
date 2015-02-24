class Team < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name_and_year, use: :slugged

  validates :name, presence: true, uniqueness: {
    scope: :year,
    case_sensitive: false,
  }
  validates_presence_of :region, :year

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "64x64>" }, :default_url => "/images/:style/missing.png"
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "64x64>" }, :default_url => "/images/:style/missing.png"
  has_attached_file :plan 

  has_attached_file :screenshot1, :styles => { :medium => "300x300>", :thumb => "64x64>" }, :default_url => "/images/:style/missing.png"
  has_attached_file :screenshot2, :styles => { :medium => "300x300>", :thumb => "64x64>" }, :default_url => "/images/:style/missing.png"
  has_attached_file :screenshot3, :styles => { :medium => "300x300>", :thumb => "64x64>" }, :default_url => "/images/:style/missing.png"
  has_attached_file :screenshot4, :styles => { :medium => "300x300>", :thumb => "64x64>" }, :default_url => "/images/:style/missing.png"
  has_attached_file :screenshot5, :styles => { :medium => "300x300>", :thumb => "64x64>" }, :default_url => "/images/:style/missing.png"

  # has_attached_file :submission_attachments

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  validates_attachment_content_type :screenshot1, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :screenshot2, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :screenshot3, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :screenshot4, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :screenshot5, :content_type => /\Aimage\/.*\Z/

  validates_attachment :plan, content_type: { content_type: "application/pdf" }
  

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
  has_many :categores

  has_many :members, -> {where 'team_requests.approved = ?', true}, {through: :team_requests, source: :user}
  has_many :pending, -> {where 'team_requests.approved != ?', true}, {through: :team_requests, source: :user}

  has_many :rubrics
  has_one :event

  # has_many :submission_attachments, :dependent => :destroy
  # accepts_nested_attributes_for :submission_attachments, :reject_if => lambda { |t| t['submission_attachments'].nil? }

  scope :old, -> {where 'year < ?', Setting.year}
  scope :current, -> {where year: Setting.year}


  def name_and_year
    "#{name}-#{year}"
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

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

  def check_completeness
    required = [category_id, name, about, avatar, region, code, logo, pitch, demo, plan, description, screenshot1, screenshot2, screenshot3]
    missing = required.select {|a| 
       if a.class.name == 'String' and a.length == 0
         a
       end}
    'You still need ' + missing.to_s+ ' to be complete'
  end

end
