module CertificateTypes
  MENTOR_CERTIFICATE_TYPES = {
    mentor: 1,
    coach: 14
  }

  STUDENT_CERTIFICATE_TYPES = {
    participation: 3,
    quarterfinalist: 0,
    semifinalist: 4,
    regional_honoree: 9,
    finalist: 11,
    grand_prize_winner: 12,
    break_the_scroll_prize: 15,
    climate_prize: 16,
    empowered_excellence: 17,
    student_ambassador: 18,
    student_club_leader: 19,
    lead_student_ambassador: 20
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
    general_judge: 5,
    special_prize_winner: 10
  }

  AMBASSADOR_CERTIFICATE_TYPES = {
    ambassador_appreciation: 13
  }

  LETTER_OF_RECOGNITION_TYPES = {
    mentor_letter: 21,
    ambassador_letter: 22,
    bronze_judge_letter: 23,
    silver_judge_letter: 24,
    gold_judge_letter: 25
  }

  MANUAL_ONLY_CERTIFICATE_TYPES = %i[
    coach
    break_the_scroll_prize
    climate_prize
    empowered_excellence
    student_ambassador
    student_club_leader
    lead_student_ambassador
  ].freeze

  CERTIFICATE_TYPES = MENTOR_CERTIFICATE_TYPES.merge(
    **STUDENT_CERTIFICATE_TYPES,
    **JUDGE_CERTIFICATE_TYPES,
    **OFF_PLATFORM_CERTIFICATE_TYPES,
    **PAST_CERTIFICATE_TYPES,
    **AMBASSADOR_CERTIFICATE_TYPES,
    **LETTER_OF_RECOGNITION_TYPES
  )
end
