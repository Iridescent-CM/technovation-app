class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  has_many :scores, foreign_key: :judge_id

  has_many :judge_expertises, dependent: :destroy
  has_many :expertises, through: :judge_expertises

  validates :user_id, :role_id, presence: true

  def self.judge
    joins(:role).where(roles: { name: Role.names[:judge] }).first
  end

  def submission_ids
    scores.select('submission_id as id')
  end
end
