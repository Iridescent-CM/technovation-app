class StudentProfile < ActiveRecord::Base
  include Casting::Client
  delegate_missing_methods

  scope :unmatched, -> {
    select("DISTINCT student_profiles.*")
      .joins(:current_account)
      .includes(:account)
      .references(:accounts)
      .left_outer_joins(:current_teams)
      .where("teams.id IS NULL")
  }

  scope :in_region, ->(ambassador) {
    if ambassador.country == "US"
      joins(:account)
        .where(
          "accounts.country = ? AND accounts.state_province = ?",
          "US",
          ambassador.state_province
        )
    else
      joins(:account)
        .where("accounts.country = ?", ambassador.country)
    end
  }

  scope :onboarded, -> {
    joins(:account, :parental_consent)
      .where("accounts.location_confirmed = ?", true)
      .where("accounts.email_confirmed_at IS NOT NULL")
  }

  scope :onboarding, -> {
    left_outer_joins(:account, :parental_consent)
      .where(
        "parental_consents.id IS NULL OR
          accounts.location_confirmed = ? OR
            accounts.email_confirmed_at IS NULL",
        false
      )
  }

  has_many :memberships, as: :member, dependent: :destroy
  has_many :teams, through: :memberships

  has_many :current_teams, -> { current },
    through: :memberships,
    source: :team

  has_many :mentor_invites, foreign_key: :inviter_id
  has_many :join_requests, as: :requestor, dependent: :destroy
  has_many :team_member_invites, as: :invitee, dependent: :destroy

  belongs_to :account, touch: true
  accepts_nested_attributes_for :account
  validates_associated :account

  belongs_to :current_account, -> { current },
    foreign_key: :account_id,
    class_name: "Account",
    required: false

  has_one :parental_consent, -> { nonvoid }, dependent: :destroy
  has_many :void_parental_consents,
    -> { void },
    class_name: "ParentalConsent",
    dependent: :destroy

  after_update :reset_parent

  after_save { team.touch }
  after_touch { team.touch }

  validates :school_name, presence: true

  validate :parent_guardian_email, -> { validate_valid_parent_email }

  delegate :electronic_signature,
           :signed_at,
    to: :parental_consent,
    prefix: true

  def method_missing(method_name, *args)
    # TODO: stop using this strategy
    begin
      super
    rescue
      begin
        account.public_send(method_name, *args)
      rescue
        raise NoMethodError,
          "undefined method `#{method_name}' not found for #{self}"
      end
    end
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

  def validate_parent_email
    %i{parent_guardian_name parent_guardian_email}.select {
      |a| send(a).blank?
    }.each do |a|
      errors.add(a, :blank)
    end

    if parent_guardian_email == account.email
      errors.add(:parent_guardian_email, :matches_student_email)
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

  def parental_consent_signed?
    parental_consent.present?
  end

  def can_search_teams?
    SeasonToggles.team_building_enabled? and
      not is_on_team? and
        not team_member_invites.pending.any? and
          not join_requests.pending.any?
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
    not is_on_team? and
      SeasonToggles.team_building_enabled?
  end

  def team
    current_teams.first or NullTeam.new
  end

  def team_ids
    [team_id]
  end

  def team_id
    team.id
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

  def void_parental_consent!
    !!parental_consent && parental_consent.void!
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
    not onboarded?
  end

  def onboarded?
    account.email_confirmed? and
      parental_consent_signed? and
        location_confirmed?
  end

  def actions_needed
    actions = []
    actions << "Confirm their new email address" unless account.email_confirmed?
    actions << "Get their parent or guardian's permission to compete" unless parental_consent_signed?
    actions << "Enter their location details" unless location_confirmed?
    actions
  end

  private
  def validate_valid_parent_email
    return if parent_guardian_email.blank? ||
      (!parent_guardian_email_changed? && parent_guardian_email == "ON FILE")

    if Account.joins(:student_profile).where(
         "lower(email) = ?",
         parent_guardian_email.downcase
       ).any?
      errors.add(:parent_guardian_email, :found_in_student_accounts)
    end

    if not parent_guardian_email.match(/^[^@\.][\w\.\-]+(?:\+?[\w\.\-]+)?@[\w\.\-]+\w+$/)
      errors.add(:parent_guardian_email, :invalid)
    end
  end

  def reset_parent
    if saved_change_to_parent_guardian_email? and parent_guardian_email.present?
      void_parental_consent!
      ParentMailer.consent_notice(id).deliver_later
    end

    if saved_change_to_parent_guardian_name? or
         saved_change_to_parent_guardian_email? and
           parent_guardian_email.present?
      UpdateEmailListJob.perform_later(parent_guardian_email_before_last_save,
                                       parent_guardian_email,
                                       parent_guardian_name,
                                       "PARENT_LIST_ID")
    end
  end
end
