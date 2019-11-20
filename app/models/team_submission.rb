require "./app/models/submissions/required_fields"

class TeamSubmission < ActiveRecord::Base
  MAX_SCREENSHOTS_ALLOWED = 6
  PARTICIPATION_MINIMUM_PERCENT = 50

  include Seasoned

  include Regioned
  regioned_source Team

  include PublicActivity::Common

  acts_as_paranoid

  extend FriendlyId
  friendly_id :team_name_and_app_name,
    use: :scoped,
    scope: :deleted_at

  before_validation -> {
    return if thunkable_project_url.blank?

    if !thunkable_project_url.match(/^https:\/\//)
      self.thunkable_project_url = thunkable_project_url.sub("http", "https")
    end

    if !thunkable_project_url.match(/^https:\/\//)
      self.thunkable_project_url = "https://" + thunkable_project_url
    end
  }

  after_commit -> { RegisterToCurrentSeasonJob.perform_now(self) },
    on: :create

  after_commit -> {
    columns = {}

    if RequiredFields.new(self).any?(&:blank?) && published?
      Rails.logger.warn("Published submission id=#{id} is missing required fields.")
    end

    if source_code_external_url.blank?
      columns[:source_code_external_url] = copy_possible_thunkable_url
    end

    columns[:percent_complete] = calculate_percent_complete

    update_columns(columns)

    if not published?
      submission_scores.current_round.destroy_all
    end
  }, on: :update

  enum development_platform: {
    "App Inventor" => 0,
      # Renamed from 'App Inventor 2' in Sept 2018

    "Thunkable" => 6,
    "Thunkable Classic" => 7,
    "Java or Android Studio" => 2,
    "Swift or XCode" => 1,
    "Other" => 5,

    # LEGACY SUPPORT
    # DO NOT USE THESE ENUMS
    # IN FORM ELEMENTS
    "C++" => 3,
    "PhoneGap/Apache Cordova" => 4,
  }

  def self.development_platform_keys
    development_platforms.reject { |_key, value|
     [3, 4].include?(value)
    }.keys
  end

  def developed_on?(platform_name)
    development_platform == platform_name
  end

  enum contest_rank: %w{
    quarterfinalist
    semifinalist
    finalist
    winner
  }

  attr_accessor :step

  mount_uploader :source_code, FileProcessor
  mount_uploader :business_plan, FileProcessor
  mount_uploader :pitch_presentation, FileProcessor

  Division.names.keys.each do |division_name|
    scope division_name, -> {
      joins(team: :division)
        .where("divisions.name = ?", Division.names[division_name])
    }
  end

  scope :complete, -> { where('published_at IS NOT NULL') }
  scope :incomplete, -> { where('published_at IS NULL') }

  scope :live, -> { complete.joins(team: :current_official_events) }

  scope :virtual, -> {
    complete
    .left_outer_joins(team: :current_official_events)
    .where("regional_pitch_events.id IS NULL")
  }

  belongs_to :team, touch: true
  has_many :screenshots, -> { order(:sort_position) },
    dependent: :destroy,
    after_add: Proc.new { |ts, _| ts.touch },
    after_remove: Proc.new { |ts, _| ts.touch }
  accepts_nested_attributes_for :screenshots

  has_one :technical_checklist, dependent: :destroy
  accepts_nested_attributes_for :technical_checklist

  has_one :code_checklist,
    class_name: "TechnicalChecklist",
    dependent: :destroy
  accepts_nested_attributes_for :code_checklist

  has_many :submission_scores,
    -> { current },
    dependent: :destroy

  has_many :scores,
    -> { current },
    class_name: "SubmissionScore"

  has_many :complete_submission_scores,
    -> { current.complete },
    class_name: "SubmissionScore"

  has_many :quarterfinals_all_submission_scores,
    -> { current.quarterfinals },
    class_name: "SubmissionScore"

  has_many :quarterfinals_complete_submission_scores,
    -> { current.quarterfinals.complete },
    class_name: "SubmissionScore"

  has_many :quarterfinals_incomplete_submission_scores,
    -> { current.quarterfinals.incomplete },
    class_name: "SubmissionScore"

  has_many :semifinals_all_submission_scores,
    -> { current.semifinals },
    class_name: "SubmissionScore"

  has_many :semifinals_complete_submission_scores,
    -> { current.semifinals.complete },
    class_name: "SubmissionScore"

  has_many :semifinals_incomplete_submission_scores,
    -> { current.semifinals.incomplete },
    class_name: "SubmissionScore"

  has_many :virtual_all_submission_scores,
    -> { current.virtual },
    class_name: "SubmissionScore"

  has_many :virtual_incomplete_submission_scores,
    -> { current.virtual.incomplete },
    class_name: "SubmissionScore"

  has_many :virtual_complete_submission_scores,
    -> { current.virtual.complete },
    class_name: "SubmissionScore"

  has_many :live_all_submission_scores,
    -> { current.live },
    class_name: "SubmissionScore"

  has_many :live_incomplete_submission_scores,
    -> { current.live.incomplete },
    class_name: "SubmissionScore"

  has_many :live_complete_submission_scores,
    -> { current.live.complete },
    class_name: "SubmissionScore"

  validate -> {
    unless integrity_affirmed?
      errors.add(:integrity_affirmed, :accepted)
    end
  }

  validates :app_inventor_app_name,
            :app_inventor_gmail,
    presence: true,
    if: ->(s) { s.development_platform == "App Inventor" }

  validates :thunkable_account_email,
            :thunkable_project_url,
    presence: true,
    if: ->(s) { s.development_platform == "Thunkable" }

  validates :app_inventor_app_name,
    format: {
      with: /\A\w+\z/ ,
      message: "can only have letters, numbers, and underscores (\"_\")",
    },
    allow_blank: true

  validates :app_inventor_gmail, email: true, allow_blank: true
  validates :thunkable_account_email, email: true, allow_blank: true

  validates :thunkable_project_url, thunkable_share_url: true, allow_blank: true

  delegate :name,
           :division_name,
           :photo,
           :primary_location,
           :city,
           :state_province,
           :country,
           :country_code,
           :ages,
    to: :team,
    prefix: true

  def self.from_param(*args)
    friendly.find(*args)
  end

  %i{
    app_name
    app_description
    pitch_video_link
    development_platform
    source_code_url
    business_plan_url
    pitch_presentation_url
  }.each do |piece|
    define_method("#{piece}_complete?") do
      not public_send(piece).blank?
    end
  end

  alias_attribute :celebration_average_score, :average_unofficial_score

  def random_id
    SecureRandom.hex(4)
  end

  def lowest_score_dropped?
    lowest_score_dropped_at != nil
  end

  def lowest_score_dropped!
    update_column(:lowest_score_dropped_at, Time.current)
  end

  def qualifies_for_participation?
    percent_complete < 100 &&
      percent_complete >= PARTICIPATION_MINIMUM_PERCENT
  end

  def total_possible_score
    senior_division? ? 100 : 80
  end

  def only_needs_to_submit?
    !published? &&
      team.qualified? &&
        RequiredFields.new(self).all?(&:complete?)
  end

  def team_photo_uploaded?
    team.team_photo_url !~ /placeholders/
  end

  def team_photo_url
    team.team_photo_url
  end

  def max_screenshots_remaining
    MAX_SCREENSHOTS_ALLOWED - screenshots.persisted.count
  end

  def while_screenshots_remaining(&block)
    if max_screenshots_remaining > 0
      yield
    end
  end

  def while_has_screenshots(&block)
    if screenshots.persisted.any?
      yield
    end
  end

  def while_no_screenshots_remaining(&block)
    unless max_screenshots_remaining > 0
      yield
    end
  end

  def while_qualified(&block)
    if team.qualified? && RequiredFields.new(self).all?(&:complete?)
      yield
    end
  end

  def while_unqualified(&block)
    unless team.qualified? && RequiredFields.new(self).all?(&:complete?)
      yield
    end
  end

  def code_checklist_complete?
    technical_checklist_completed?
  end

  def screenshots_complete?
    screenshots.reject(&:new_record?).count >= 2
  end

  def update_score_summaries
    update_quarterfinals_average_score
    update_quarterfinals_score_range
    update_semifinals_average_score
    update_semifinals_score_range
  end

  def quarterfinals_official_scores
    if team.selected_regional_pitch_event.live? &&
         team.selected_regional_pitch_event.official?
      submission_scores.current.live.complete.quarterfinals
    else
      submission_scores.current.virtual.complete.quarterfinals
    end
  end

  def quarterfinals_unofficial_scores
    if team.selected_regional_pitch_event.live? &&
         team.selected_regional_pitch_event.official?
      submission_scores.current.virtual.complete.quarterfinals
    else
      submission_scores.current.live.complete.quarterfinals
    end
  end

  def update_quarterfinals_average_score
    if quarterfinals_official_scores.any?
      avg = (quarterfinals_official_scores.inject(0.0) { |acc, s|
        acc + s.total
      } / quarterfinals_official_scores.count).round(2)

      update_column(:quarterfinals_average_score, avg)
    else
      update_column(:quarterfinals_average_score, 0)
    end

    if quarterfinals_unofficial_scores.any?
      avg = (quarterfinals_unofficial_scores.inject(0.0) { |acc, s|
        acc + s.total
      } / quarterfinals_unofficial_scores.count).round(2)

      update_column(:average_unofficial_score, avg)
    else
      update_column(:average_unofficial_score, 0)
    end
  end

  def update_quarterfinals_score_range
    scores = quarterfinals_official_scores
    if scores.any?
      range = scores.max_by(&:total).total - scores.min_by(&:total).total
      update_column(:quarterfinals_score_range, range)
    end
  end

  def update_semifinals_average_score
    scores = submission_scores.current.complete.semifinals
    if scores.any?
      avg = (scores.inject(0.0) { |acc, s|
        acc + s.total
      } / scores.count).round(2)

      update_column(:semifinals_average_score, avg)
    else
      update_column(:semifinals_average_score, 0)
    end
  end

  def update_semifinals_score_range
    scores = submission_scores.current.complete.semifinals
    if scores.any?
      range = scores.max_by(&:total).total - scores.min_by(&:total).total
      update_column(:semifinals_score_range, range)
    end
  end

  def status
    if complete?
      'complete'
    else
      'incomplete'
    end
  end

  def technical_checklist
    super || ::NullTechnicalChecklist.new
  end

  def code_checklist
    technical_checklist
  end

  def code_checklist_points
    total_technical_checklist
  end

  def app_name
    if (self[:app_name] || "").strip.blank?
      "(no name yet)"
    else
      self[:app_name].strip
    end
  end
  alias :name :app_name

  def published?
    !!published_at
  end

  def publish!
    update(published_at: Time.current)

    team.members.each do |member|
      TeamMailer.submission_published(team, member, self).deliver_later
    end
  end

  def awaiting_publish(scope = :student, &block)
    if scope.to_s != 'public' and not published?
      yield
    end
  end

  def already_published(scope = :student, &block)
    if scope.to_s != 'public' and published?
      yield
    end
  end

  def incomplete?
    not complete?
  end

  def complete?
    RequiredFields.new(self).all?(&:complete?) && !!published_at
  end
  alias :is_complete :complete?

  def published!
    update(published_at: Time.current)
  end

  def calculate_percent_complete
    Rails.cache.fetch("#{cache_key}/percent_complete") do
      required_fields = RequiredFields.new(self)

      total_needed = required_fields.size.to_f + 1
        # + 1 === publishing / submitting is now required

      published = complete? ? 1 : 0

      completed_count = required_fields.count(&:complete?) + published

      (completed_count / total_needed * 100).round
    end
  end

  def country
    team_country_code
  end

  def state_province
    team_state_province
  end

  def division_id
    team.division_id
  end

  def junior_division?
    team_division_name == "junior"
  end

  def senior_division?
    team_division_name == "senior"
  end

  def development_platform_text
    if development_platform == "Other"
      ["Other", "-", development_platform_other].join(' ')
    else
      development_platform
    end
  end

  def app_inventor?
    send("App Inventor?")
  end
  alias :app_inventor_2? :app_inventor?

  def thunkable?
    send("Thunkable?")
  end

  %i{
    source_code
    business_plan
    pitch_presentation
  }.each do |piece|
    define_method("#{piece}_filename") do
      url = send("#{piece}_url")
      File.basename(url)
    end
  end

  def technical_checklist_started?
    technical_checklist.present? and
      technical_checklist.attributes.values.any? { |v| not v.blank? }
  end

  def technical_checklist_completed?
    technical_checklist.present? and technical_checklist.completed?
  end

  def embed_code(video_type, value = nil)
    method = video_type.match(/_video_link$/) ?
      video_type :
      "#{video_type}_video_link"

    value = value || send(method)

    id = determine_video_id(value)
    root = determine_video_url_root(value)

    if id.blank? or root.blank?
      src = "/video-link-broken.html"
    else
      src = "#{root}#{id}?rel=0&cc_load_policy=1"
    end

    %{<iframe
        src="#{src}"
        width="100%"
        height="315"
        frameborder="0"
        allowfullscreen>
      </iframe>}.strip_heredoc
  end

  def video_id(video_type)
    method = video_type.match(/_video_link$/) ?
      video_type :
      "#{video_type}_video_link"

    determine_video_id(send(method))
  end

  def video_url_root(video_type)
    method = video_type.match(/_video_link$/) ?
      video_type :
      "#{video_type}_video_link"

    determine_video_url_root(send(method))
  end

  def total_technical_checklist
    if technical_checklist.present?
      total_technical_coding +
        total_technical_db +
          total_technical_mobile +
            total_technical_process
    else
      0
    end
  end

  def total_technical_coding
    calculate_technical_total(
      technical_checklist.technical_components,
      points_each: 1,
      points_max:  4
    )
  end

  def total_technical_db
    calculate_technical_total(
      technical_checklist.database_components,
      points_each: 1,
      points_max: 1
    )
  end

  def total_technical_mobile
    calculate_technical_total(
      technical_checklist.mobile_components,
      points_each: 2,
      points_max: 2
    )
  end

  def total_technical_process
    if technical_checklist.pics_of_process.all? { |a|
        technical_checklist.send(a).present?
      } and screenshots_complete?
      3
    else
      0
    end
  end

  private
  def team_name_and_app_name
    "#{app_name} by #{team_name}"
  end

  def should_generate_new_friendly_id?
    super || team_name_and_app_name.parameterize != slug
  end

  def calculate_technical_total(components, options)
    components.reduce(0) do |sum, aspect|
      if sum == options[:points_max]
        sum
      elsif technical_checklist.send(aspect) and
          not technical_checklist.send("#{aspect}_explanation").blank?
        sum += options[:points_each]
      else
        sum
      end
    end
  end

  def copy_possible_thunkable_url
    if developed_on?("Thunkable") && !saved_change_to_source_code_external_url
      thunkable_project_url
    end
  end

  def determine_video_id(url)
    case url
    when /youtu/
      url[/(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/, 1] || ""
    when /vimeo/
      url[/\/(\d+)$/, 1] || ""
    when /youku/
      url[/\/v_show\/id_(\w+)(?:==)?(?:\.html.+)?$/, 1] || ""
    else
      url || ""
    end
  end

  def determine_video_url_root(url)
    case url
    when /youtu/
      "https://www.youtube.com/embed/"
    when /vimeo/
      "https://player.vimeo.com/video/"
    when /youku/
      "https://player.youku.com/embed/"
    end
  end
end
