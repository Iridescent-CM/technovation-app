module SearchMentors
  def self.call(filter)
    mentors = MentorProfile.searchable(filter.user)

    unless filter.text.blank?
      sanitized_text = sanitize_string_for_elasticsearch_string_query(filter.text)

      results = Account.joins(:mentor_profile)
        .search(
          query: {
            query_string: {
              query: "*#{sanitized_text}*"
            }
          },
          from: 0,
          size: 10_000,
        ).results

      mentors = mentors.where(account_id: results.flat_map { |r| r._source.id })
    end

    if filter.expertise_ids.any?
      mentors = mentors.by_expertise_ids(filter.expertise_ids)
    end

    if filter.gender_identities.any?
      mentors = mentors.by_gender_identities(filter.gender_identities)
    end

    if filter.needs_team
      profile_ids = MentorProfile.where("mentor_profiles.id NOT IN
        (SELECT DISTINCT(member_id) FROM memberships
                                    WHERE memberships.member_type = 'MentorProfile'
                                    AND memberships.joinable_type = 'Team'
                                    AND memberships.joinable_id IN

          (SELECT DISTINCT(id) FROM teams WHERE teams.id IN

            (SELECT DISTINCT(registerable_id) FROM season_registrations
                                              WHERE season_registrations.registerable_type = 'Team'
                                              AND season_registrations.season_id = ?)))", Season.current.id)
        .pluck(:id)

      mentors = mentors.where(id: profile_ids)
    end

    if filter.on_team
      profile_ids = MentorProfile.where("mentor_profiles.id IN
        (SELECT DISTINCT(member_id) FROM memberships
                                    WHERE memberships.member_type = 'MentorProfile'
                                    AND memberships.joinable_type = 'Team'
                                    AND memberships.joinable_id IN

          (SELECT DISTINCT(id) FROM teams WHERE teams.id IN

            (SELECT DISTINCT(registerable_id) FROM season_registrations
                                              WHERE season_registrations.registerable_type = 'Team'
                                              AND season_registrations.season_id = ?)))", Season.current.id)
        .pluck(:id)

      mentors = mentors.where(id: profile_ids)
    end

    if filter.virtual_only
      mentors = mentors.virtual
    end

    miles = filter.nearby == "anywhere" ? 40_000 : 50
    nearby = filter.nearby == "anywhere" ? filter.user.address_details : filter.nearby

    if filter.user.country == "PS"
      nearby = "Palestine"
    end

    mentors.joins(:account).near(nearby, miles)
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
