class MultiMessage < ActiveRecord::Base
  store_accessor :recipients, :team, :judge_profile

  scope :sent, -> { where("sent_at IS NOT NULL") }
  scope :unsent, -> { where("sent_at IS NULL") }
  scope :undelivered, -> { where("delivered_at IS NULL") }

  belongs_to :sender, polymorphic: true
  belongs_to :regarding, polymorphic: true

  validates :body, presence: true

  def sent!
    self.sent_at = Time.current
    save!
  end

  def sent?
    sent_at
  end

  def unsent?
    not sent?
  end

  def delivered!
    self.delivered_at = Time.current
    save!
  end

  def delivered?
    delivered_at
  end

  def teams
    @teams ||= team.split(',').map { |id|
      id.gsub(/[\D]/, '')
    }.reject(&:blank?).map do |id|
      Team.find(id)
    end
  end

  def judges
    @judges ||= judge_profile.split(',').map { |id|
      id.gsub(/[\D]/, '')
    }.reject(&:blank?).map do |id|
      JudgeProfile.find(id)
    end
  end

  def recipient_name
    names = recipients.reject { |_, v| v.blank? }.keys
    "All #{names.map(&:humanize).map(&:pluralize).to_sentence} for #{regarding_name}"
  end

  def regarding_name
    regarding.name
  end
end
