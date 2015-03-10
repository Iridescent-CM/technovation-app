class Rubric < ActiveRecord::Base
	belongs_to :team
	belongs_to :user

	validates_presence_of :competition, :identify_problem, :address_problem, :functional, :external_resources, :match_features, :interface, :description, :market, :competition, :revenue, :branding, :pitch

	before_save :calculate_score

	enum stage: [
	:quarterfinals,
	:semifinals,
	:finals,
	]

  	scope :has_judge, -> (user) {where('user_id = ?', user.id)}
  	scope :has_team, -> (team) {where('team_id = ?', team.id)}

	def calculate_score
		score = 0
		points = [:identify_problem, :address_problem, :functional, :external_resources, :match_features, :interface, :description, :market, :competition, :revenue, :branding, :pitch]
		points.each { |p| score += self[p]}

		if self.launched
		  score += 2
		end

		# deduct points for missing components
		deductions = [:pitch, :demo, :code, :description, :plan]
		deductions.each{ |d| 
		  if (self.team.missing_field?(d.to_s))
		    score -= 1
		  end
		}

		deductions = [:screenshot1, :screenshot2, :screenshot3, :screenshot4, :screenshot5]
		if deductions.map{|d| self.team.missing_field?(d.to_s)}.all?
		  ## if all screenshots are missing then deduct 1 pt
		  score -= 1
		end

		self.score = score
	end

end
