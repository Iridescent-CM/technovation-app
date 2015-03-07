class RankingController < ActionController::Base

	def self.mark_semifinalists
		## 1 team moves on if < 10 people
		## 2 teams move on if 11 - 20 people

		## for every event
		## calculate number of teams advancing
		## sort the teams by the top average score
		
	end

	def self.mark_finalists
	end

	def self.mark_winners
	end

	def self.number_finalists(region, division)
		# High School
		# US/Canada - 3 finalists
		# Mexico/Central America/South America - 1 
		# Europe/Australia/New Zealand/Asia - 1
		# Africa - 1 

		# Middle School
		# US/Canada - 2
		# Mexico/Central America/South America/Africa - 1
		# Europe/Australia/New Zealand/Asia - 1		
	end

	
	# def self.batch_ready?(event)
	# 	## returns true if all submissions have at least 3 scores
	# end

	## we don't have fine enough location information to do this
	# def assign_event(region, event)
	# 	## assign unassigned(?)
	# end

end