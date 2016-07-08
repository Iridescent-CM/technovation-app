class TeamMemberInvite < ActiveRecord::Base
  before_validation :generate_invite_token
  after_create :send_invite

  belongs_to :team
  belongs_to :inviter, class_name: "Account"

  validates :invitee_email, presence: true

  delegate :email, to: :inviter, prefix: true

  scope :pending, -> { where('accepted_at IS NULL') }

  def accept!
    update_attributes(accepted_at: Time.current)
  end

  def accepted?
    !!accepted_at
  end

  def to_param
    invite_token
  end

  def self.find_with_token(token)
    find_by(invite_token: token)
  end

  private
  def generate_invite_token
    GenerateToken.(self, :invite_token)
  end

  def send_invite
    TeamMailer.invite_member(self).deliver_later
  end
end
