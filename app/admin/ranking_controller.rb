class RankingController < ActionController::Base

  def self.take_with_ties(arr, n)
    if n >= arr.length
      return arr
    end

    score_needed = arr[n-1].avg_score
    return arr.keep_if{|team| team.avg_score >= score_needed}
  end

  def self.mark_semifinalists
    ## 1 team moves on if <= 10 people
    ## 2 teams move on if 11 - 20 people

    ## for every event
    ## calculate number of teams advancing
    ## sort the teams by the to p average score

    Team.update_all(is_semi_finalist:false)
    for e in Event.all
      teams = e.teams.joins(:rubrics).uniq
      num_teams = [0, (teams.length-1)/10 + 1].max

      winners = take_with_ties(teams.sort_by(&:avg_quarterfinal_score).reverse, num_teams).each { |w|
        w.update(is_semi_finalist: true)
      }
    end
  end

  def self.mark_finalists
    ## the top N scores per region
    Team.update_all(is_finalist:false)
    Region.all.each do |r|
      num_teams = r.num_finalists

      team_list_semifinals = Team.joins(:rubrics).where(is_semi_finalist:true, rubrics: { stage: Rubric.stages[:semifinal] }).has_region(r.id).uniq.sort_by(&:avg_score).reverse
      team_list_finals = take_with_ties(team_list_semifinals, r.num_finalists)
      winners = team_list_finals.each { |w| w.update(is_finalist:true)}
    end
  end

  def self.mark_winners
    Team.update_all(is_winner:false)

    take_with_ties(Team.joins(:region).where(is_finalist: true, regions: { division: Region.divisions[:hs] }).sort_by(&:avg_final_score).reverse, 1).each{ |w| w.update(is_winner:true) }
    take_with_ties(Team.joins(:region).where(is_finalist: true, regions: { division: Region.divisions[:ms] }).sort_by(&:avg_final_score).reverse, 1).each{ |w| w.update(is_winner:true) }

  end

  def self.toggle_score_visibility(stage)
    ## how are the settings stored?
    setting = Setting.find_by_key!(stage+'ScoresVisible')
    setting.update(value: setting.value == 'true' ? 'false': 'true')
  end

  def self.assign_judges_to_regions
    judges = User.all.where.not(home_country: 'BR').find_all { |u| u.can_judge? }
    valid_teams = Team.where(year: Setting.year).where("division in (0,1)").where.not(country: 'BR')
    assign_judges_to_region_to_world(judges, valid_teams)

    judges = User.where(home_country: "BR").find_all { |u| u.can_judge? }
    valid_teams = Team.where(year: Setting.year).where("division in (0,1)").where(country: 'BR')
    assign_judges_to_region_to_world(judges, valid_teams)
  end

  def self.assign_judges_to_region_to_world(judges, teams)
    region_requirements = teams.group(:region_id).count
    multiplier = judges.count.fdiv(teams.count)
    region_requirements = region_requirements.each_with_object({}) { |(region, count), h| h[region] = (count * multiplier).floor }
    virtual_judging_id = Event.virtual_for_current_season.id
    free_judges = []
    judges.each do |user|
      if user.event_id == nil or user.event_id == virtual_judging_id
        free_judges << user
      else
        assign_judge(user, Event.find(user.event_id).region, region_requirements)
      end
    end

    free_judges.each do |user|
      valid_regions = region_requirements.keys - user.conflict_region_ids
      unless valid_regions.empty?
        assign_judge(user, Region.find(valid_regions.sample), region_requirements)
      end
    end
  end

  private

  def self.assign_judge(judge, judging_region, region_requirements)
    if judging_region
      Rails.logger.info("Assing judge #{judge.id} #{judge.name} to region #{judging_region.id} #{judging_region.name}")
      judge.update(judging_region: judging_region)
      if region_requirements.has_key?(judging_region.id)
        region_requirements[judging_region.id] = region_requirements[judging_region.id] - 1
        if region_requirements[judging_region.id] <= 0
          region_requirements.delete(judging_region.id)
        end
      end
    end
  end
end
