class AuthenticationRole < ActiveRecord::Base
  default_scope { includes(:role) }

  belongs_to :authentication
  belongs_to :role

  has_many :scores, foreign_key: :judge_id

  has_many :judge_expertises, dependent: :destroy
  has_many :expertises, through: :judge_expertises

  validates :role_id, presence: true

  delegate :admin?, to: :role, prefix: false

  def scored_submission_ids
    scores.select('submission_id as id')
  end

  def authenticated?
    true
  end
end
