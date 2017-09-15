class Team < ActiveRecord::Base
  include Seasoned

  acts_as_paranoid

  include Casting::Client
  delegate_missing_methods

  geocoded_by :geolocation_str
  reverse_geocoded_by :latitude, :longitude do |team, results|
    team.update_address_details_from_reverse_geocoding(results)
  end

  def scope_name
    "student" # Needed for RPE selection views that are shared by judges
  end

  def photo
    team_photo
  end

  mount_uploader :team_photo, TeamPhotoProcessor

  Division.names.keys.each do |division_name|
    scope division_name, -> {
      joins(:division).where("divisions.name = ?", Division.names[division_name])
    }
  end

  scope :without_mentor, -> {
    where.not(id: Membership.where(member_type: "MentorProfile").map(&:team_id))
  }

  scope :for_ambassador, ->(ambassador) {
    if ambassador.country == "US"
      where("state_province = ? AND country = 'US'", ambassador.state_province)
    else
      where("country = ?", ambassador.country)
    end
  }

  scope :not_attending_live_event, -> {
    includes(:regional_pitch_events)
      .references(:regional_pitch_events)
      .where("regional_pitch_events.id IS NULL")
  }

  scope :accepting_mentor_requests, -> { where(accepting_mentor_requests: true) }

  scope :accepting_student_requests, -> { where(accepting_student_requests: true) }

  belongs_to :division

  has_many :team_submissions, dependent: :destroy
  has_many :submission_scores, through: :team_submissions

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

  has_and_belongs_to_many :regional_pitch_events, -> { distinct },
    after_add: :update_submission,
    after_remove: :update_submission

  has_many :judge_assignments
  has_many :assigned_judges, through: :judge_assignments, source: :judge_profile

  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :division, presence: true
  validates :team_photo, verify_cached_file: true

  delegate :name, to: :division, prefix: true

  def remove_from_live_event
    team_submissions.flat_map(&:submission_scores).each(&:destroy)
    judge_assignments.destroy_all
    regional_pitch_events.destroy_all
  end

  def update_submission(team)
    submission.touch if submission.present?
  end

  def eligible_events
    if submission.present?
      [VirtualRegionalPitchEvent.new] + RegionalPitchEvent.available_to(submission)
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

  def selected_regional_pitch_event_name
    selected_regional_pitch_event.name
  end

  def region_name
    if %w{Brasil Brazil}.include?(state_province || "")
      "Brazil"
    elsif country == "US"
      state = Country["US"].states[state_province.strip]
      (state && state['name']) || state_province
    else
      FriendlyCountry.(self)
    end
  end

  def region_division_name
    Rails.cache.fetch("#{cache_key}/region_division_name") do
      name = country || ""
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

  def current_team_submission
    team_submissions.current.first
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
    (students + pending_student_invites + pending_student_join_requests).size < 5
  end

  def primary_location
    if geolocation_str.empty?
      "No location has been set"
    else
      geolocation_str
    end
  end

  def pending_invitee_emails
    team_member_invites.pending.flat_map(&:invitee_email)
  end

  def current?
    seasons.include?(Season.current.year)
  end

  def invited_mentor?(mentor)
    mentor_invites.pending.where(
      invitee_id: mentor.id,
      invitee_type: "MentorProfile"
    ).exists?
  end

  def submission
    team_submissions.current.last or NullTeamSubmission.new
  end

  def unassigned?
    not assigned?
  end

  def assigned?
    judge_assignments.exists?
  end

  def assigned_judge_names
    assigned_judges.flat_map(&:full_name)
  end

  def update_address_details_from_reverse_geocoding(results)
    if geo = results.first
      self.city = geo.city
      self.state_province = geo.state_code
      country = Country.find_country_by_name(geo.country_code) ||
                  Country.find_country_by_alpha3(geo.country_code) ||
                    Country.find_country_by_alpha2(geo.country_code)
      self.country = country.alpha2
    end
  end

  private
  def geolocation_str
    [
      city,
      state_province,
      Country[country].try(:name)
    ].reject(&:blank?)
     .join(', ')
  end
end
