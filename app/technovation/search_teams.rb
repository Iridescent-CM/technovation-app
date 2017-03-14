require 'will_paginate/array'

module SearchTeams
  def self.call(filter)
    teams = Team.current

    unless filter.text.blank?
      sanitized_text = sanitize_string_for_elasticsearch_string_query(filter.text)

      results = teams.search({
        query: {
          query_string: {
            query: "*#{sanitized_text}*"
          },
        },
        from: 0,
        size: 10_000
      }).results

      teams = teams.where(id: results.flat_map { |r| r._source.id })
    end

    divisions = Division.where(name: filter.division_enums)
    teams = teams.where(division: divisions)

    teams = case filter.has_mentor
            when true
              teams.joins(:mentors)
            when false
              teams.joins(:mentors).where("memberships.member_id IS NULL")
            else
              teams
            end

    teams = case filter.user.class.name
            when "StudentProfile"
              teams.accepting_student_requests
            when "MentorProfile"
              teams.accepting_mentor_requests
            else
              teams
            end

    miles = filter.nearby == "anywhere" ? 40_000 : 50
    nearby = filter.nearby == "anywhere" ? filter.user.address_details : filter.nearby

    if filter.user.country == "PS"
      nearby = "Palestine"
    end

    teams = teams.near(nearby, miles)

    if filter.spot_available
      teams.includes(
        :pending_student_invites,
        :pending_student_join_requests,
        :students,
        :mentors,
      )
        .references(:memberships)
        .select(&:spot_available?)
    else
      teams
    end
  end

  def self.sanitize_string_for_elasticsearch_string_query(str)
    # Escape special characters
    # http://lucene.apache.org/core/old_versioned_docs/versions/2_9_1/queryparsersyntax.html#Escaping Special Characters
    escaped_characters = Regexp.escape('\\+-&|!(){}[]^~*?:\/')
    str = str.gsub(/([#{escaped_characters}])/, '\\\\\1')

    # AND, OR and NOT are used by lucene as logical operators. We need
    # to escape them
    ['AND', 'OR', 'NOT'].each do |word|
      escaped_word = word.split('').map {|char| "\\#{char}" }.join('')
      str = str.gsub(/\s*\b(#{word.upcase})\b\s*/, " #{escaped_word} ")
    end

    # Escape odd quotes
    quote_count = str.count '"'
    str = str.gsub(/(.*)"(.*)/, '\1\"\3') if quote_count % 2 == 1

    str
  end
end
