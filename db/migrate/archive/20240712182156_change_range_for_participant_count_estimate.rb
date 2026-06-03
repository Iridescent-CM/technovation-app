class ChangeRangeForParticipantCountEstimate < ActiveRecord::Migration[6.1]
  def up
    ParticipantCountEstimate.find_by(range: "20 - 50").update(range: "15 - 50")
  end

  def down
    ParticipantCountEstimate.find_by(range: "15 - 50").update(range: "20 - 50")
  end
end
