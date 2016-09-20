require './lib/legacy/models/legacy_model'
require 'aws-sdk'

module Legacy
  class Team < LegacyModel
    enum division: [:ms, :hs, :x]

    has_many :team_requests, -> { where(approved: true) }
    has_many :users, through: :team_requests

    has_attached_file :avatar,
                      storage: :s3,
                      url: ":s3_domain_url",
                      s3_credentials: ->(a) { a.instance.s3_credentials }

    def migrated_description
      description.blank? ? "No description" : description
    end

    def migrated_division
      case division
      when 'ms'
        Division.junior
      when 'hs'
        Division.senior
      when 'x'
        Division.for(users.first)
      else
        raise "division blank -- #{inspect}"
      end
    end

    def migrated_student_ids
      StudentAccount.where('email IN (?)', users.pluck(:email)).pluck(:id)
    end

    def migrated_mentor_ids
      MentorAccount.where('email IN (?)', users.pluck(:email)).pluck(:id)
    end
  end
end
