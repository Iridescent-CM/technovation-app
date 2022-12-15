function getJudgingRubricLink(division){
    switch (division) {
        case 'senior':
            return "https://technovationchallenge.org/wp-content/uploads/2022/09/Senior-Rubric-2023-Season-FINAL.pdf"
        case 'junior':
            return "https://technovationchallenge.org/wp-content/uploads/2022/09/Junior-Rubric-2023-Season-FINAL.pdf"
        case 'beginner':
            return "https://technovationchallenge.org/wp-content/uploads/2022/09/Beginner-Rubric-2023-Season-FINAL.pdf"
        default:
            return "https://technovationchallenge.org/curriculum/judging-rubric/"
    }
}

export { getJudgingRubricLink }
