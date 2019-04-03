MENTOR_CERTIFICATE_TYPES = %w{
  mentor_appreciation
}

STUDENT_CERTIFICATE_TYPES = %w{
  participation
  completion
  semifinalist
}

JUDGE_CERTIFICATE_TYPES = %w{
  certified_judge
  head_judge
  judge_advisor
}

OFF_PLATFORM_CERTIFICATE_TYPES = %w{
  rpe_winner
}

PAST_CERTIFICATE_TYPES = %w{
  general_judge
}

CERTIFICATE_TYPES =  
  MENTOR_CERTIFICATE_TYPES +
  STUDENT_CERTIFICATE_TYPES +
  JUDGE_CERTIFICATE_TYPES +
  OFF_PLATFORM_CERTIFICATE_TYPES +
  PAST_CERTIFICATE_TYPES
