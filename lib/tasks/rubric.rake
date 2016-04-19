namespace :rubric do
  task create_for_brazil: :environment do
    year = 2016
    country = 'BR'
    regions = [1,5]
    
    Rubric::CreateToBrazil.run!(
      regions: regions,
      country: country,
      year: year
    )
  end
end
