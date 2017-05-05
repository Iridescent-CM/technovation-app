namespace :scores do
  desc "Set all nil to 0"
  task default_nil_to_zero: :environment do
    SubmissionScore.find_each do |score|
      score.attributes.each do |k, v|
        next if k.match(/comment/)
        next if k == "id"
        next if k.match(/_at$/)
        next if k.match(/_id$/)
        score[k] = 0 if v.nil?
      end

      score.save!
    end

    SubmissionScore.find_each do |score|
      score.attributes.each do |k, v|
        score[k] = nil if k.match(/comment/) && v == "0"
      end

      score.save!
    end
  end

  desc "Update all averages for completed scores"
  task set_average_of_completed: :environment do
    TeamSubmission.find_each do |ts|
      ts.update_average_scores
      ts.reload
      puts "Updated #{ts.app_name} averages to"
      puts "    quarterfinals: #{ts.quarterfinals_average_score}"
      #puts "       semifinals: #{ts.semifinals_average_score}"
    end
  end
end
