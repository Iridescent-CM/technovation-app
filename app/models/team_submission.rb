require "./app/models/submissions/required_fields"

class TeamSubmission < ActiveRecord::Base
  MAX_SCREENSHOTS_ALLOWED = 6

  include Seasoned

  include Regioned
  regioned_source Team

  include PublicActivity::Common

  acts_as_paranoid

  extend FriendlyId
  friendly_id :team_name_and_app_name,
    use: :scoped,
    scope: :deleted_at

  after_commit -> { RegisterToCurrentSeasonJob.perform_now(self) },
    on: :create

  after_commit -> {
    update_column(:percent_complete, calculate_percent_complete)
    update_column(:published_at, nil) if RequiredFields.new(self).any?(&:blank?)
  }, on: :update

  enum development_platform: %w{
    App\ Inventor\ 2
    Swift\ or\ XCode
    Java
    C++
    PhoneGap/Apache\ Cordova
    Other
  }

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

  has_many :submission_scores, -> { current }, dependent: :destroy

  validate -> {
    unless integrity_affirmed?
      errors.add(:integrity_affirmed, :accepted)
    end
  }

  validates :app_inventor_app_name,
            :app_inventor_gmail,
    presence: true,
    if: ->(s) { s.development_platform == "App Inventor 2" }

  validates :app_inventor_gmail, email: true, allow_blank: true

  delegate :name,
           :division_name,
           :photo,
           :primary_location,
           :city,
           :state_province,
           :country,
           :ages,
    to: :team,
    prefix: true

  def self.from_param(*args)
    friendly.find(*args)
  end

  %i{
    app_name
    app_description
    demo_video_link
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
    if team.qualified? and complete?
      yield
    end
  end

  def while_unqualified(&block)
    unless team.qualified? and complete?
      yield
    end
  end

  def code_checklist_complete?
    technical_checklist_completed?
  end

  def screenshots_complete?
    screenshots.reject(&:new_record?).count >= 2
  end

  def update_average_scores
    update_quarterfinals_average_score
    update_semifinals_average_score
  end

  def update_quarterfinals_average_score
    if team.selected_regional_pitch_event.live? &&
         team.selected_regional_pitch_event.unofficial?

      official_scores = submission_scores.virtual.complete.quarterfinals
      unofficial_scores = submission_scores.live.complete.quarterfinals

    elsif team.selected_regional_pitch_event.live?

      official_scores = submission_scores.live.complete.quarterfinals
      unofficial_scores = submission_scores.virtual.complete.quarterfinals

    else

      official_scores = submission_scores.virtual.complete.quarterfinals
      unofficial_scores = submission_scores.live.complete.quarterfinals

    end

    if official_scores.any?
      avg = (official_scores.inject(0.0) { |acc, s|
        acc + s.total
      } / official_scores.count).round(2)

      update_column(:quarterfinals_average_score, avg)
    else
      update_column(:quarterfinals_average_score, 0)
    end

    if unofficial_scores.any?
      avg = (unofficial_scores.inject(0.0) { |acc, s|
        acc + s.total
      } / unofficial_scores.count).round(2)

      update_column(:average_unofficial_score, avg)
    else
      update_column(:average_unofficial_score, 0)
    end
  end

  def update_semifinals_average_score
    scores = submission_scores.complete.semifinals
    if scores.any?
      avg = (scores.inject(0.0) { |acc, s|
        acc + s.total
      } / scores.count).round(2)

      update_column(:semifinals_average_score, avg)
    else
      update_column(:semifinals_average_score, 0)
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
    code_checklist.total_points
  end

  def app_name
    if (self[:app_name] || "").strip.blank?
      "(no name yet)"
    else
      self[:app_name].strip
    end
  end
  alias :name :app_name

  def publish!
    update(published_at: Time.current)

    team.members.each do |member|
      TeamMailer.submission_published(team, member, self).deliver_later
    end
  end

  def awaiting_publish(&block)
    if !!!published_at || updated_at.to_i > published_at.to_i
      yield
    end
  end

  def already_published(&block)
    if !!published_at && updated_at.to_i == published_at.to_i
      yield
    end
  end

  def incomplete?
    not complete?
  end

  def complete?
    not published_at.blank?
  end

  def published!
    update(published_at: Time.current)
  end

  def calculate_percent_complete
    Rails.cache.fetch("#{cache_key}/percent_complete") do
      required_fields = RequiredFields.new(self)
      completed_count = required_fields.count(&:complete?)
      (completed_count / required_fields.size.to_f * 100).round
    end
  end

  def country
    team_country
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

  def app_inventor_2?
    send("App Inventor 2?")
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

  def embed_code(video_type)
    method = video_type.match(/_video_link$/) ?
      video_type :
      "#{video_type}_video_link"

    id = video_id(method)
    root = video_url_root(method)
    src = "#{root}#{id}?rel=0&cc_load_policy=1"

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

    case send(method)
    when /youtu/
      send(method)[/(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/, 1] || ""
    when /vimeo/
      send(method)[/\/(\d+)$/, 1] || ""
    when /youku/
      send(method)[/\/v_show\/id_(\w+)(?:==)?(?:\.html.+)?$/, 1] || ""
    else
      send(method) || ""
    end
  end

  def video_url_root(video_type)
    method = video_type.match(/_video_link$/) ?
      video_type :
      "#{video_type}_video_link"

    case send(method)
    when /youtu/
      "https://www.youtube.com/embed/"
    when /vimeo/
      "https://player.vimeo.com/video/"
    when /youku/
      "https://player.youku.com/embed/"
    end
  end

  def clear_judge_opened_details!
    update({
      judge_opened_at: nil,
      judge_opened_id: nil,
    })
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
end
