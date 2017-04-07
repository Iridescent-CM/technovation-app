class BackgroundCheck::Report
  attr_accessor :id, :status, :candidate_id

  def initialize(attributes = {})
    required_keys.each do |key|
      send("#{key}=", attributes[key])
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
    resp = BackgroundCheck.post(
      :reports,
      {
        package: "tasker_standard",
        candidate_id: candidate_id,
      }
    )
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

  private
  def required_keys
    [:id, :status, :candidate_id]
  end
end
