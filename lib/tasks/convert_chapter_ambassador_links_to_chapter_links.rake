desc "Convert Chapter Ambassador Links to Chapter Links"
task convert_chapter_ambassador_links_to_chapter_links: :environment do
  chapter_ambassadors_with_chapter_links = ChapterAmbassadorProfile
    .joins(:account, :regional_links)
    .where.not(chapter: nil)
    .distinct

  if chapter_ambassadors_with_chapter_links.present?
    chapter_ambassadors_with_chapter_links.find_each do |chapter_ambassador|
      links_count = chapter_ambassador.regional_links.count

      chapter_ambassador.regional_links.update_all(
        chapter_ambassador_profile_id: nil,
        chapter_id: chapter_ambassador.chapter_id
      )

      puts "Converted #{links_count} #{"link".pluralize(links_count)} for #{chapter_ambassador.account.full_name}"
    end
  else
    puts "No chapter ambassador links to convert"
  end
end
