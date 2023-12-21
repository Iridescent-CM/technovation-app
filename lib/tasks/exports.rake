namespace :exports do
  task cleared_us_mentors_2017: :environment do
    ExportJob.perform_now(AdminProfile.first.id, "AdminProfile", {
      class: "account",
      export_email: "joe@iridescentlearning.org",
      type: "Mentor",
      cleared_status: "Clear",
      season: 2017,
      country: "US"
    })
  end
end
