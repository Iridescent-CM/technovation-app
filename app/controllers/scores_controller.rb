class ScoresController < ApplicationController

	def index
		## send in a hash from team name to rubrics
		@hash = {}
		for t in current_user.teams
			rubrics = Rubric.where("team_id = '#{t.id}'")
			@hash[t.name] = rubrics
		end
	end
end
