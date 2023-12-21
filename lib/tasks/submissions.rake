namespace :submissions do
  desc "Find submitted apps that aren't considered complete"
  task submitted_but_incomplete: :environment do
    puts

    ids = []
    TeamSubmission.current.complete.find_each do |sub|
      if !sub.complete?
        ids << sub.id
        puts "#{sub.id}: #{sub.friendly_id}"
      end
    end

    puts "\nYou can run submissions:unsubmit![#{ids.join(",")}] to fix this."
  end

  desc "Unsubmits submissions specified by id(s)"
  task unsubmit!: :environment do |t, args|
    TeamSubmission.current.where(id: args.extras).update(published_at: nil)
  end
end
