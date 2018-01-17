class TeamSubmission < ActiveRecord::Base
  MAX_SCREENSHOTS_ALLOWED = 6

  include Seasoned

  include PublicActivity::Common

  acts_as_paranoid

  extend FriendlyId
  friendly_id :team_name_and_app_name, use: :slugged

  after_commit -> { RegisterToCurrentSeasonJob.perform_now(self) },
    on: :create

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

  scope :in_region, ->(ambassador) {
    if ambassador.country == "US"
      joins(:team)
        .where(
          "teams.state_province = ? AND teams.country = 'US'",
          ambassador.state_province
        )
    else
      joins(:team).where("teams.country = ?", ambassador.country)
    end
  }

  Division.names.keys.each do |division_name|
    scope division_name, -> {
      joins(team: :division)
        .where("divisions.name = ?", Division.names[division_name])
    }
  end

  belongs_to :team, touch: true
  has_many :screenshots, -> { order(:sort_position) },
    dependent: :destroy,
    after_add: Proc.new { |ts, _| ts.touch },
    after_remove: Proc.new { |ts, _| ts.touch }
  accepts_nested_attributes_for :screenshots

  has_one :business_plan, dependent: :destroy
  accepts_nested_attributes_for :business_plan

  has_one :pitch_presentation, dependent: :destroy
  accepts_nested_attributes_for :pitch_presentation

  has_one :technical_checklist, dependent: :destroy
  accepts_nested_attributes_for :technical_checklist

  has_one :code_checklist,
    class_name: "TechnicalChecklist",
    dependent: :destroy
  accepts_nested_attributes_for :code_checklist

  has_many :submission_scores, dependent: :destroy

  validate -> {
    unless integrity_affirmed?
      errors.add(:integrity_affirmed, :accepted)
    end
  }

  validates :app_inventor_app_name,
            :app_inventor_gmail,
    presence: true,
    if: ->(s) { s.development_platform == "App Inventor 2" }

  validates :app_inventor_gmail, gmail: true, allow_blank: true

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
      nil
    else
      self[:app_name].strip
    end
  end

  def name
    app_name || "(unnamed submission)"
  end

  def publish!
    update(published_at: Time.current)

    team.members.each do |member|
      TeamMailer.submission_published(team, member, self).deliver_later
    end
  end

  def awaiting_publish(&block)
    if !!!published_at || updated_at.to_date > published_at.to_date
      yield
    end
  end

  def already_published(&block)
    if !!published_at && updated_at.to_date == published_at.to_date
      yield
    end
  end

  def incomplete?
    not complete?
  end

  def complete?
    Rails.cache.fetch("#{cache_key}/complete?") do
      (not app_name.blank? and
        not app_description.blank? and
          not pitch_video_link.blank? and
            not demo_video_link.blank? and
              not source_code_url.blank? and
                business_plan_complete_or_not_required?)
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

  def business_plan_url
    if !!business_plan
      business_plan.uploaded_file_url
    end
  end

  def pitch_presentation_url
    if !!pitch_presentation
      pitch_presentation.uploaded_file_url
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

  def embed_code(method)
    if send(method) and send(method).match(/youtu/)
      id = send(method)[/v=([\w\-]+[^&])&?.*$/, 1]

      %{<iframe
          width="100%"
          height="315"
          src="https://www.youtube.com/embed/#{id}?rel=0&cc_load_policy=1"
          frameborder="0"
          allowfullscreen>
        </iframe>}.strip_heredoc
    elsif send(method) and send(method).match(/vimeo/)
      id = send(method)[/\/(\d+)$/, 1]

      %{<iframe
          src="https://player.vimeo.com/video/#{id}"
          width="100%"
          height="360"
          frameborder="0"
          webkitallowfullscreen
          mozallowfullscreen
          allowfullscreen>
        </iframe>}.strip_heredoc
    else
      ""
    end
  end

  def clear_judge_opened_details!
    update_attributes({
      judge_opened_at: nil,
      judge_opened_id: nil
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
  def business_plan_complete_or_not_required?
    (junior_division? or team_division_name == Division.none_assigned_yet.name) or
      (senior_division? and not business_plan_url.blank?)
  end

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
