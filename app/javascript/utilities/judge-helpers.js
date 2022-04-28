function getJudgingRubricLink(division){
    switch (division) {
        case 'senior':
            return "https://technovationchallenge.org/wp-content/uploads/2021/09/Senior-Rubric-2022-Season-FINAL-9-14-21.pdf"
        case 'junior':
            return "https://technovationchallenge.org/wp-content/uploads/2021/09/Junior-Rubric-2022-Season-FINAL-9-14-21.pdf"
        case 'beginner':
            return "https://technovationchallenge.org/wp-content/uploads/2021/09/Beginner-Rubric-2022-Season-FINAL-9-14-21.pdf"
        default:
            return "https://technovationchallenge.org/curriculum/judging-rubric/"
    }
}

export { getJudgingRubricLink }