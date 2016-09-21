require './lib/legacy/models/team_request'
require 'aws-sdk'

module Legacy
  class User < LegacyModel
    include FlagShihTzu

    has_attached_file :avatar,
                      storage: :s3,
                      url: ':s3_domain_url',
                      s3_credentials: ->(a) { a.instance.s3_credentials },
                      path: "/users/:attachment/:id_partition/:style/:filename"


    enum role: [:student, :mentor, :coach, :judge]

    has_many :team_requests, -> { where(approved: true) }
    has_many :teams, through: :team_requests

    def parent_name
      name = [parent_first_name, parent_last_name].join(" ")
      name.blank? ? "N/A" : name
    end

    def migrated_home_state
      home_state.blank? ? "N/A" : home_state
    end

    def type
      self.role = "mentor" if role == "coach"
      "#{role.capitalize}Account"
    end

    def age
      now = Time.current.utc.to_date

      current_month_after_birth_month = now.month > birthday.month
      current_month_is_birth_month = now.month == birthday.month
      current_day_is_on_or_after_birthday = now.day >= birthday.day

      extra_year = (current_month_after_birth_month ||
                      (current_month_is_birth_month &&
                        current_day_is_on_or_after_birthday)) ? 0 : 1

      now.year - birthday.year - extra_year
    end

    EXPERTISES = [
      {sym: :science, abbr: 'Sci'},
      {sym: :engineering, abbr: 'Eng'},
      {sym: :project_management, abbr: 'PM'},
      {sym: :finance, abbr: 'Fin'},
      {sym: :marketing, abbr: 'Mktg'},
      {sym: :design, abbr: 'Dsn'},
    ]

    has_flags 1 => EXPERTISES[0][:sym],
              2 => EXPERTISES[1][:sym],
              3 => EXPERTISES[2][:sym],
              4 => EXPERTISES[3][:sym],
              5 => EXPERTISES[4][:sym],
              6 => EXPERTISES[5][:sym],
              :column => 'expertise'
  end
end
