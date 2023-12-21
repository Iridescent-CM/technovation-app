desc "Apply seasoning to judge assignments"
task season_judge_assignments: :environment do
  JudgeAssignment.find_each do |assignment|
    assignment.update_column(:seasons, assignment.team.seasons)
  end
end
