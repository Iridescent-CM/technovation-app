class Message < ActiveRecord::Base
  scope :sent, -> { where("sent_at IS NOT NULL") }
  scope :unsent, -> { where("sent_at IS NULL") }
  scope :undelivered, -> { where("delivered_at IS NULL") }

  belongs_to :sender, polymorphic: true
  belongs_to :recipient, polymorphic: true
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
    !sent?
  end

  def delivered!
    self.delivered_at = Time.current
    save!
  end

  def delivered?
    delivered_at
  end

  def regarding_name
    case regarding_type
    when "RegionalPitchEvent"
      "event: #{regarding.name}"
    end
  end

  def regarding_link_text
    case regarding_type
    when "RegionalPitchEvent"
      "View the full event details for #{regarding.name}"
    end
  end

  def recipient_name
    case recipient_type
    when "Team"
      "team: #{recipient.name}"
    when "JudgeProfile"
      "judge: #{recipient.full_name}"
    end
  end
end
