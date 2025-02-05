class StudentProfile < ActiveRecord::Base
  acts_as_paranoid

  include Regioned
  regioned_source Account

  include Casting::Client
  delegate_missing_methods

  alias_attribute :school_company_name, :school_name

  scope :current, -> {
    joins(:current_account)
  }

  scope :unmatched, -> {
    select("DISTINCT student_profiles.*")
      .joins(:current_account)
      .includes(:account)
      .references(:accounts)
      .left_outer_joins(:current_teams)
      .where("teams.id IS NULL")
  }

  scope :onboarded, -> { where(onboarded: true) }
  scope :onboarding, -> { where(onboarded: false) }

  has_many :memberships,
    as: :member,
    dependent: :destroy

  has_many :teams,
    through: :memberships

  has_many :current_teams, -> { current },
    through: :memberships,
    source: :team

  has_many :past_teams, -> { past },
    through: :memberships,
    source: :team

  has_many :team_submissions, through: :teams

  has_many :mentor_invites,
    foreign_key: :inviter_id

  has_many :team_member_invites,
    as: :invitee,
    dependent: :destroy

  has_many :join_requests,
    as: :requestor,
    dependent: :destroy

  has_many :pending_join_requests, -> { pending },
    as: :requestor,
    class_name: "JoinRequest"

  has_many :declined_join_requests, -> { declined },
    as: :requestor,
    class_name: "JoinRequest"

  has_many :teams_that_declined,
    through: :declined_join_requests,
    as: :requestor,
    source: :team

  belongs_to :account, touch: true, required: false
  accepts_nested_attributes_for :account
  validates_associated :account

  belongs_to :current_account, -> { current },
    foreign_key: :account_id,
    class_name: "Account",
    required: false

  belongs_to :chapter, optional: true

  has_many :parental_consents, dependent: :destroy
  has_one :parental_consent, -> { current }, dependent: :destroy
  accepts_nested_attributes_for :parental_consents

  has_one :signed_parental_consent,
    -> { current.signed },
    class_name: "ParentalConsent",
    dependent: :destroy

  has_one :pending_parental_consent,
    -> { current.pending },
    class_name: "ParentalConsent",
    dependent: :destroy

  has_many :past_parental_consents,
    -> { past },
    class_name: "ParentalConsent",
    dependent: :destroy

  has_one :media_consent, -> { where season: Season.current.year }
  has_many :media_consents, dependent: :destroy

  has_many :jobs, as: :owner

  has_many :chapterable_assignments, as: :profile, class_name: "ChapterableAccountAssignment"

  after_commit :reset_parent, on: :update

  after_touch { team.touch }

  attr_accessor :destroyed
  after_destroy -> { self.destroyed = true }

  after_commit -> {
    if destroyed
      team.touch
    else
      update_column(:onboarded, can_be_marked_onboarded?)
      team.touch
    end
  }

  validates :school_name, presence: true

  validate :parent_guardian_email, -> { validate_valid_parent_email }

  delegate :electronic_signature,
    :signed_at,
    to: :parental_consent,
    prefix: true

  def method_missing(method_name, *args) # standard:disable all
    # TODO: stop using this strategy

    super
  rescue
    begin
      account.public_send(method_name, *args) # standard:disable all
    rescue
      raise NoMethodError,
        "undefined method `#{method_name}' not found for #{self}"
    end
  end

  def parent_guardian_first_name
    parent_guardian_name_parts.first
  end

  def parent_guardian_last_name
    (parent_guardian_name_parts.length >= 2) ? parent_guardian_name_parts.last : nil
  end

  def self.exists_on_team?(email)
    if record = joins(:account).find_by("accounts.email = ?", email)
      record.is_on_team?
    else
      false
    end
  end

  def self.has_requested_to_join?(team, email)
    if record = joins(:account).where("lower(accounts.email) = ?", email.downcase).first
      record.join_requests.pending.flat_map(&:team).include?(team)
    else
      false
    end
  end

  def onboarding_steps
    steps = []

    methods = [
      :email_confirmed?,
      :parental_consent_signed?
    ]

    methods.each do |method|
      if !send(method)
        steps.push(method)
      end
    end

    steps
  end

  def has_completed_action?(action)
    case action.name
    when :join_team
      is_on_team?
    else
      raise "Implement StudentProfile#has_completed_action? case for :#{action.name}"
    end
  end

  def job_title=(*)
    false
  end

  def mentor_type=(*)
    false
  end

  def expertise_ids=(*)
    false
  end

  def bio=(*)
    false
  end

  def has_saved_parental_info?
    persisted? &&
      parent_guardian_email.present? &&
      parent_guardian_name.present? &&
      valid?
  end

  def participated?
    team.submission.present? &&
      team.submission.qualifies_for_participation?
  end

  def status
    if current_account && onboarded?
      "ready"
    elsif current_account
      "registered"
    else
      "past_season"
    end
  end

  def human_status
    case status
    when "past_season" then "must log in"
    when "registered" then "must complete onboarding"
    when "ready" then "ready!"
    else; "status missing (bug)"
    end
  end

  def friendly_status
    case status
    when "past_season" then "Log in now"
    when "registered" then "Complete your student profile"
    when "ready" then "Log in for more details"
    else; "status missing (bug)"
    end
  end

  def validate_parent_email
    %i[parent_guardian_name parent_guardian_email].select { |a|
      send(a).blank?
    }.each do |a|
      errors.add(a, :blank)
    end

    validate_valid_parent_email

    errors.empty?
  end

  def pending_team_invitations
    team_member_invites.pending
  end

  def pending_team_requests
    join_requests.pending
  end

  def pending_invitation_for(team)
    pending_team_invitations.detect { |i| i.team == team }
  end

  def parental_consent_signed?(season = Season.current.year)
    parental_consents.by_season(season).any?(&:signed?)
  end

  def media_consent_signed?
    !!media_consent && media_consent.signed?
  end

  def can_search_teams?
    SeasonToggles.team_building_enabled? and
      !is_on_team? and
      !team_member_invites.pending.any? and
      !join_requests.pending.any?
  end

  def is_on_team?
    team.present?
  end

  def team_has_mentor?
    team.present? and team.mentors.any?
  end

  def requested_to_join?(team)
    join_requests.pending.flat_map(&:team).include?(team)
  end

  def is_invited_to_join?(team)
    team_member_invites.pending.flat_map(&:team).include?(team)
  end

  def is_on?(query_team)
    team == query_team
  end

  def can_join_a_team?
    !is_on_team? and
      SeasonToggles.team_building_enabled?
  end
  alias_method :can_create_a_team?, :can_join_a_team?

  def team
    current_teams.first or ::NullTeam.new
  end

  def team_ids
    team.present? ? [team_id] : []
  end

  def team_id
    team.present? ? team.id : nil
  end

  def team_name
    team.name
  end

  def team_names
    [team_name]
  end

  def oldest_birth_year
    Date.today.year - 19
  end

  def youngest_birth_year
    Date.today.year - 8
  end

  def authenticated?
    true
  end

  def consent_signed?
    parental_consent_signed?
  end

  def scope_name
    "student"
  end

  def onboarding?
    !onboarded?
  end

  def actions_needed
    actions = []
    actions << "Confirm their new email address" unless account.email_confirmed?
    actions << "Get their parent or guardian's permission to compete" unless parental_consent_signed?
    actions << "Enter their location details" if !valid_coordinates?
    actions
  end

  def rebranded?
    true
  end

  def can_view_scores?
    current_account.took_program_survey? &&
      (team.submission.complete? || participated?)
  end

  def can_be_marked_onboarded?
    account.present? &&
      parental_consent_signed? &&
      !account.email_confirmed_at.blank? &&
      account.valid_coordinates? &&
      account.terms_agreed_at?
  end

  private

  def validate_valid_parent_email
    return if parent_guardian_email.blank? ||
      Division.for_account(account).name == "beginner" ||
      (
        !parent_guardian_email_changed? &&
        parent_guardian_email == ConsentForms::PARENT_GUARDIAN_EMAIL_ADDDRESS_FOR_A_PAPER_CONSENT
      )

    if !parent_guardian_email.match(
      /^[^@\.][\w\.\-]+(?:\+?[\w\.\-]+)?@[\w\.\-]+\w+$/
    )
      errors.add(:parent_guardian_email, :invalid)
    end
  end

  def parent_guardian_name_parts
    @parent_guardian_name_parts ||= parent_guardian_name.present? ? parent_guardian_name.split(/\s+/, 2) : []
  end

  def reset_parent
    return if parent_guardian_email == ConsentForms::PARENT_GUARDIAN_EMAIL_ADDDRESS_FOR_A_PAPER_CONSENT

    if saved_change_to_parent_guardian_email? &&
        parent_guardian_email.present?
      if consent = parental_consent
        consent.pending!
      else
        create_parental_consent!
      end

      ParentMailer.consent_notice(id).deliver_later
    end

    if saved_change_to_parent_guardian_name? ||
        (saved_change_to_parent_guardian_email? && parent_guardian_email.present?)
      CRM::UpsertContactInfoJob.perform_later(
        account_id: account.id,
        profile_type: "student"
      )
    end
  end
end
