function getJudgingRubricLink(division) {
  switch (division) {
    case "senior":
      return process.env.SENIOR_DIVISION_JUDGING_RUBRIC_URL;
    case "junior":
      return process.env.JUNIOR_DIVISION_JUDGING_RUBRIC_URL;
    case "beginner":
      return process.env.BEGINNER_DIVISION_JUDGING_RUBRIC_URL;
    default:
      return process.env.GENERAL_JUDGING_RUBRIC_URL;
  }
}

export { getJudgingRubricLink };
