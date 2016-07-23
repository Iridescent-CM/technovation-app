class JoinRequest < ActiveRecord::Base
  belongs_to :requestor, polymorphic: true
  belongs_to :joinable, polymorphic: true

  delegate :name, to: :joinable, prefix: true

  def status
    if !!accepted_at
      "Accepted"
    elsif !!rejected_at
      "Rejected"
    else
      "Pending review"
    end
  end
end
