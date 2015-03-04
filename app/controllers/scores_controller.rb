class ScoresController < ApplicationController

	def index
		## send in a hash from team name to rubrics
		@hash = {}
		for t in current_user.teams
			@hash[t.name] = Rubric.where("team_id = '#{t.id}'")
		end
	end
end
