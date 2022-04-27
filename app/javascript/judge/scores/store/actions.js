export const validateScore = ({ commit, state }) => {
  let problemSections = []

  state.questions.forEach(q => {
    if (q.score < 1) {
      problemSections.push(q.section)
    }
  })

  Object.keys(state.score.comments).forEach((section) => {
    const comment = state.score.comments[section]
    const minWordCount = 20

    if (state.team.division === 'beginner' && section === 'entrepreneurship') {
      return true
    } else if (comment.word_count < minWordCount) {
      problemSections.push(section)
    }
  })

  commit('setProblemSections', problemSections)
}
