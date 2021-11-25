import { DateTime } from 'luxon';

function divisionCutoffDate() {
  return DateTime.fromFormat(
    process.env.DATES_DIVISION_CUTOFF_YEAR +
      process.env.DATES_DIVISION_CUTOFF_MONTH +
      process.env.DATES_DIVISION_CUTOFF_DAY,
    'yyyyMd')
}

export { divisionCutoffDate }
