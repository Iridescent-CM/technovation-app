require "./app/technovation/background_check"

module BackgroundCheck
  class Candidate
    extend BackgroundCheck

    attr_reader :id, :candidate

    def initialize(attributes)
      candidate_attributes = default_attributes.merge(attributes)
      @candidate = self.class.candidate_class.new(candidate_attributes)
    end

    def self.resource_name
      "candidates"
    end

    def submit
      resp = self.class.api_class.request(:post,
                                          self.class.request_path,
                                          candidate.attributes)
      @id = resp.fetch(:id)
    end

    private
    def default_attributes
      {
        no_middle_name: false,
        copy_requested: false,
      }
    end

    def self.candidate_class
      Checkr::Candidate
    end
  end
end
