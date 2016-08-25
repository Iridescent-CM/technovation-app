class JoinRequest < ActiveRecord::Base
  after_create :notify_requested_joinable
  after_save :notify_requestor, on: :update

  scope :pending, -> { where('accepted_at IS NULL and declined_at IS NULL') }
  scope :from_students, -> { where(requestor_id: StudentAccount.pluck(:id)) }

  belongs_to :requestor, polymorphic: true
  belongs_to :joinable, polymorphic: true

  delegate :name, to: :joinable, prefix: true
  delegate :full_name, :type_name, :email,
    to: :requestor, prefix: true

  def approved!
    update_attributes(accepted_at: Time.current)
    self.class.pending.from_students.select { |j| j.requestor_id == requestor.id }.each(&:destroy)
    joinable.public_send("add_#{requestor.type_name}", requestor)
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
