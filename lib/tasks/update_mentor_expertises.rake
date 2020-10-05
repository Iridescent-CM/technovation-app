desc "Update mentor expertises"
task update_mentor_expertises: :environment do

  # remove expertises
  science = Expertise.find_by(name: "Science")
  engineering = Expertise.find_by(name: "Engineering")
  finance = Expertise.find_by(name: "Finance")

  science&.mentor_profile_expertises&.delete_all
  science&.delete

  engineering&.mentor_profile_expertises&.delete_all
  engineering&.delete

  finance&.mentor_profile_expertises&.delete_all
  finance&.delete

  # add new expertises
  coding = Expertise.find_or_create_by(name: "Coding")
  java = Expertise.find_or_create_by(name: "Experience with Java")
  swift = Expertise.find_or_create_by(name: "Experience with Swift")
  business = Expertise.find_or_create_by(name: "Business or Entrepreneurship")
  project_management = Expertise.find_or_create_by(name: "Project Management")
  marketing = Expertise.find_or_create_by(name: "Marketing")
  design = Expertise.find_or_create_by(name: "Design")

  coding.update_column(:order, 10)
  java.update_column(:order, 20)
  swift.update_column(:order, 30)
  business.update_column(:order, 40)
  project_management.update_column(:order, 50)
  marketing.update_column(:order, 60)
  design.update_column(:order, 70)
end
