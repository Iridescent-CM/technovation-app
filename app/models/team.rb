class Team < ActiveRecord::Base
  include Seasoned
  include Regioned
  include ActiveGeocoded

  acts_as_paranoid

  include Casting::Client
  delegate_missing_methods

  include PublicActivity::Common

  after_commit :regenerate_team_submission_friendly_id
  after_commit :update_student_info_in_crm

  after_commit -> {
    return false if destroyed?

    if students.any? and students.all?(&:onboarded)
      update_columns(
        has_students: true,
        all_students_onboarded: true
      )
    elsif students.any?
      update_column(:all_students_onboarded, false)
    else
      update_column(:has_students, false)
    end
  }

  scope :has_students, -> { where(has_students: true) }
  scope :no_students, -> { where(has_students: false) }

  scope :all_students_onboarded, -> { where(all_students_onboarded: true) }
  scope :some_students_onboarding, -> {
    where(
      has_students: true,
      all_students_onboarded: false
    )
  }

  scope :by_query, ->(query) {
    where("teams.name ILIKE ?", "#{query}%")
  }

  scope :live_event_eligible, ->(event) {
    not_staff
      .not_attending_live_event
      .joins(:division, :submission)
      .where("divisions.id IN (?)", event.division_ids)
  }

  def self.sort_column
    :name
  end

  def season
    Integer(seasons.last)
  end

  def assign_address_details(geocoded)
    self.city = geocoded.city
    self.state_province = geocoded.state_code
    self.country = geocoded.country_code
  end

  def ambassador_route_key
    model_name.singular_route_key
  end

  def event_scope
    self.class.name
  end

  def id_for_event
    id
  end

  def in_event?(event)
    selected_regional_pitch_event == event
  end
  alias_method :attending_event?, :in_event?

  scope :not_staff, -> {
    where.not("teams.name ilike ?", "%staff test%")
  }

  scope :inactive, -> {
    current.joins(
      "LEFT OUTER JOIN activities
        ON activities.trackable_id = teams.id
        AND activities.trackable_type = 'Team'
        AND activities.created_at > '#{3.weeks.ago}'"
    )
      .where("activities.id IS NULL")
  }

  def to_search_json
    {
      id: id,
      name: name,
      division: division_name,
      submission: submission.app_name,
      location: [
        city,
        state_province,
        country_code
      ].join(", "),
      scope: self.class.model_name,
      status: status,
      human_status: human_status,
      status_explained: status_explained
    }
  end

  def status
    if submission.complete? and qualified?
      "ready"
    elsif !submission.complete? and qualified?
      "submission_incomplete"
    else
      "unqualified"
    end
  end

  def human_status
    case status
    when "ready" then "ready!"
    when "submission_incomplete" then "submission in progress"
    when "unqualified" then "not qualified"
    else; "status missing (bug)"
    end
  end

  def status_explained
    case status
    when "ready"
      "#{name} finished their submission and " +
        "all members are qualified"
    when "submission_incomplete"
      "#{name} is qualified to compete and needs " +
        "to finish their submission"
    when "unqualified"
      "One or more students on #{name} has not finished " +
        "completing their registration"
    end
  end

  def avatar_url
    team_photo_url
  end

  def scope_name
    "team"
  end

  def photo
    team_photo
  end

  Division.names.keys.each do |division_name|
    scope division_name, -> {
      joins(:division).where(
        "divisions.name = ?",
        Division.names[division_name]
      )
    }
  end

  scope :unmatched, ->(member_scope) {
    where("has_#{member_scope} = ?", false)
  }

  scope :matched, ->(member_scope) {
    where("has_#{member_scope} = ?", true)
  }

  scope :by_division, ->(division) {
    joins(:division)
      .where("divisions.name = ?", Division.names[division])
  }

  scope :not_attending_live_event, -> {
    includes(:regional_pitch_events)
      .references(:regional_pitch_events)
      .where("regional_pitch_events.id IS NULL")
  }

  scope :accepting_mentor_requests, -> {
    where(accepting_mentor_requests: true)
  }

  scope :accepting_student_requests, -> {
    where(accepting_student_requests: true)
  }

  scope :by_chapterable, ->(chapterable_type, chapterable_id) do
    joins(:memberships,
      students: {
        account: :chapterable_assignments
      })
      .where(
        chapterable_assignments: {
          chapterable_type: chapterable_type.capitalize,
          chapterable_id: chapterable_id
        }
      )
  end

  belongs_to :division

  has_many :team_submissions, dependent: :destroy
  has_many :submission_scores, through: :team_submissions

  has_one :submission, -> { current },
    class_name: "TeamSubmission"

  has_many :memberships, dependent: :destroy

  has_many :students, -> { order("memberships.created_at") },
    through: :memberships,
    source: :member,
    source_type: "StudentProfile"

  has_many :mentors, -> { order("memberships.created_at") },
    through: :memberships,
    source: :member,
    source_type: "MentorProfile"

  has_many :team_member_invites, dependent: :destroy
  has_many :mentor_invites, dependent: :destroy
  has_many :join_requests, dependent: :destroy

  has_many :pending_student_invites,
    -> { pending.for_students },
    class_name: "TeamMemberInvite"

  has_many :pending_mentor_invites,
    -> { pending },
    class_name: "MentorInvite"

  has_many :pending_requests,
    -> { pending },
    class_name: "JoinRequest"

  has_many :pending_mentor_join_requests,
    -> { pending.for_mentors },
    class_name: "JoinRequest"

  has_many :pending_student_join_requests,
    -> { pending.for_students },
    class_name: "JoinRequest"

  has_and_belongs_to_many :regional_pitch_events, -> { current },
    after_add: ->(team, event) { team.submission.touch },
    after_remove: ->(team, event) { team.submission.touch }

  has_and_belongs_to_many :events, -> { current },
    class_name: "RegionalPitchEvent",
    after_add: ->(team, event) {
      team.submission.touch
      event.update_teams_count
    },
    after_remove: ->(team, event) {
      team.submission.touch
      event.update_teams_count
    }

  has_and_belongs_to_many :current_official_events, -> { current.official },
    class_name: "RegionalPitchEvent",
    after_add: ->(team, event) { team.submission.touch },
    after_remove: ->(team, event) { team.submission.touch }

  has_many :judge_assignments, -> { current }

  validates :name, presence: true, team_name_uniqueness: true
  validates :division, presence: true

  delegate :name, to: :division, prefix: true

  def random_id
    SecureRandom.hex(4)
  end

  def is_team?
    true
  end

  def qualified?
    has_students? && all_students_onboarded?
  end

  def team_photo_url
    if team_photo.blank?
      default_team_photo_url
    elsif team_photo.include?("filestackcontent")
      team_photo
    else
      "https://s3.amazonaws.com/#{ENV.fetch("AWS_BUCKET_NAME")}/uploads/team/team_photo/#{id}/#{team_photo}"
    end
  end

  def photo_url
    team_photo_url
  end

  def submission
    super || ::NullTeamSubmission.new
  end

  def eligible_events
    if submission.present?
      [VirtualRegionalPitchEvent.new] +
        RegionalPitchEvent.available_to(submission)
    else
      []
    end
  end

  def ages
    students.map(&:age).compact.uniq
  end

  def selected_regional_pitch_event
    regional_pitch_events.last or VirtualRegionalPitchEvent.new
  end
  alias_method :event, :selected_regional_pitch_event

  def live_event?
    selected_regional_pitch_event.live?
  end

  def attending_live_event(&block)
    if selected_regional_pitch_event.live?
      yield
    end
  end

  def selected_regional_pitch_event_name
    selected_regional_pitch_event.name
  end
  alias_method :event_name, :selected_regional_pitch_event_name

  def region_name
    if %w[Brasil Brazil].include?(state_province || "")
      "Brazil"
    elsif country_code == "US"
      state = Country["US"].states[state_province.strip]
      (state && state["name"]) || state_province
    else
      FriendlyCountry.call(self)
    end
  end

  def region_division_name
    Rails.cache.fetch("#{cache_key}/region_division_name") do
      name = country_code || ""
      if name == "US"
        name += "_#{state_province}"
      end
      name += ",#{division.name}"
    end
  end

  def junior?
    division.junior?
  end

  def senior?
    division.senior?
  end

  def senior_division(&block)
    if senior?
      yield
    end
  end

  def student_emails
    students.flat_map(&:email)
  end

  def mentor_emails
    mentors.flat_map(&:email)
  end

  def members
    students + mentors
  end

  def spot_available?
    (students +
      pending_student_invites +
        pending_student_join_requests).size < 5
  end

  def pending_invitee_emails
    team_member_invites.pending.flat_map(&:invitee_email)
  end

  def current?
    seasons.include?(Season.current.year)
  end

  def past?
    !current?
  end

  def invited_mentor?(mentor)
    mentor_invites.pending.where(
      invitee_id: mentor.id,
      invitee_type: "MentorProfile"
    ).exists?
  end

  def unassigned?
    !assigned?
  end

  def assigned?
    judge_assignments.exists?
  end

  def assigned_judge_names
    assigned_judges.flat_map(&:full_name)
  end

  def student_chapterables
    students.map do |student|
      student.current_chapterable
    end
  end

  private

  def regenerate_team_submission_friendly_id
    if saved_change_to_name? && !submission.is_a?(NullTeamSubmission)
      submission.update(slug: nil)
    end
  end

  def default_team_photo_url
    if Season.current.year >= 2023 && current?
      ActionController::Base.helpers.asset_path("placeholders/default-team-avatar.png")
    else
      ActionController::Base.helpers.asset_path("placeholders/team-missing.jpg")
    end
  end

  def update_student_info_in_crm
    if any_crm_fields_changed? && students.present?
      students.each do |student|
        CRM::UpsertProgramInfoJob.perform_later(
          account_id: student.account.id,
          profile_type: "student",
          season: seasons.last || Season.current.year
        )
      end
    end
  end

  def any_crm_fields_changed?
    [
      :name
    ].any? { |attr| saved_change_to_attribute?(attr) }
  end
end
