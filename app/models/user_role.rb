class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  has_many :judge_expertises, -> { where(role: { name: Role.names[:judge] }) }
  has_many :expertises, -> { where(role: { name: Role.names[:judge] }) }, through: :judge_expertises
end
