class JoinRequest < ActiveRecord::Base
  after_create :notify_requested_joinable
  after_update :notify_requestor

  scope :pending, -> { where('accepted_at IS NULL and declined_at IS NULL') }

  scope :for_students, -> { where(requestor_type: "StudentProfile") }

  belongs_to :requestor, polymorphic: true
  belongs_to :joinable, polymorphic: true

  delegate :name,
    to: :joinable,
    prefix: true

  delegate :first_name,
           :type_name,
           :full_name,
           :email,
           :account_id,
    to: :requestor,
    prefix: true

  def approved!
    update_attributes(accepted_at: Time.current)

    if requestor_type_name == 'student'
      self.class.pending.select { |j| j.requestor_id == requestor_id }.each(&:destroy)
    end

    joinable.public_send("add_#{requestor_type_name}", requestor)
  end

  def approved?
    !!accepted_at
  end

  def declined!
    update_attributes(declined_at: Time.current)
  end

  def declined?
    !!declined_at
  end

  def pending?
    not approved? and not declined?
  end

  def status
    if approved?
      "Accepted"
    elsif declined?
      "Declined"
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
    if accepted_at_changed? or declined_at_changed?
      TeamMailer.public_send("#{requestor_type_name}_join_request_#{status.underscore}", self).deliver_later
    end
  end
end
