import { DateTime, Interval } from 'luxon';

function ageToday(birthday) {
  return Math.floor(
    Interval
      .fromDateTimes(DateTime.fromISO(birthday), DateTime.now())
      .length('years')
  )
}

function calculateAgeByDivisionCutoffDate({birthday}) {
  const divisonCuttOffDate = DateTime.fromFormat(
    process.env.DATES_DIVISION_CUTOFF_YEAR +
      process.env.DATES_DIVISION_CUTOFF_MONTH +
      process.env.DATES_DIVISION_CUTOFF_DAY,
    'yyyyMd')

  return Math.floor(
    Interval
      .fromDateTimes(DateTime.fromISO(birthday), divisonCuttOffDate)
      .length('years')
  )
}

function verifyStudentAge({birthday, division}) {
  const age = calculateAgeByDivisionCutoffDate({birthday})

  if (division === 'beginner') {
    return (age >= 8 && age <= 12)
  } else {
    return (age >= 13 && age <= 18)
  }
}

function verifyMentorAge({birthday}) {
  return (ageToday(birthday) >= 18)
}

export { verifyStudentAge, verifyMentorAge, calculateAgeByDivisionCutoffDate }
