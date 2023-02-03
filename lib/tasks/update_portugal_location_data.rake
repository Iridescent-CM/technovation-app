desc "Update accounts in Portugal to have the correct state_province location data"
task update_portugal_state_province_data: :environment do
  # City State - 03 - Braga
  braga_account_ids = %w[
    143019 164571 138872
  ]

  Account.where(id: braga_account_ids).update_all(state_province: "Braga", country: "PT")

  #################################################################################################

  # City State - 05 - Castelo Branco
  castelo_branco_account_ids = %w[
    162531
  ]

  Account.where(id: castelo_branco_account_ids).update_all(state_province: "Castelo Branco", country: "PT")

  #################################################################################################

  # City State - 11 - Lisbon
  lisbon_account_ids = %w[
    162283 153563 159317 159719 159729 157827 159755 159774 163151 159872 159933 159936 163242 160112 160113 160114 160118 138840 160119 160120 160170 160289 160570 163894 160711 160715 160716 160721 160726 160725 160764 160771 160762 160773 160763 160774 160833 160972 160980 159829 161238 161286 164504 161358 164911
  ]

  Account.where(id: lisbon_account_ids).update_all(state_province: "Lisbon", country: "PT")

  #################################################################################################

  # City State - 13 - Porto
  porto_account_ids = %w[
    162639 162886 157641 137117
  ]

  Account.where(id: porto_account_ids).update_all(state_province: "Porto District", country: "PT")

  #################################################################################################

  # City State - 14 - Santarém
  santarem_district_account_ids = %w[
    156060
  ]

  Account.where(id: santarem_district_account_ids).update_all(state_province: "Santarém District", country: "PT")

  #################################################################################################

  # City State - 15 - Setubal
  setubal_account_ids = %w[
    163739
  ]

  Account.where(id: setubal_account_ids).update_all(state_province: "Setubal", country: "PT")

end

desc "Update accounts in Portugal to have the correct city location data"
task update_portugal_city_data: :environment do
  lisboa_account_ids = %w[
    159317 159719 159729 159755 159774 163151 159872 160112 160113 160114 160118 160119 160120 160170 160289 160570 163894 160711 160715 160716 160721 160726 160725 160764 160771 160762 160773 160763 160774 160833 160972 160980 159829 161238 161286 164504 161358
  ]

  Account.where(id: lisboa_account_ids).update_all(city: "Lisbon")
end
