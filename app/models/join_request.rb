class JoinRequest < ActiveRecord::Base
  after_create :notify_requested_joinable
  after_save :notify_requestor, on: :update

  scope :pending, -> { where('accepted_at IS NULL and rejected_at IS NULL') }
  scope :from_students, -> { where(requestor_type: "StudentAccount") }

  belongs_to :requestor, polymorphic: true
  belongs_to :joinable, polymorphic: true

  delegate :name, to: :joinable, prefix: true
  delegate :full_name, :type_name, :email,
    to: :requestor, prefix: true

  def approved!
    update_attributes(accepted_at: Time.current)
    joinable.public_send("add_#{requestor.type_name}", requestor)
  end

  def rejected!
    update_attributes(rejected_at: Time.current)
  end

  def status
    if !!accepted_at
      "Accepted"
    elsif !!rejected_at
      "Rejected"
    else
      "Pending review"
    end
  end

  private
  def notify_requested_joinable
    joinable.members.each do |recipient|
      TeamMailer.join_request(recipient, self).deliver_later
    end
  end

  def notify_requestor
    if accepted_at_changed? or rejected_at_changed?
      TeamMailer.public_send("#{requestor_type_name}_join_request_#{status.underscore}", self).deliver_later
    end
  end
end
