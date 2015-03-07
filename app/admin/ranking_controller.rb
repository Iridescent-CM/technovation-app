class RankingController < ActionController::Base

	def self.mark_semifinalists
		## 1 team moves on if < 10 people
		## 2 teams move on if 11 - 20 people

		## for every event
		## calculate number of teams advancing
		## sort the teams by the top average score
		
	end

	def self.mark_finalists
		## the top N scores per region
		for r in Team.regions
			num = num_finalists(r)
			binding.pry
		end
	end

	def self.mark_winners
		## 1 hs winner and 1 ms winner
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