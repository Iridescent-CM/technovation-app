class BasicProfile < ActiveRecord::Base
  belongs_to :authentication

  validates :date_of_birth, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :city, presence: true
  validates :region, presence: true
  validates :country, presence: true
end
