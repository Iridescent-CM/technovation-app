namespace :rubric do
	task :create_for_brazil => :environment do
    latin_region_ids  = [1,5]
    judges = User.judges_from('BR')
    regions = Region.where(id: latin_region_ids)
		year = Setting.year

    # Team.by_regions_year_and_country()
    # regions = Region.where(id: [1,5])
    # required_fields = {identify_problem: 0, address_problem: 0, functional: 0, external_resources: 0, match_features: 0, interface: 0, description: 0, market: 0, competition: 0, revenue: 0, branding: 0, pitch: 0, score: 0}
    # attributes = required_fields.meger(user: judgers.first, team: teams.first)
    # Rubric.skip_callback(:save, :before, :calculate_score)
    # Rubric.create!(attributes)


  end
end
