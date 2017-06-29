require 'will_paginate/array'
require 'elasticsearch/dsl'

module SearchTeams
  EARTH_CIRCUMFERENCE = 24_901

  def self.call(filter)
    teams = Team.current

    if use_search_index(filter)
      query = Elasticsearch::DSL::Search.search do |q|
        q.query do |qq|
          qq.bool do |bl|
            unless filter.text.blank?
              bl.must do |m|
                m.query_string do |qs|
                  qs.query sanitize_string_for_elasticsearch_string_query(filter.text)
                end
              end
            end

            if filter.spot_available
              bl.must do |m|
                m.term spot_available?: true
              end
            end
          end
        end

        q.from 0
        q.size 10_000
      end

      results = teams.search(query).results
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

    teams = case filter.scope
            when "student"
              teams.accepting_student_requests
            when "mentor"
              teams.accepting_mentor_requests
            else
              teams
            end

    miles = filter.nearby == "anywhere" ? EARTH_CIRCUMFERENCE : 100
    nearby = filter.nearby == "anywhere" ? filter.location : filter.nearby

    if filter.country == "PS"
      nearby = "Palestine"
    end

    teams.near(nearby, miles)
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

  def self.use_search_index(filter)
    not filter.text.blank? or filter.spot_available
  end
end
