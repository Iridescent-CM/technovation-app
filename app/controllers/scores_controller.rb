class ScoresController < ApplicationController

	def index
		## send in a hash from team name to rubrics
		@hash = {}
		for t in current_user.teams
			## add in visibility
			visible_stages = Setting.scoresVisible.map{|s| Rubric.stages[s]}

			if visible_stages.length > 0
				rubrics = Rubric.where(team_id: t.id, stage: visible_stages)
			end

			@hash[t.name] = rubrics
		end
	end
end
