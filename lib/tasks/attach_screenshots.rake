desc "Attach screenshot data from lib/screenshots.json"
task attach_screenshots: :environment do
  screenshots = JSON.parse(File.read("./lib/screenshots.json"))

  screenshots.each do |screenshot|
    submission = TeamSubmission.find(screenshot["team_submission_id"])

    submission.screenshots.create!({
      sort_position: screenshot["sort_position"],
      remote_image_url: screenshot["image"]["url"]
    })
  end
end
