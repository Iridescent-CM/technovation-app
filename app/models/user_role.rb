class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  has_many :judge_expertises
  has_many :expertises, through: :judge_expertises

  validates :user_id, :role_id, presence: true
end
