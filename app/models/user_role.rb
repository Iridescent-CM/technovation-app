class UserRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role

  has_many :judge_expertises, -> { joins(:roles).where(role: { name: Role.names[:judge] }) }
  has_many :expertises, -> { joins(:roles).where(role: { name: Role.names[:judge] }) }, through: :judge_expertises
end
