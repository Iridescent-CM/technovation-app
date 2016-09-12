class StudentAccount < Account
  default_scope { joins(:student_profile) }

  has_many :memberships, as: :member, dependent: :destroy
  has_many :mentor_invites, foreign_key: :inviter_id

  has_many :join_requests, as: :requestor, dependent: :destroy
  has_many :team_member_invites, foreign_key: :invitee_id, dependent: :destroy

  has_one :parental_consent, -> { nonvoid }, dependent: :destroy, foreign_key: :account_id

  has_one :student_profile, dependent: :destroy, foreign_key: :account_id
  accepts_nested_attributes_for :student_profile
  validates_associated :student_profile

  after_save -> { team.present? && team.reconsider_division },
    if: :date_of_birth_changed?

  delegate :parent_guardian_email,
           :parent_guardian_name,
           :school_name,
    to: :student_profile,
    prefix: false

  delegate :electronic_signature,
           :signed_at,
    to: :parental_consent,
    prefix: true

  def self.exists_on_team?(attributes)
    if record = find_by(attributes)
      record.is_on_team?
    else
      false
    end
  end

  def self.has_requested_to_join?(team, email)
    if record = find_by(email: email)
      record.join_requests.pending.flat_map(&:joinable).include?(team)
    else
      false
    end
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
    parental_consent.present? and not is_on_team?
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

  def teams
    Team.joins(:memberships).where("memberships.member_id = ?", id)
  end

  def oldest_birth_year
    Date.today.year - 19
  end

  def youngest_birth_year
    Date.today.year - 8
  end

  def invited_mentor?(mentor)
    MentorInvite.pending.where(team: team).flat_map(&:invitee).include?(mentor)
  end

  def void_parental_consent!
    !!parental_consent && parental_consent.void!
  end

  def after_registration
    super
    RegistrationMailer.welcome_student(self).deliver_later

    if parent_guardian_email.present?
      ParentMailer.consent_notice(parent_guardian_email, parent_guardian_name, consent_token).deliver_later
    end
  end

  def age
    now = Time.current.utc.to_date

    current_month_after_birth_month = now.month > date_of_birth.month
    current_month_is_birth_month = now.month == date_of_birth.month
    current_day_is_on_or_after_birthday = now.day >= date_of_birth.day

    extra_year = (current_month_after_birth_month ||
                    (current_month_is_birth_month &&
                       current_day_is_on_or_after_birthday)) ? 0 : 1

    now.year - date_of_birth.year - extra_year
  end

  private
  class NullTeam
    def has_mentor?
      false
    end

    def present?
      false
    end
  end
end
