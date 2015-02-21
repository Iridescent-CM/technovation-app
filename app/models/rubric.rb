class Rubric < ActiveRecord::Base
	belongs_to :team
	has_one :judge
	validates_presence_of :competition

end
