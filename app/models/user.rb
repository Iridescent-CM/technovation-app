class User < ActiveRecord::Base
  include FlagShihTzu
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  after_create :add_to_campaign_list
  after_create :send_judge_signup_email, if: :judge?
  after_create :send_mentor_signup_email, if: :mentor?
  after_create :email_parents_callback, if: :student?
  after_update :send_judging_email_when_account_is_promoted

  before_destroy :remove_from_campaign_list
  before_save :check_judging_conflicts

  # virtual attributes for social security check
  attr_accessor :middle_name, :ssn, :phone,
    :fcra_ok, :drbi_ok,
    :mn_copy, :ca_copy,
    :signature

  attr_accessor :skip_parent_email

  enum role: [:student, :mentor, :coach, :judge]
  enum referral_category: [
    :friend,
    :colleague,
    :article,
    :internet,
    :social_media,
    :print,
    :web_search,
    :teacher,
    :parent_family,
    :other,
  ]

  validates :first_name, :last_name, presence: true
  validates :home_city, :home_country, presence: true
  validates :school, :birthday, presence: true

  validates :parent_email, presence: true, if: :student?

  has_many :team_requests
  has_many :teams, -> {where 'team_requests.approved = ?', true}, through: :team_requests

  VALID_AGE_RANGE = 8..19

  EXPERTISES = [
    {sym: :science, abbr: 'Sci'},
    {sym: :engineering, abbr: 'Eng'},
    {sym: :project_management, abbr: 'PM'},
    {sym: :finance, abbr: 'Fin'},
    {sym: :marketing, abbr: 'Mktg'},
    {sym: :design, abbr: 'Dsn'},
  ]

  has_flags 1 => EXPERTISES[0][:sym],
            2 => EXPERTISES[1][:sym],
            3 => EXPERTISES[2][:sym],
            4 => EXPERTISES[3][:sym],
            5 => EXPERTISES[4][:sym],
            6 => EXPERTISES[5][:sym],
            :column => 'expertise'

  scope :has_expertise, -> { where.not expertise: 0 }
  scope :is_registered, -> { where 'is_registered = true' }
  scope :can_mentor, -> { mentor.has_expertise.is_registered }

  #### fields used for judge user type only
  belongs_to :event
  has_many :rubrics
  belongs_to :conflict_region, class_name: "Region"
  belongs_to :judging_region, class_name: "Region"
  #### end

  geocoded_by :full_address
  after_validation :geocode, if: ->(obj){ obj.home_city.present? and obj.home_city_changed? }

  class << self
    def build_survey_url(collector_path, user_id)
      site = Rails.application.config.env[:surveymonkey][:site]
      is_ssl = site[:ssl]
      klass = (is_ssl ? URI::HTTPS : URI::HTTP)
      klass.build({
        :host => site[:host],
        :path => '/' + [site[:path_base], collector_path].join('/'),
        :query => {:c => user_id}.to_query
      }).to_s
    end

    def api_is_survey_done?(survey_id, collector_path, id)
      data = SurveyMonkey.request('surveys','get_respondent_list') { {:survey_id => survey_id, :fields => [:custom_id]} }
      respondents = data['data']['respondents']
      !!(respondents.reject{|r| r['custom_id'].blank? }.find{|respondent| respondent['custom_id'].to_s == id.to_s })
    end
  end

  def check_judging_conflicts
    if !event_id.nil? and !Event.find(event_id).region.nil? and !conflict_region.nil?
      if conflict_region.id == Event.all.find(event_id).region.id
        raise 'Sorry, you cannot judge an event in a division that you have mentored or coached. Sign up for Virtual Judging instead.'
      end
    end
  end

  def full_address
    [ home_city,
      home_state,
      home_country ].compact.join(', ')
  end

  def collector_path
    Rails.application.config.env[:surveys][:required][self.role][:url_id]
  end

  def survey_id
    Rails.application.config.env[:surveys][:required][self.role][:id]
  end

  def url_for_survey
    self.class.build_survey_url(self.collector_path, self.id)
  end

  def db_or_api_is_survey_done?
    !!is_survey_done? || api_is_survey_done?
  end

  def api_is_survey_done?
    boolean = self.class.api_is_survey_done?(self.survey_id, self.collector_path, self.id)
    if boolean
      self.is_survey_done = true
      self.save!
    end
    boolean
  end

  def certificate_file
    if !on_submitted_team?
      nil
    elsif student?
      'student_template.pdf'
    elsif coach?
      'coach_template.pdf'
    elsif mentor?
      'mentor_template.pdf'
    else
      nil
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  def active_for_authentication?
    super && user_is_enabled?
  end

  def user_is_enabled?
    !disabled?
  end

  def inactive_message
    user_is_enabled? ? super : :admin_disabled
  end

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "64x64>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def current_team
    teams.current.first
  end

  def on_submitted_team?
    teams.current.any?(&:submission_eligible?)
  end

  def has_team_for_season?
    teams.current.any?
  end

  def consented?
    not consent_signed_at.nil?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def slug_candidates
    [
      :name,
      [:name, :id],
    ]
  end

  def age_before_cutoff
    now = Setting.cutoff
    dob = birthday
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  # Remove this method if you remove the manual_region_selection feature_flag bellow
  def division
    age = age_before_cutoff()
    if age <= 14
      :ms
    elsif age <= 19
      :hs
    else
      :x
    end
  end

  def ineligible?
    return false # Disabled for 2016 season
    student? && !VALID_AGE_RANGE.include?(age_before_cutoff)
  end

  def email_parents_callback
    return if skip_parent_email
    SignatureMailer.signature_email(self).deliver
  end

  def can_judge?
    judge? || judging?
  end

  def quarterfinals_judge?
    can_judge?
  end

  def virtual_judge?
    judge? && event && event.is_virtual?
  end

  def get_campaign_list
    if student?
      Rails.application.config.env[:createsend][:student_list_id]
    elsif mentor?
      Rails.application.config.env[:createsend][:mentor_list_id]
    else
      Rails.application.config.env[:createsend][:teacher_list_id]
    end
  end

  def get_campaign_auth
    {
      :api_key => Rails.application.config.env[:createsend][:api_key]
    }
  end

  def add_to_campaign_list
    api_data = get_campaign_auth
    if !api_data[:api_key]
      return
    end

    CreateSend::Subscriber.add api_data, get_campaign_list, email, name, [], true
    rescue CreateSend::BadRequest, CreateSend::Unauthorized => error
      puts "Failed to add user #{email} to campaign monitor. Error code: #{error.data.Code}, Message: #{error.data.Message}"
  end

  def remove_from_campaign_list
    api_data = get_campaign_auth
    if !api_data[:api_key]
      return
    end

    subscriber = CreateSend::Subscriber.new api_data, get_campaign_list, email
    subscriber.unsubscribe
    rescue CreateSend::BadRequest, CreateSend::Unauthorized => error
      puts "Failed to add user #{email} to campaign monitor. Error code: #{error.data.Code}, Message: #{error.data.Message}"
  end

  def conflict_regions
    regions = teams.select('DISTINCT region_id').collect(&:region_id)

    if conflict_region && !regions.include?(conflict_region.id)
      regions << conflict_region.id
    end

    Region.where(id: regions)
  end

  def conflict_region_ids
    conflict_regions.collect(&:id)
  end

  def send_judging_email_when_account_is_promoted
    SignupMailer.judge_signup_email(self).deliver if judging_changed? && judging
  end

  def send_judge_signup_email
    SignupMailer.judge_signup_email(self).deliver
  end

  def send_mentor_signup_email
    SignupMailer.mentor_signup_email(self).deliver
  end

  def quarterfinal_judge?
    can_judge?
  end

  def semifinal_judge?
    semifinals_judge?
  end
end
