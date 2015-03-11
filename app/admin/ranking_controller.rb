class RankingController < ActionController::Base

	def self.mark_semifinalists
		## 1 team moves on if <= 10 people
		## 2 teams move on if 11 - 20 people

		## for every event
		## calculate number of teams advancing
		## sort the teams by the top average score

		Team.update_all(issemifinalist:false)
		for e in Event.all
			num_teams = [0, (e.teams.length-1)/10 + 1].max
			winners = e.teams.by_scores.limit(num_teams).update_all(issemifinalist:true)
		end
	end

	def self.mark_finalists
		## the top N scores per region
		Team.update_all(isfinalist:false)
		for r in Team.regions
			num_teams = num_finalists(r)
			region_id = Team.regions[r]
			Team.has_region(region_id).by_scores.limit(num_teams).update_all(isfinalist:true)
		end
	end

	def self.mark_winners
		## 1 hs winner and 1 ms winner
		hs = ['ushs', 'mexicohs', 'europehs', 'africahs'].map{|x| Team.regions[x]}
		ms = ['usms', 'mexicoms', 'europems'].map{|x| Team.regions[x]}

		Team.update_all(iswinner:false)
		Team.where(region: hs).by_scores.first.update_all(iswinner:true)
		Team.where(region: ms).by_scores.first.update_all(iswinner:true)
	end

	def num_finalists(region)
		case region.to_sym
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
	
	# def self.batch_ready?(event)
	# 	## returns true if all submissions have at least 3 scores
	# end

	## we don't have fine enough location information to do this
	# def assign_event(region, event)
	# 	## assign unassigned(?)
	# end

end