class ScoresController < ApplicationController

	def index

		## todo: make this work for users with multiple teams
		@team = current_user.teams[0]
		@rubrics = Rubric.where("team_id = '"+ @team.id.to_s + "'")

		## grab the associated rubrics
	end
end
