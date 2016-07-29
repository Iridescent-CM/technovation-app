module BackgroundCheck
  class Candidate
    attr_reader :id, :candidate

    def self.request_path
      "/#{api_version}/candidates"
    end

    def initialize(attributes)
      candidate_attributes = default_attributes.merge(attributes)
      @candidate = self.class.candidate_class.new(candidate_attributes)
    end

    def submit
      self.class.api_class.request(:post,
                                   self.class.request_path,
                                   candidate.attributes)
    end

    private
    def default_attributes
      {
        no_middle_name: false,
        copy_requested: false,
      }
    end

    def self.api_version
      "v1"
    end

    def self.api_class
      Checkr
    end

    def self.candidate_class
      Checkr::Candidate
    end
  end
end
