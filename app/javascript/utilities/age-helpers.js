import { DateTime, Interval } from 'luxon';

import { divisionCutoffDate } from './technovation-dates.js'

function ageToday(birthday) {
  return Math.floor(
    Interval
      .fromDateTimes(DateTime.fromISO(birthday), DateTime.now())
      .length('years')
  )
}

function calculateAgeByDivisionCutoffDate({birthday}) {
  return Math.floor(
    Interval
      .fromDateTimes(DateTime.fromISO(birthday), divisionCutoffDate())
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

function verifyOlderThanEighteen({birthday}) {
  return (ageToday(birthday) >= 18)
}

function exampleStudentBirthday() {
  return divisionCutoffDate().minus({ days: 4 }).toFormat('MMMM d, yyyy')
}

export {
  verifyStudentAge,
  verifyOlderThanEighteen,
  calculateAgeByDivisionCutoffDate,
  exampleStudentBirthday
}
