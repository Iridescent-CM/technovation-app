class Rubric < ActiveRecord::Base
	belongs_to :team
	belongs_to :judge

	validates_presence_of :competition, :identify_problem, :address_problem, :functional, :external_resources, :match_features, :interface, :description, :market, :competition, :revenue, :branding, :pitch

end
