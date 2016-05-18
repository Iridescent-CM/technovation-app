class TeamRequest < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  validates_uniqueness_of :team_id, scope: :user_id

  scope :pending, -> { where approved: false }
  scope :approved, -> { where approved: true }

  after_save :update_team_data, if: :changed_approval?
  after_destroy :update_team_data, if: :approved?
  after_destroy :destroy_empty_teams, if: :approved?

  after_create :notify_user_received,
    if: Proc.new{ self.approved == false and self.user_request == false}

  delegate :email, :role, to: :user, prefix: true, allow_nil: true

  def update_team_data
    team.update_team_data!
  end

  def destroy_empty_teams
    team.check_empty!
  end

  def changed_approval?
    # new or the approval changed?
    id_changed? or approved_changed?
  end

  def approved?
    self.approved
  end

  private
  def notify_user_received
    InviteMailer.invite_received_email(self.user, self.team).deliver
  end
end
