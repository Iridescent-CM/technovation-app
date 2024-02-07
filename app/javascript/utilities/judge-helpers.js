function getJudgingRubricLink(division) {
  switch (division) {
    case "senior":
      return "https://technovationchallenge.org/wp-content/uploads/2023/07/FINAL-Senior-16-18-Rubric-2024-Season-.pdf";
    case "junior":
      return "https://technovationchallenge.org/wp-content/uploads/2023/07/FINAL-Junior-13-15-Rubric-2024-Season-.pdf";
    case "beginner":
      return "https://technovationchallenge.org/wp-content/uploads/2023/07/FINAL-Beginner-8-12-Rubric-2024-Season-.pdf";
    default:
      return "https://technovationchallenge.org/curriculum/judging-rubric/";
  }
}

export { getJudgingRubricLink };
