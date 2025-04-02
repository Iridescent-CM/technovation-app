function getJudgingRubricLink(division) {
  switch (division) {
    case "senior":
      return "https://drive.google.com/file/d/1wotOPhnbT3IJbF8XhnsxT10jpl1EjRvy/view";
    case "junior":
      return "https://drive.google.com/file/d/1UleYSyl9DlKEF2rIW6IuvqYPznWCo00b/view";
    case "beginner":
      return "https://drive.google.com/file/d/1shhyqenpvt-hZ34RiQdemEFpVTCOgmtj/view";
    default:
      return "https://technovationchallenge.org/curriculum/judging-rubric/";
  }
}

export { getJudgingRubricLink };
