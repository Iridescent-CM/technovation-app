class Team < ActiveRecord::Base
  include FlagShihTzu
  extend FriendlyId

  friendly_id :name_and_year, use: :slugged

  before_save :update_submission_status
  before_save :update_division
  before_save :check_event_region

  validates :name, presence: true, uniqueness: {
    scope: :year,
    case_sensitive: false,
  }
  validates_presence_of :region, :region_id, :year

  delegate :name, to: :region, prefix: true, allow_nil: true
  delegate :name, to: :event, prefix: true, allow_nil: true

  paginates_per 10

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

  validates_attachment_size :avatar, less_than: 100.kilobytes, if: -> { avatar.dirty? }
  validates_attachment_size :screenshot1, less_than: 100.kilobytes, if: -> { screenshot1.dirty? }
  validates_attachment_size :screenshot2, less_than: 100.kilobytes, if: -> { screenshot2.dirty? }
  validates_attachment_size :screenshot3, less_than: 100.kilobytes, if: -> { screenshot3.dirty? }
  validates_attachment_size :screenshot4, less_than: 100.kilobytes, if: -> { screenshot4.dirty? }
  validates_attachment_size :screenshot5, less_than: 100.kilobytes, if: -> { screenshot5.dirty? }
  validates_attachment_size :logo, less_than: 100.kilobytes, if: -> { logo.dirty? }
  validates_attachment_size :plan, less_than: 500.kilobytes, if: -> { plan.dirty? }

  validates_attachment_file_name :plan, :matches => /pdf\Z/

  enum division: {
    ms: 0,
    hs: 1,
    x: 2,
  }

  PLATFORMS = [
    { sym: :android, abbr: 'Android' },
    { sym: :ios, abbr: 'iOS' },
    { sym: :windows, abbr: 'Windows phone' },
  ]

  has_flags 1 => :android,
            2 => :ios,
            3 => :windows,
            :column => 'platform'

  has_many :team_requests
  belongs_to :category

  has_many :members, -> { where('team_requests.approved = ?', true) }, { through: :team_requests, source: :user }
  has_many :pending, -> { where('team_requests.approved != ?', true) }, { through: :team_requests, source: :user }

  has_many :rubrics
  has_many :judges, through: :rubrics, source: :user

  belongs_to :event
  belongs_to :region

  scope :old, -> { where('year < ?', Setting.year) }
  scope :current, -> { where(year: Setting.year) }
  scope :has_category, -> (cat) { where('category_id = ?', cat) }
  scope :has_division, -> (div) { where('division = ?', div) }
  scope :has_region, -> (reg) { where('region_id = ?', reg) }

  scope :is_semi_finalist, -> { current.where(is_semi_finalist: true) }
  scope :is_finalist, -> { current.where(is_finalist: true) }
  scope :is_winner, -> { current.where(is_winner: true) }
  scope :is_submitted, -> { current.where(submitted: true) }
  scope :by_country, -> (country) { current.where(country: country) }

  #http://stackoverflow.com/questions/14762714/how-to-list-top-10-school-with-active-record-rails
  #http://stackoverflow.com/questions/8696005/rails-3-activerecord-order-by-count-on-association

  def self.randomized(seed = nil)
    connection.execute "select setseed(#{seed})"
    order("RANDOM()")
  end

  def scores(round)
    send("#{round}_rubrics")
  end

  def quarterfinal_rubrics
    rubrics.quarterfinal
  end

  def semifinal_rubrics
    rubrics.semifinal
  end

  def final_rubrics
    rubrics.final
  end

  def avg_score
    rubrics.average(:score)
  end

  def avg_quarterfinal_score
    rubrics.where(stage:0).average(:score)
  end

  def avg_semifinal_score
    rubrics.where(stage:1).average(:score)
  end

  def avg_final_score
    rubrics.where(stage:2).average(:score)
  end

  def name_and_year
    "#{name}-#{year}"
  end

  def should_generate_new_friendly_id?
    name_changed?
  end

  def update_division
    self.division = self.region.division
  end

  # division update logic
  def update_team_data!
    update_division

    members_by_country = members(true).group_by(&:home_country)

    if members_by_country.size > 0
      self.country = members_by_country.values.max_by(&:size).first.home_country
    end

    members_by_state = members(true).group_by(&:home_state)

    if members_by_state.size > 0
      self.state = members_by_state.values.max_by(&:size).first.home_state
    end

    self.save!
  end

  def ineligible?
    return false # Disabled for 2016 season
    !(1..5).include?(students.size) || ineligible_students.any?
  end

  def eligible?(judge)
    !ineligible? && submission_eligible? &&
      !judges.include?(judge) && eligible_country?(judge)
  end

  def check_empty!
    if members.count == 0
      team_requests.delete_all
      self.destroy
    end
  end

  def missing_field?(a)
     value = send(a)

     (value == false ||
       value.nil? ||
         (value.class.name == 'String' &&
           value.length == 0)) ||
       (value.class.name == 'Paperclip::Attachment' &&
          send("#{a}_file_name").nil?)
  end

  def check_completeness
     missing_fields.map { |field| I18n.t field, scope: [:team, :errors, :required_fields] }
  end

  def required_fields
    %i{code pitch plan event_id confirm_acceptance_of_rules confirm_region}
  end

  def missing_fields
   required_fields.select { |a| missing_field?(a) }
                  .map { |a|
                    if a == 'category_id'
                      'category'
                    else
                      a
                    end
                  }
  end

  def update_submission_status
    if not submitted
      if missing_fields.empty?
        self.submitted=true
        ## send out the mail
        for user in members
          SubmissionMailer.submission_received_email(user, self).deliver
        end
      end
    else
      if not missing_fields.empty?
        self.submitted=false
      end
    end
    true
  end

  def started?
    missing_fields.length != required_fields.length
  end

  def submission_eligible?
    missing_fields.length <= 0
  end

  def submission_symbol
    if Setting.beforeSubmissionsOpen?
      :submissions_not_yet_open
    elsif !started?
      :not_started
    elsif missing_fields.empty?
      :submitted
    else !missing_fields.empty?
      :in_progress
    end
  end

  def submission_status
    if Setting.beforeSubmissionsOpen?
      return 'Submissions not yet open'
    elsif !started?
      return 'Not Started'
    elsif missing_fields.empty?
      return 'Submitted'
    else !missing_fields.empty?
      return 'In Progress'
    end
  end

  def has_a_virtual_event?
    !!event && event.is_virtual?
  end

  def has_no_virtual_event?
    !has_a_virtual_event?
  end

  def check_event_region
    if persisted? && region_id_changed? && has_no_virtual_event?
      self.event_id = nil
    end

    true
  end

  def is_semifinalist?
    is_semi_finalist?
  end

  def is_quarterfinalist?
    true
  end

  def city
    (student = members.student.first) && student.home_city
  end

  def coach_name
    (coach = members.coach.first) && coach.name
  end

  def coach_email
    (coach = members.coach.first) && coach.email
  end

  def country_name
    ISO3166::Country.new(country).name
  end

  private
  def students
    members(true).select(&:student?)
  end

  def ineligible_students
    students.select(&:ineligible?)
  end

  def eligible_country?(judge)
    if judge.home_country == 'BR'
      country == 'BR'
    else
      country != 'BR'
    end
  end
end
