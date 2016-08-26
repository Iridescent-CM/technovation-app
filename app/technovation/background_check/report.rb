module BackgroundCheck
  class Report
    attr_reader :id, :candidate

    def self.request_path
      "/#{api_version}/reports"
    end

    def initialize(candidate)
      @candidate = candidate
    end

    def submit
      response = self.class.api_class.request(:post,
                                              self.class.request_path,
                                              { package: "tasker_standard",
                                                candidate_id: candidate.id })
      @id = response.fetch(:id)
    end

    private
    def self.api_version
      "v1"
    end

    def self.api_class
      Checkr
    end
  end
end
