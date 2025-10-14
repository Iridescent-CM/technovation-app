require "./app/models/submissions/required_fields"

class TeamSubmission < ActiveRecord::Base
  MAX_SCREENSHOTS_ALLOWED = 6
  PARTICIPATION_MINIMUM_PERCENT = 50

  DEFAULT_APP_NAME = "(no name yet)"
  MOBILE_APP_SUBMISSION_TYPE = "Mobile App"
  AI_PROJECT_SUBMISSION_TYPE = "AI Project"

  SUBMISSION_TYPES_ENUM = {
    MOBILE_APP_SUBMISSION_TYPE => 0,
    AI_PROJECT_SUBMISSION_TYPE => 1
  }

  SUBMISSION_TYPES = SUBMISSION_TYPES_ENUM.keys

  ACTIVE_DEVELOPMENT_PLATFORMS_ENUM = {
    "App Inventor" => 0,
    "Thunkable" => 6,
    "Other" => 5,
    "Scratch" => 8,
    "Code.org App Lab" => 9
  }

  INACTIVE_DEVELOPMENT_PLATFORMS_ENUM = {
    "Swift or XCode" => 1,
    "Java or Android Studio" => 2,
    "C++" => 3,
    "PhoneGap/Apache Cordova" => 4,
    "Thunkable Classic" => 7
  }

  ALL_DEVELOPMENT_PLATFORMS_ENUM = ACTIVE_DEVELOPMENT_PLATFORMS_ENUM
    .merge(INACTIVE_DEVELOPMENT_PLATFORMS_ENUM)

  DEVELOPMENT_PLATFORMS = ACTIVE_DEVELOPMENT_PLATFORMS_ENUM.keys

  include Seasoned

  include Regioned
  regioned_source Team

  include PublicActivity::Common

  acts_as_paranoid after_restore_commit: true

  extend FriendlyId
  friendly_id :project_name_by_team_name,
    use: :scoped,
    scope: :deleted_at

  before_validation :reset_development_platform_fields_for_ai_projects
  before_validation :reset_development_platform_fields_for_app_inventor
  before_validation :reset_development_platform_fields_for_thunkable
  before_validation :reset_development_platform_fields_for_other_platforms
  before_validation :reset_development_platform_fields_for_scratch
  before_validation :reset_development_platform_fields_for_code_org_app_lab

  before_validation -> {
    return if thunkable_project_url.blank?

    self.thunkable_project_url = standardize_url(thunkable_project_url)
    self.development_platform_other_url = standardize_url(development_platform_other_url)
    self.demo_video_link = standardize_url(demo_video_link)
    self.pitch_video_link = standardize_url(pitch_video_link)
  }

  before_save -> {
    self.ai_description = "" if ai.blank?
    self.climate_change_description = "" if climate_change.blank?
    self.solves_education_description = "" if solves_education.blank?
  }

  after_commit :update_student_info_in_crm
  after_commit -> { RegisterToCurrentSeasonJob.perform_now(self) },
    on: :create

  after_commit -> {
    columns = {}

    if Submissions::RequiredFields.new(self).any?(&:blank?) && published?
      Rails.logger.warn("Published submission id=#{id} is missing required fields.")
    end

    if development_platform_requires_project_url?
      columns[:source_code_external_url] = development_platform_project_url
    end

    columns[:percent_complete] = calculate_percent_complete

    update_columns(columns)

    unless published?
      submission_scores.current_round.destroy_all
    end
  }, on: :update

  enum submission_type: SUBMISSION_TYPES_ENUM
  enum development_platform: ALL_DEVELOPMENT_PLATFORMS_ENUM

  def developed_on?(platform_name)
    development_platform == platform_name
  end

  enum contest_rank: %w[
    quarterfinalist
    semifinalist
    regional_honoree
    special_prize_winner
    finalist
    grand_prize_winner
  ]

  attr_accessor :step

  mount_uploader :source_code, FileProcessor
  mount_uploader :business_plan, FileProcessor
  mount_uploader :pitch_presentation, FileProcessor
  mount_uploader :bibliography, BibliographyUploader

  Division.names.keys.each do |division_name|
    scope division_name, -> {
      joins(team: :division)
        .where("divisions.name = ?", Division.names[division_name])
    }
  end

  scope :complete, -> { where("published_at IS NOT NULL") }
  scope :incomplete, -> { where("published_at IS NULL") }

  scope :removed_from_judging_pool, -> { where(removed_from_judging_pool: true, returned_to_judging_pool_by_account_id: nil) }
  scope :not_removed_from_judging_pool, -> { where(removed_from_judging_pool: false) }

  scope :current_round, -> {
    contest_rank = case SeasonToggles.judging_round
    when "qf"
      "quarterfinalist"
    when "sf"
      "semifinalist"
    else
      none
    end

    where(contest_rank: contest_rank)
  }

  scope :live, -> { complete.joins(team: :current_official_events) }

  scope :virtual, -> {
    complete
      .left_outer_joins(team: :current_official_events)
      .where("regional_pitch_events.id IS NULL")
  }

  scope :by_chapterable, ->(chapterable_type, chapterable_id) do
    joins(team: {students: {account: :chapterable_assignments}})
      .where(chapterable_assignments: {
        chapterable_type: chapterable_type.capitalize,
        chapterable_id: chapterable_id
      })
  end

  scope :with_pitch_presentations, -> { where.not(pitch_presentation: nil) }

  belongs_to :returned_to_judging_pool_by, class_name: "Account", foreign_key: "returned_to_judging_pool_by_account_id", required: false
  belongs_to :team, touch: true
  has_many :screenshots, -> { order(:sort_position) },
    dependent: :destroy,
    after_add: proc { |ts, _| ts.touch },
    after_remove: proc { |ts, _| ts.touch }
  accepts_nested_attributes_for :screenshots, allow_destroy: true

  has_many :submission_scores,
    -> { current },
    dependent: :destroy

  has_many :scores,
    -> { current },
    class_name: "SubmissionScore"

  has_many :scores_including_deleted,
    -> { with_deleted },
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

  has_many :team_submission_gadget_types,
    dependent: :destroy

  has_many :gadget_types,
    through: :team_submission_gadget_types

  validate -> {
    unless integrity_affirmed?
      errors.add(:integrity_affirmed, :accepted)
    end
  }

  validate :team_has_students, on: :create

  validates :app_inventor_app_name,
    presence: true,
    if: ->(s) { s.development_platform == "App Inventor" }

  validates :thunkable_project_url,
    absence: {
      message: "Cannot add a Thunkable project URL when App Inventor selected as the development platform."
    },
    if: ->(s) { s.development_platform == "App Inventor" }

  validates :thunkable_project_url,
    presence: true,
    if: ->(s) { s.development_platform == "Thunkable" }

  validates :code_org_app_lab_project_url,
    presence: true,
    if: ->(s) { s.development_platform == "Code.org App Lab" }

  validates :app_inventor_app_name,
    absence: {
      message: "Cannot add an App Inventor app name when Thunkable selected as the development platform."
    },
    if: ->(s) { s.development_platform == "Thunkable" }

  validates :app_inventor_app_name,
    format: {
      with: /\A\w+\z/,
      message: "can only have letters, numbers, and underscores (\"_\")"
    },
    allow_blank: true

  validates :thunkable_project_url, thunkable_share_url: true, allow_blank: true
  validates :scratch_project_url, scratch_share_url: true, allow_blank: true
  validates :code_org_app_lab_project_url, code_org_app_lab_share_url: true, allow_blank: true
  validates :development_platform_other_url, url: true, allow_blank: true

  validates :ai_description, presence: true, max_word_count: true,
    if: ->(team_submission) { team_submission.ai? }

  validates :climate_change_description, presence: true, max_word_count: true,
    if: ->(team_submission) { team_submission.climate_change? }

  validates :game_description, presence: true, max_word_count: true,
    if: ->(team_submission) { team_submission.game? }

  validates :solves_hunger_or_food_waste_description, presence: true, max_word_count: true,
    if: ->(team_submission) { team_submission.solves_hunger_or_food_waste? }

  validates :uses_open_ai_description, presence: true, max_word_count: true,
    if: ->(team_submission) { team_submission.uses_open_ai? }

  validates :solves_education_description, presence: true, max_word_count: true,
    if: ->(team_submission) { team_submission.solves_education? }

  validates :gadget_type_ids, presence: {message: "At least one gadget type must be selected"},
    if: ->(team_submission) { team_submission.uses_gadgets? }

  validates :learning_journey, presence: true,
    max_word_count: {max_word_count: 200},
    if: ->(team_submission) { team_submission.learning_journey.present? && team_submission.beginner_division? }

  validates :learning_journey, presence: true, max_word_count: true,
    if: ->(team_submission) {
          team_submission.information_legitimacy_description.present? &&
            (team_submission.junior_division? || team_submission.senior_division?)
        }

  validates :information_legitimacy_description, presence: true, max_word_count: true,
    if: ->(team_submission) {
          team_submission.information_legitimacy_description.present? &&
            (team_submission.junior_division? || team_submission.senior_division?)
        }

  validates :pitch_video_link,
    format: {
      with: /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}(.[a-zA-Z]{2,63})?/
    },
    allow_blank: true

  validates :demo_video_link,
    format: {
      with: /[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}(.[a-zA-Z]{2,63})?/
    },
    allow_blank: true

  validate :demo_and_pitch_video_links_are_different, on: :update,
    if: ->(s) { s.demo_video_link.present? || s.pitch_video_link.present? }

  def demo_and_pitch_video_links_are_different
    if demo_video_link == pitch_video_link
      errors.add(
        :base,
        "Your #{I18n.t("submissions.demo_video").truncate_words(1, omission: "").capitalize}
          and pitch videos are the same link. Please update one of the links."
      )
    end
  end

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

  def self.from_param(*args) # standard:disable all
    friendly.find(*args) # standard:disable all
  end

  %i[
    app_name
    app_description
    demo_video_link
    pitch_video_link
    development_platform
    source_code_url
    business_plan_url
    bibliography_url
    pitch_presentation_url
    ethics_description
  ].each do |piece|
    define_method(:"#{piece}_complete?") do
      !public_send(piece).blank?
    end
  end

  alias_attribute :celebration_average_score, :average_unofficial_score

  def random_id
    SecureRandom.hex(4)
  end

  def qualifies_for_participation?
    percent_complete < 100 &&
      percent_complete >= PARTICIPATION_MINIMUM_PERCENT
  end

  def total_possible_score
    SubmissionScore.total_possible_score_for(division: team_division_name)
  end

  def only_needs_to_submit?
    !published? &&
      team.qualified? &&
      Submissions::RequiredFields.new(self).all?(&:complete?)
  end

  def missing_pieces
    missing_pieces = Submissions::RequiredFields.new(self)
      .find_all(&:blank?)
      .map(&:method_name)
      .map(&:to_s)
      .map { |piece| (piece == "screenshots") ? "images" : piece }

    missing_pieces << "submitting" if incomplete?

    missing_pieces
  end

  def app_details
    !ai.nil? ||
      !climate_change.nil? ||
      !game.nil? ||
      !uses_open_ai.nil? ||
      !solves_education.nil? ||
      !uses_gadgets.nil?
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
    if team.qualified? && Submissions::RequiredFields.new(self).all?(&:complete?)
      yield
    end
  end

  def while_unqualified(&block)
    unless team.qualified? && Submissions::RequiredFields.new(self).all?(&:complete?)
      yield
    end
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
    scores = submission_scores.current.complete.semifinals.reload
    if scores.any?
      range = scores.max_by(&:total).total - scores.min_by(&:total).total
      update!(semifinals_score_range: range)
    end
  end

  def status
    if complete?
      "complete"
    else
      "incomplete"
    end
  end

  def app_name
    if (self[:app_name] || "").strip.blank?
      TeamSubmission::DEFAULT_APP_NAME
    else
      self[:app_name].strip
    end
  end
  alias_method :name, :app_name

  def published?
    !!published_at
  end

  def publish!
    update(published_at: Time.current)

    team.members.each do |member|
      TeamMailer.submission_published(team, member, self).deliver_later
    end
  end

  def unpublish!
    update(published_at: nil)
  end

  def awaiting_publish(scope = :student, &block)
    if scope.to_s != "public" and !published?
      yield
    end
  end

  def already_published(scope = :student, &block)
    if scope.to_s != "public" and published?
      yield
    end
  end

  def incomplete?
    !complete?
  end

  def complete?
    Submissions::RequiredFields.new(self).all?(&:complete?) && !!published_at
  end
  alias_method :is_complete, :complete?

  def published!
    update(published_at: Time.current)
  end

  def calculate_percent_complete
    Rails.cache.delete("#{cache_key}/percent_complete")
    Rails.cache.fetch("#{cache_key}/percent_complete") do
      required_fields = Submissions::RequiredFields.new(self)

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

  def beginner_division?
    team_division_name == "beginner"
  end

  def junior_division?
    team_division_name == "junior"
  end

  def senior_division?
    team_division_name == "senior"
  end

  def development_platform_text
    if development_platform == "Other"
      "#{development_platform} - #{development_platform_other}"
    else
      development_platform
    end
  end

  def development_platform_requires_project_url?
    developed_on?("Thunkable") ||
      developed_on?("Scratch") ||
      developed_on?("Code.org App Lab")
  end

  def development_platform_project_url
    if developed_on?("Thunkable")
      thunkable_project_url
    elsif developed_on?("Scratch")
      scratch_project_url
    elsif developed_on?("Code.org App Lab")
      code_org_app_lab_project_url
    end
  end

  def self.development_platform_options(team_submission)
    ACTIVE_DEVELOPMENT_PLATFORMS_ENUM.keys
      .reject { |platform| platform == "Scratch" && !team_submission.beginner_division? }
  end

  def app_inventor?
    send("App Inventor?")
  end
  alias_method :app_inventor_2?, :app_inventor?

  def thunkable?
    send(:Thunkable?)
  end

  def scratch?
    send(:Scratch?)
  end

  def code_org_app_lab?
    send("Code.org App Lab?")
  end

  def other_devlopment_platform?
    send(:Other?)
  end

  def app_inventor_fields_complete?
    developed_on?("App Inventor") &&
      app_inventor_app_name.present? &&
      errors.attribute_names.exclude?(:app_inventor_app_name)
  end

  def thunkable_fields_complete?
    developed_on?("Thunkable") &&
      thunkable_project_url.present? &&
      errors.attribute_names.exclude?(:thunkable_project_url)
  end

  def scratch_fields_complete?
    developed_on?("Scratch") &&
      (scratch_project_url.blank? ||
        scratch_project_url.present? && errors.attribute_names.exclude?(:scratch_project_url))
  end

  def code_org_app_lab_fields_complete?
    developed_on?("Code.org App Lab") &&
      code_org_app_lab_project_url.present? &&
      errors.attribute_names.exclude?(:code_org_app_lab_project_url)
  end

  def other_fields_complete?
    developed_on?("Other")
  end

  def thunkable_source_code_fields_complete?
    thunkable_fields_complete? &&
      source_code_external_url_fields_complete?
  end

  def scratch_source_code_fields_complete?
    scratch_fields_complete? &&
      (source_code_external_url_fields_complete? || source_code.present?)
  end

  def code_org_app_lab_source_code_fields_complete?
    code_org_app_lab_fields_complete? &&
      source_code_external_url_fields_complete?
  end

  def source_code_external_url_fields_complete?
    source_code_external_url.present? &&
      errors.attribute_names.exclude?(:source_code_external_url)
  end

  def learning_journey_complete?
    if junior_division? || senior_division?
      learning_journey.present? &&
        information_legitimacy_description.present? &&
        bibliography_url.present?
    else
      learning_journey.present?
    end
  end

  def additional_questions?
    seasons.last >= 2021
  end

  %i[
    source_code
    business_plan
    pitch_presentation
    bibliography
  ].each do |piece|
    define_method(:"#{piece}_filename") do
      url = send(:"#{piece}_url")
      File.basename(url)
    end
  end

  def embed_code(video_type, video = nil)
    video_url = VideoUrl.new(video || video_link_for(video_type))

    if video_url.valid?
      height = 415
      src = "#{video_url.root}#{video_url.video_id}"
    else
      height = "100%"
      src = "/video-link-broken.html"
    end

    %(<iframe
        src="#{src}"
        width="100%"
        height="#{height}"
        frameborder="0"
        allowfullscreen>
      </iframe>).strip_heredoc
  end

  def video_id(video_type)
    VideoUrl.new(video_link_for(video_type)).video_id
  end

  def video_url_root(video_type)
    VideoUrl.new(video_link_for(video_type)).root
  end

  def scope_name
    "submission"
  end

  private

  def team_has_students
    if !team.has_students?
      errors.add(:base, "This team needs at least one student to create a submission")
    end
  end

  def standardize_url(url)
    return if url.blank?

    if !url.match(/^https:\/\//)
      url = url.sub("http", "https")
    end

    if !url.match(/^https:\/\//)
      url = "https://" + url
    end

    url
  end

  def project_name_by_team_name
    "#{app_name} by #{team_name}"
  end

  def should_generate_new_friendly_id?
    app_name_changed? || team.name_changed? || super
  end

  def video_link_for(video_type)
    case video_type
    when "demo_video_link", "demo", :demo
      demo_video_link
    when "pitch_video_link", "pitch", :pitch
      pitch_video_link
    end
  end

  def reset_development_platform_fields_for_ai_projects
    if submission_type == AI_PROJECT_SUBMISSION_TYPE
      self.development_platform = nil
      self.development_platform_other = nil
      self.app_inventor_app_name = nil
    end
  end

  def reset_development_platform_fields_for_app_inventor
    if development_platform == "App Inventor"
      self.development_platform_other = nil
      self.thunkable_account_email = nil
      self.thunkable_project_url = nil
      self.scratch_project_url = nil
      self.code_org_app_lab_project_url = nil
    end
  end

  def reset_development_platform_fields_for_thunkable
    if development_platform == "Thunkable"
      remove_source_code! if source_code.present?
      self.development_platform_other = nil
      self.scratch_project_url = nil
      self.app_inventor_app_name = nil
      self.code_org_app_lab_project_url = nil
    end
  end

  def reset_development_platform_fields_for_other_platforms
    if development_platform == "Other"
      self.thunkable_project_url = nil
      self.app_inventor_app_name = nil
      self.scratch_project_url = nil
      self.code_org_app_lab_project_url = nil
    end
  end

  def reset_development_platform_fields_for_scratch
    if development_platform == "Scratch"
      self.thunkable_project_url = nil
      self.app_inventor_app_name = nil
      self.development_platform_other = nil
      self.code_org_app_lab_project_url = nil
    end
  end

  def reset_development_platform_fields_for_code_org_app_lab
    if development_platform == "Code.org App Lab"
      self.thunkable_project_url = nil
      self.app_inventor_app_name = nil
      self.development_platform_other = nil
      self.scratch_project_url = nil
    end
  end

  def update_student_info_in_crm
    if any_crm_fileds_changed? && team.students.present?
      team.students.each do |student|
        CRM::UpsertProgramInfoJob.perform_later(
          account_id: student.account.id,
          profile_type: "student",
          season: seasons.last || Season.current.year
        )
      end
    end
  end

  def any_crm_fileds_changed?
    [
      :app_name,
      :published_at,
      :pitch_video_link
    ].any? { |attr| saved_change_to_attribute?(attr) }
  end
end
