class BackgroundCheck::Report
  attr_accessor :id, :object, :uri, :status, :created_at, :completed_at,
    :upgraded_at, :turnaround_time, :package, :tags, :candidate_id, :ssn_trace_id,
    :sex_offender_search_id, :national_criminal_search_id, :federal_criminal_search_id,
    :county_criminal_search_ids, :motor_vehicle_report_id, :state_criminal_search_ids,
    :document_ids, :due_time, :adjudication, :global_watchlist_search_id,
    :personal_reference_verification_ids, :professional_reference_verification_ids,
    :terrorist_watchlist_search_id

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end

  def self.retrieve(id)
    return NoReport.new if id.blank?
    begin
      resp = BackgroundCheck.get(:reports, id)
      new(resp)
    rescue
      NoReport.new
    end
  end

  def submit
    resp = BackgroundCheck.post(:reports, { package: "tasker_standard", candidate_id: candidate_id })
    @id = resp.fetch(:id)
  end

  class NoReport
    def status
      "Not submitted"
    end

    def present?
      false
    end
  end
end
