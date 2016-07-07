class TeamMemberInvite < ActiveRecord::Base
  before_validation :generate_invite_token
  after_create :send_invite

  belongs_to :team
  belongs_to :inviter, class_name: "Account"

  validates :invitee_email, presence: true

  private
  def generate_invite_token
    GenerateToken.(self, :invite_token)
  end

  def send_invite
    TeamMailer.invite_member(self).deliver_later
  end
end
