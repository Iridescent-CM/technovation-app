require 'csv'
require 'securerandom'


STATES = {
  "Alabama" => "AL",
  "Alaska" => "AK",
  "Arizona" => "AZ",
  "Arkansas" => "AR",
  "California" => "CA",
  "Colorado" => "CO",
  "Connecticut" => "CT",
  "Delaware" => "DE",
  "Florida" => "FL",
  "Georgia" => "GA",
  "Hawaii" => "HI",
  "Idaho" => "ID",
  "Illinois" => "IL",
  "Indiana" => "IN",
  "Iowa" => "IA",
  "Kansas" => "KS",
  "Kentucky" => "KY",
  "Louisiana" => "LA",
  "Maine" => "ME",
  "Maryland" => "MD",
  "Massachusetts" => "MA",
  "Michigan" => "MI",
  "Minnesota" => "MN",
  "Mississippi" => "MS",
  "Missouri" => "MO",
  "Montana" => "MT",
  "Nebraska" => "NE",
  "Nevada" => "NV",
  "New Hampshire" => "NH",
  "New Jersey" => "NJ",
  "New Mexico" => "NM",
  "New York" => "NY",
  "North Carolina" => "NC",
  "North Dakota" => "ND",
  "Ohio" => "OH",
  "Oklahoma" => "OK",
  "Oregon" => "OR",
  "Pennsylvania" => "PA",
  "Rhode Island" => "RI",
  "South Carolina" => "SC",
  "South Dakota" => "SD",
  "Tennessee" => "TN",
  "Texas" => "TX",
  "Utah" => "UT",
  "Vermont" => "VT",
  "Virginia" => "VA",
  "Washington" => "WA",
  "Washington, D.C." => "DC",
  "West Virginia" => "WV",
  "Wisconsin" => "WI",
  "Wyoming" => "WY",
}

PROVINCES = {
  "Ontario" => "ON",
  "Quebec" => "QC",
  "Nova Scotia" => "NS",
  "New Brunswick" => "NB",
  "Manitoba" => "MB",
  "British Columbia" => "BC",
  "Prince Edward Island" => "PE",
  "Saskatchewan" => "SK",
  "Alberta" => "AB",
  "Newfoundland and Labrador" => "NL",
}


def referral_details(heard, details)

  if heard.nil?
    return nil, nil
  end

  h = heard.downcase
  if h.include? 'friend'
    return :friend, details
  elsif h.include? 'web search'
    return :web_search, details
  elsif h.include? 'teacher'
    return :teacher, details
  elsif h.include? 'parent'
    return :parent_family, details
  elsif h.include? 'other:'
    return :other, heard[h.index('other:') + 6 .. -1].strip
  else
    return :other, heard
  end
end

def import_users(role, file)
  emails = Set.new()
  CSV.foreach(file, :headers => true) do |row|
    email = row["Student Email"] || row["Email"]
    if emails.include?(email)
      puts 'Dup Detected'
    else
      password = SecureRandom.hex[0..10]
      heard =
        row["How did you hear about Technovation? (check all that apply)"] or
        row["How did you hear about Technovation?"]
      details =
        row["Please specify the person or source"] or
        row["Please specify the person or source."]
      h, d = referral_details(heard, details)

      skills = row["What does your skill set include? (check all that apply)"]

      user = User.new(
        role: role,
        email: email,
        first_name: (row['Student Name (First)'] or row['Name (First)']).strip.titleize,
        last_name: (row['Student Name (Last)'] or row['Name (Last)']).strip.titleize,
        birthday: Date.strptime((row["Student Birthdate"] or "01/01/1970"), "%m/%d/%Y"),

        password: password,
        password_confirmation: password,

        school: (
          row["What is the name of the school you (the student) attend?"] or
          row["If you are affiliated with a specific school or organization, please enter it here."] or
          row["Place of Employment"] or
          "Unknown"
        ),

        parent_first_name: row["Parent/Legal Guardian Name (First)"],
        parent_last_name: row["Parent/Legal Guardian Name (Last)"],
        parent_email: row["Parent/Legal Guardian Email"],

        home_city: (row["In what city/town are you located?"] or row["In what city/town do you live?"]),
        home_state: STATES[row["State"]] || PROVINCES[row["Province"]],
        home_country: 
          Country.find_country_by_name(
            (row["In what country are you located?"] or row["In what country do you live?"])
          ).alpha2,
        postal_code: row["Zip/Postal Code"].strip,

        connect_with_other: (
          row["Would you be willing to connect with another teacher/parent who's interested in coaching?"] == 'Yes' or
          row["Would you be willing to connect with another individual is new to mentoring?"] == 'Yes'
        ),

        referral_category: h,
        referral_details: d,
      )

      unless skills.nil?
        skills.downcase!

        user.science = skills.include?('math')
        user.engineering = skills.include?('software') or skills.include?('engineering') or skills.include?('tech')
        user.project_management = skills.include?('management') or skills.include?('business') or skills.include?('entrepreneurship')
        user.marketing = skills.include?('media')
        user.design = skills.include?('design') or skills.include?('seo')
      end


      user.skip_confirmation!
      user.skip_parent_email = true
      unless user.save
        puts "ERROR: #{user.email}, #{user.errors.to_a}"
      else
        puts "#{user.id}, #{user.email}, #{user.name}, #{password}"
      end
      emails.add(email)
    end
  end
end

namespace :import do
  desc 'import students from the student csv'
  task :student => [:environment] do
    import_users :student, "import/students.csv"
  end

  desc 'import mentors from the mentor csv'
  task :mentor => [:environment] do
    import_users :mentor, "import/mentors.csv"
  end

  desc 'import coaches from the coach csv'
  task :coach => [:environment] do
    import_users :coach, "import/coaches.csv"
  end

end