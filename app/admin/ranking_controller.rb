class RankingController < ActionController::Base

	def self.mark_semifinalists
		## 1 team moves on if <= 10 people
		## 2 teams move on if 11 - 20 people

		## for every event
		## calculate number of teams advancing
		## sort the teams by the to p average score

		# http://stackoverflow.com/questions/19339140/ruby-on-rails-order-users-based-on-average-ratings-with-most-reviews
		#Team.joins(:rubrics).select("teams.id, AVG(rubrics.score) as avg_score, count(rubrics.id) as num_rubrics").group("teams.id").order("avg_score DESC")

		# Team.update_all(issemifinalist:false)
		# for e in Event.all
		# 	num_teams = [0, (e.teams.length-1)/10 + 1].max
		# 	winners = Team.where(event_id: e.id).joins(:rubrics).select("teams.id, AVG(rubrics.score) as avgscore").group("teams.id").order("avgscore DESC").limit(num_teams)
		# 	winners.update_all(issemifinalist:true)
		# end

		Team.update_all(issemifinalist:false)
		for e in Event.all
			num_teams = [0, (e.teams.length-1)/10 + 1].max
			winners = e.teams.sort_by(&:avg_score).reverse.take(num_teams).each { |w|
				w.update(issemifinalist: true)				
			}
		end
	end

	def self.mark_finalists
		## the top N scores per region
		Team.update_all(isfinalist:false)
		for r in Team.regions
			num_teams = self.num_finalists(r)
			region_id = Team.regions[r]
			winners = Team.where(issemifinalist:true).has_region(region_id).sort_by(&:avg_score).reverse.take(num_teams).each { |w|
				w.update(isfinalist:true)
			}
		end
	end

	def self.mark_winners
		## 1 hs winner and 1 ms winner
		hs = ['ushs', 'mexicohs', 'europehs', 'africahs'].map{|x| Team.regions[x]}
		ms = ['usms', 'mexicoms', 'europems'].map{|x| Team.regions[x]}

		Team.update_all(iswinner:false)
		Team.where(isfinalist: true, region: hs).sort_by(&:avg_score).reverse.take(1).each{ |w| w.update(iswinner:true) }
		Team.where(isfinalist: true, region: ms).sort_by(&:avg_score).reverse.take(1).each{ |w| w.update(iswinner:true) }
	end

	def self.num_finalists(region)
		case region[0].to_sym
		when :ushs
		  3
		when :mexicohs
		  1
		when :europehs
		  1    
		when :africahs
		  1
		when :usms
		  2
		when :mexicoms
		  1
		when :europems
		  1
		else
		  "Error"
		end
	end

	def self.toggle_score_visibility(stage)
		## how are the settings stored?
		setting = Setting.find_by_key!(stage+'ScoresVisible')
		setting.update(value: setting.value == 'true' ? 'false': 'true')
	end




	def self.assign_judges_to_regions
    judges = User.all.find_all { |u| u.can_judge? }
    valid_teams = Team.where("division in (0,1) and country != 'BR'")
    region_requirements = valid_teams.group(:region).count
    multiplier = judges.count.fdiv(valid_teams.count)
    region_requirements = region_requirements.each_with_object({}) { |(region, count), h| h[region] = (count * multiplier).floor }

    virtual_judging_id = Event.find_by(name: 'Virtual Judging').id

    free_judges = []
    User.all.each do |user|
      if user.can_judge?
        if user.event_id == nil or user.event_id == virtual_judging_id
          free_judges << user
        else
          assign_judge(user, Event.regions[Event.find(user.event_id).region], region_requirements)
        end
      end
    end

    free_judges.each do |user|
      valid_regions = region_requirements.keys - user.conflict_regions

      if valid_regions.length == 0
        valid_regions = Team.distinct.pluck(:region) - user.conflict_regions
      end

      assign_judge(user, valid_regions.sample, region_requirements)
    end
	end

  private

  def self.assign_judge(judge, judging_region, region_requirements)
    judge.update(judging_region: judging_region)
    if region_requirements.has_key?(judging_region)
      region_requirements[judging_region] = region_requirements[judging_region] - 1
      if region_requirements[judging_region] <= 0
        region_requirements.delete(judging_region)
      end
    end
  end
end