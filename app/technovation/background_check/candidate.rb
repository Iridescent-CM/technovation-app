class BackgroundCheck::Candidate
  attr_reader :id, :candidate

  def initialize(attributes = {})
    attributes["copy_requested"] = attributes["copy_requested"] == "1"
    candidate_attributes = default_attributes.merge(attributes)
    @candidate = Checkr::Candidate.new(candidate_attributes)
  end

  def submit
    resp = BackgroundCheck.post(:candidates, candidate.attributes)
    @id = resp.fetch(:id)
    resp
  end

  private
  def default_attributes
    {
      no_middle_name: true,
    }
  end
end
