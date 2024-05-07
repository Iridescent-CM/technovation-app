class PopulateParticipantCountEstimates < ActiveRecord::Migration[6.1]
  def up
    ParticipantCountEstimate.create(range: "20 - 50", order: 1)
    ParticipantCountEstimate.create(range: "50 - 100", order: 2)
    ParticipantCountEstimate.create(range: "100 - 200", order: 3)
    ParticipantCountEstimate.create(range: "200 - 500", order: 4)
    ParticipantCountEstimate.create(range: "500+", order: 5)
  end

  def down
    ParticipantCountEstimate.delete_all
  end
end
