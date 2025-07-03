MENTOR_CERTIFICATE_TYPES = {
  mentor_appreciation: 1
}

STUDENT_CERTIFICATE_TYPES = {
  participation: 3,
  quarterfinalist: 0,
  semifinalist: 4,
  regional_honoree: 9,
  special_prize_winner: 10,
  finalist: 11,
  grand_prize_winner: 12
}

JUDGE_CERTIFICATE_TYPES = {
  bronze_judge: 6,
  silver_judge: 7,
  gold_judge: 8
}

OFF_PLATFORM_CERTIFICATE_TYPES = {
  rpe_winner: 2
}

PAST_CERTIFICATE_TYPES = {
  general_judge: 5
}

CERTIFICATE_TYPES = MENTOR_CERTIFICATE_TYPES.merge(
  **STUDENT_CERTIFICATE_TYPES,
  **JUDGE_CERTIFICATE_TYPES,
  **OFF_PLATFORM_CERTIFICATE_TYPES,
  **PAST_CERTIFICATE_TYPES
)
