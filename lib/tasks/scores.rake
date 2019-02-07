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

  desc "Update all score summaries for completed submissions"
  task set_score_summaries_of_completed: :environment do
    TeamSubmission.current.complete.find_each do |ts|
      ts.update_score_summaries
      ts.reload
      puts "Updated #{ts.app_name} summaries to"
      puts "  quarterfinals range: #{ts.quarterfinals_score_range}"
      puts "    quarterfinals avg: #{ts.quarterfinals_average_score}"
      puts "     semifinals range: #{ts.semifinals_score_range}"
      puts "       semifinals avg: #{ts.semifinals_average_score}"
    end
  end
end
