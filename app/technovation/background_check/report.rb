require "./app/technovation/background_check"

module BackgroundCheck
  class Report
    extend BackgroundCheck

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

    def self.resource_name
      "reports"
    end

    def self.retrieve(id)
      resp = api_class.request(:get, "#{request_path}/#{id}")
      new(resp)
    end

    def submit
      resp = self.class.api_class.request(:post,
                                          self.class.request_path,
                                          { package: "tasker_standard",
                                            candidate_id: candidate_id })
      @id = resp.fetch(:id)
    end
  end
end
