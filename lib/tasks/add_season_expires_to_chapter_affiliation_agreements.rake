desc "Add season expires to chapter affiliation agreements"
task add_season_expires_to_chapter_affiliation_agreements: :environment do
  documents = Document.where(signer_type: "LegalContact", status: "signed")

  documents.update_all("season_expires = season_signed + 2")

  puts "Updated #{documents.count} chapter affiliation agreements"
end
