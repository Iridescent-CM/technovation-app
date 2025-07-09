desc "Convert Chapter Ambassador Community Connections"
task convert_chapter_ambassador_community_connections: :environment do
  CommunityConnection
    .where.not(chapter_ambassador_profile_id: nil)
    .update_all("ambassador_id = chapter_ambassador_profile_id, ambassador_type = 'ChapterAmbassadorProfile'")

  puts "Updated chapter ambassador community connections"
end
