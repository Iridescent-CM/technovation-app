desc "Update accounts in Portugal to have the correct state_province location data"
task update_portugal_state_province_data: :environment do
  # City State - 03 - Braga
  braga_account_ids = %w[
    143019 168021
  ]

  Account.where(id: braga_account_ids).update_all(state_province: "Braga", country: "PT")

  #################################################################################################

  # City State - 05 - Castelo Branco
  castelo_branco_account_ids = %w[
    162531
  ]

  # Account.where(id: castelo_branco_account_ids).update_all(state_province: "Castelo Branco", country: "PT")

  #################################################################################################

  # City State - 11 - Lisbon
  lisbon_account_ids = %w[
    166909 165124 166201 167366
  ]

  Account.where(id: lisbon_account_ids).update_all(state_province: "Lisbon", country: "PT")

  #################################################################################################

  # City State - 13 - Porto
  porto_account_ids = %w[
    161967 161971
  ]

  Account.where(id: porto_account_ids).update_all(state_province: "Porto District", country: "PT")

  #################################################################################################

  # City State - 14 - Santarém
  santarem_district_account_ids = %w[
    156060
  ]

  # Account.where(id: santarem_district_account_ids).update_all(state_province: "Santarém District", country: "PT")

  #################################################################################################

  # City State - 15 - Setubal
  setubal_account_ids = %w[
    163739
  ]

  # Account.where(id: setubal_account_ids).update_all(state_province: "Setubal", country: "PT")

end

desc "Update accounts in Portugal to have the correct city location data"
task update_portugal_city_data: :environment do
  lisboa_account_ids = %w[
    166909 165124 166201 167366
  ]

  Account.where(id: lisboa_account_ids).update_all(city: "Lisbon")
end
