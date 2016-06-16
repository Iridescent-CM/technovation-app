class Submission < ActiveRecord::Base
  belongs_to :team
  has_many :scores

  scope :visible_to, ->(judge) {
    where.not(id: judge.submission_ids)
  }

  delegate :name, to: :team, prefix: true

  def self.random
    order('random()').limit(1).first
  end

  def eligible?
    missing_fields.empty?
  end

  def missing_fields
    attributes.select { |_, v| v.blank? }.keys
  end
end
