class Club < ActiveRecord::Base

  belongs_to :primary_contact, class_name: "Account", foreign_key: "primary_account_id", optional: true

  validates :name, presence: true
  validates :summary, length: {maximum: 1000}
end
