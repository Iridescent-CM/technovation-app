desc "Update accounts in Spain"
task update_spain_location_data: :environment do
  # andalucía_account_ids = %w[
  #   67650 110754 110796 111856 113465 113577 115577 115990 118654 118748 119176 119227 119499 119518 119565 120466 46067 48560 71671 124698 124701 125124 126419 126420 126994 127933 128569 128580 128822 128825 128828 129083 129085 129086 129096 129168
  # ]

  # Account.where(id: andalucía_account_ids).update_all(state_province: "AN", country: "ES")

  #################################################################################################

  community_of_madrid_account_ids = %w[
    74452 156765 70297 175384 158842 175745 164927 89820 72926 175102 167801 170884 101210 171426 175473 79663 175352 175694 175345 170854 175360 175402 171573 164760 175076 170881 170989 173932 175675 175210 175665 166434 175326 175661 84312 171604 171574 174200 159635 175660 164305 97514 160899 171575 40312 175038 172484 175654 77662 175428 88611 175037 175454 83188 83007 175198 174774 175491 79680 175480 171764 109257 104561 84232 84550 175509 175504 91172 83191 86143 165923 73166 165407 170551 171346 70196 166868 161714 170460 86611 70131 49750 98993 81717 82374 82351 175142 70075 161080 174778 87637 68539 47919 37751 60023 69401 104557 48602 60439 60993 49671 38104 68240 57640 38270
  ]

  Account.where(id: community_of_madrid_account_ids).update_all(state_province: "MD", country: "ES")

  #################################################################################################

  valencian_account_ids = %w[
    24238 59925 45949 42967 69287 69232 165578 158038 161349 89581 166925 166927 166954 162217 166936 166923 110341 166929 166928 153325 166931 166932 85593 166926 166933 159842 83805
  ]

  Account.where(id: valencian_account_ids).update_all(state_province: "VC", country: "ES")

  #################################################################################################

  aragon_account_ids = %w[
    77579 75603 91484
  ]

  Account.where(id: aragon_account_ids).update_all(state_province: "AR", country: "ES")

  #################################################################################################

  # asturias_account_ids = %w[82673 112248 113485 121078 125828 128322]

  # Account.where(id: asturias_account_ids).update_all(state_province: "AS", country: "ES")

  #################################################################################################

  # canary_islands_account_ids = %w[
  #   41703 43365 55231 63795 65337 68353 69274 79495 84103 110688 112054 112055 112100 112101 112109 112136 112809 112824 113047 113069 113098 113990 116589 121561 121807 122223 122726 122736 126702 126851 127174 127231 127539 127664 127726 127730 127966 128371 128384 128591 129072 129386 129745
  # ]

  # Account.where(id: canary_islands_account_ids).update_all(state_province: "CN", country: "ES")

  #################################################################################################

  # castile_and_leon_account_ids = %w[69143 121482]

  # Account.where(id: castile_and_leon_account_ids).update_all(state_province: "CL", country: "ES")

  #################################################################################################

  castilla_la_mancha_account_ids = %w[156956]

  Account.where(id: castilla_la_mancha_account_ids).update_all(state_province: "CM", country: "ES")

  #################################################################################################

  catalonia_account_ids = %w[
    165484 157753 73204 159843 142727 157568 156073 162909 154411
  ]

  Account.where(id: catalonia_account_ids).update_all(state_province: "CT", country: "ES")

  #################################################################################################

  # extremadura_account_ids = %w[110241]

  # Account.where(id: extremadura_account_ids).update_all(state_province: "EX", country: "ES")

  #################################################################################################

  # galicia_account_ids = %w[61942 118054 119067 123339 127096]

  # Account.where(id: galicia_account_ids).update_all(state_province: "GA", country: "ES")

  #################################################################################################

  # la_rioja_account_ids = %w[125829]

  Account.where(id: la_rioja_account_ids).update_all(state_province: "RI", country: "ES")

  #################################################################################################

  region_of_murcia_account_ids = %w[
    91702 162974 166443 164120 163542 70102 159463 163156
  ]

  Account.where(id: region_of_murcia_account_ids).update_all(state_province: "MC", country: "ES")

  #################################################################################################

  # navarre_account_ids = %w[127396 122503]

  # Account.where(id: navarre_account_ids).update_all(state_province: "NC", country: "ES")

  #################################################################################################

  # basque_country_account_ids = %w[89375 109046 111090 111666 112619 109449]

  # Account.where(id: basque_country_account_ids).update_all(state_province: "PV", country: "ES")
end
