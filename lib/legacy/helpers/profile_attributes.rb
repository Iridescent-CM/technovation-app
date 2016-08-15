module ProfileAttributes
  def self.call(record)
    "profile_attributes/#{record.role}_profile_attributes".camelize.constantize.generate(record)
  end

  module JudgeProfileAttributes
    def self.generate(record)
      {
        company_name: record.school,
        job_title: record.grade.blank? ? "Not specified" : record.grade,
      }
    end
  end

  module StudentProfileAttributes
    def self.generate(record)
      {
        parent_guardian_email: record.parent_email,
        parent_guardian_name: record.parent_name,
        school_name: record.school,
      }
    end
  end

  module MentorProfileAttributes
    def self.generate(record)
      {
        school_company_name: record.school,
        job_title: record.grade.blank? ? "Not specified" : record.grade,
        bio: record.about,
        expertise_ids: Expertise.where("LOWER(name) IN (?)", record.selected_expertise).pluck(:id)
      }
    end
  end
end
