class Event < ActiveRecord::Base
	has_many :teams

	## duplicated from team.rb since we need to render region from Event's admin panel
	enum region: [
	:ushs, # High School - US/Canada
	:mexicohs, # High School - Mexico/Central America/South America
	:europehs, #High School - Europe/Australia/New Zealand/Asia
	:africahs, #High School - Africa
	:usms, #Middle School - US/Canada
	:mexicoms, #Middle School - Mexico/Central America/South America/Africa
	:europems, #Middle School - Europe/Australia/New Zealand/Asia
	]

	scope :open_for_signup, -> {where 'whentooccur >= ?', Setting.now + 1.week}

end
