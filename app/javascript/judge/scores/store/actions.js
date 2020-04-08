export const validateScore = ({ commit, state }) => {
  let sections = []

  const questions = state.questions.filter(q => {
    if (state.team.division === 'junior')
      return q.section !== 'entrepreneurship'

    return true
  })

  questions.forEach(q => {
    if (q.score < 1) {
      sections.push(q.section)
    }
  })

  Object.keys(state.score.comments).forEach((section) => {
    const comment = state.score.comments[section]
    const minWordCount = (section == 'overall') ? 40 : 20

    if (state.team.division === 'junior' && section === 'entrepreneurship') {
      return true
    } else if (comment.word_count < minWordCount) {
      sections.push(section)
    }
  })

  commit('setProblemSections', sections)
}
