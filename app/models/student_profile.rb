class StudentProfile < ActiveRecord::Base
  scope :full_access, -> { joins(:account, :parental_consent).where("accounts.location_confirmed = ?", true) }

  has_many :memberships, as: :member, dependent: :destroy
  has_many :teams, through: :memberships, source: :joinable, source_type: "Team"
  has_many :mentor_invites, foreign_key: :inviter_id

  has_many :join_requests, as: :requestor, dependent: :destroy
  has_many :team_member_invites, as: :invitee, dependent: :destroy

  belongs_to :account, touch: true
  accepts_nested_attributes_for :account
  validates_associated :account

  has_one :parental_consent, -> { nonvoid }, dependent: :destroy
  has_many :void_parental_consents,
    -> { void },
    class_name: "ParentalConsent",
    dependent: :destroy

  after_update :reset_parent

  after_save { teams.current.find_each(&:touch) }
  after_touch { teams.current.find_each(&:touch) }

  validates :school_name, presence: true

  validate :parent_guardian_email, -> { validate_valid_parent_email }

  delegate :electronic_signature,
           :signed_at,
    to: :parental_consent,
    prefix: true

  def method_missing(method_name, *args)
    begin
      account.public_send(method_name, *args)
    rescue
      raise NoMethodError, "undefined method `#{method_name}' not found for #{self}"
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
      record.join_requests.pending.flat_map(&:joinable).include?(team)
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

  def is_on_team?
    teams.current.any?(&:present?)
  end

  def team_has_mentor?
    team.present? and team.mentors.any?
  end

  def requested_to_join?(team)
    join_requests.pending.flat_map(&:joinable).include?(team)
  end

  def is_invited_to_join?(team)
    team_member_invites.pending.flat_map(&:team).include?(team)
  end

  def is_on?(query_team)
    team == query_team
  end

  def can_join_a_team?
    honor_code_signed? and parental_consent_signed? and not is_on_team?
  end

  def team
    teams.current.first or NullTeam.new
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
    teams.current.collect(&:name)
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

  def void_honor_code_agreement!
    !!honor_code_agreement && honor_code_agreement.void!
  end

  def authenticated?
    true
  end

  def consent_signed?
    parental_consent_signed?
  end

  def type_name
    "student"
  end

  def full_access_enabled?
    honor_code_signed? and parental_consent_signed? and location_confirmed?
  end

  private
  class NullTeam
    def has_mentor?
      false
    end

    def present?
      false
    end

    def mentors
      []
    end

    def current_team_submission
      NullTeamSubmission.new
    end

    def submission
      NullTeamSubmission.new
    end

    class NullTeamSubmission
      def present?
        false
      end

      def screenshots
        []
      end

      def app_name
        "not started"
      end

      def average_score
        0
      end
    end
  end

  def validate_valid_parent_email
    return if parent_guardian_email.blank? || (!parent_guardian_email_changed? && parent_guardian_email == "ON FILE")

    if Account.joins(:student_profile).where("lower(email) = ?", parent_guardian_email.downcase).any?
      errors.add(:parent_guardian_email, :found_in_student_accounts)
    end

    if not parent_guardian_email.match(/^[^@\.][\w\.\-]+(?:\+?[\w\.\-]+)?@[\w\.\-]+\w+$/)
      errors.add(:parent_guardian_email, :invalid)
    end
  end

  def reset_parent
    if parent_guardian_email_changed? and parent_guardian_email.present?
      void_parental_consent!
      ParentMailer.consent_notice(id).deliver_later
    end

    if parent_guardian_name_changed? or parent_guardian_email_changed? and parent_guardian_email.present?
      UpdateEmailListJob.perform_later(parent_guardian_email_was,
                                       parent_guardian_email,
                                       parent_guardian_name,
                                       "PARENT_LIST_ID")
    end
  end
end
