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

  _.each(state.score.comments, (comment, section) => {
    if (state.team.division === 'junior' && section === 'entrepreneurship') {
      return true
    } else if (comment.word_count < 40 ||
                comment.bad_word_count > 0 ||
                  parseFloat(comment.sentiment.negative) > 0.4) {
      sections.push(section)
    }
  })

  commit('setProblemSections', sections)
}