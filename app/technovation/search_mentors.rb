module SearchMentors
  def self.call(filter)
    mentors = MentorProfile.where.not(account_id: filter.user.account_id)

    unless filter.text.blank?
      sanitized_text = sanitize_string_for_elasticsearch_string_query(filter.text)

      results = Account.joins(:mentor_profile).search(
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

    if filter.nearby.present?
      miles = filter.nearby == "anywhere" ? 40_000 : 50
      nearby = filter.nearby == "anywhere" ? filter.user.address_details : filter.nearby

      account_ids = Account.joins(:mentor_profile)
        .near(nearby, miles)
        .order("distance")
        .select(:id)
        .map(&:id)

      mentors = mentors.where(account_id: account_ids)
    end

    if filter.needs_team
      account_ids = Account.joins(:mentor_profile)
        .where("mentor_profiles.id NOT IN
        (SELECT DISTINCT(member_id) FROM memberships
                                    WHERE memberships.member_type = 'MentorProfile'
                                    AND memberships.joinable_type = 'Team'
                                    AND memberships.joinable_id IN

          (SELECT DISTINCT(id) FROM teams WHERE teams.id IN

            (SELECT DISTINCT(registerable_id) FROM season_registrations
                                              WHERE season_registrations.registerable_type = 'Team'
                                              AND season_registrations.season_id = ?)))", Season.current.id)
        .pluck(:id)

      mentors = mentors.where(account_id: account_ids)
    end

    if filter.virtual_only
      mentors = mentors.virtual
    end

    mentors.searchable(filter.user)
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
