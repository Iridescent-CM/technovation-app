export const anyScoresEmpty = state => {
  let expectedScoreLength = 14

  if (state.team.division === 'senior')
    expectedScoreLength = 18

  const scores = _.flatMap(state.questions, 'score')

  const actualScoreLength = _.filter(scores, s => { return s > 0 }).length

  return actualScoreLength < expectedScoreLength
}

export const anyCommentsInvalid = state => {
  let expectedCount = 4

  if (state.team.division === 'senior')
    expectedCount = 5

  let commentsToCount = state.score.comments

  if (state.team.division === 'junior')
    commentsToCount = _.filter(commentsToCount,
      (_, section) => section !== 'entrepreneurship'
    )

  const actualCount = Object.keys(commentsToCount).length

  const notEnoughComments = actualCount < expectedCount

  const anyCommentsTooShort = _.some(
    commentsToCount,
    (comment, section) => { return comment.word_count < 40 }
  )

  const anyBadWords = _.some(commentsToCount, (comment, section) => {
    return comment.bad_word_count > 0
  })

  const anyExcessiveNegativity = _.some(
    commentsToCount,
    (comment, section) => {
      return parseFloat(comment.sentiment.negative) > 0.4
    }
  )

  return notEnoughComments || anyCommentsTooShort ||
            anyBadWords || anyExcessiveNegativity
}

export const comment = (state) => (sectionName) => {
  return state.score.comments[sectionName]
}

export const checklistPoints = state => {
  return state.submission.total_checklist_points
}

export const totalScore = state => {
  const questions = state.team.division === 'junior' ?
    state.questions.filter(q => q.section !== 'entrepreneurship') :
    state.questions

  return _.reduce(questions, (acc, q) => {
    return acc += q.score
  }, 0) + state.submission.total_checklist_points
}

export const totalPossible = state => {
  const questions = state.team.division === 'junior' ?
    state.questions.filter(q => q.section !== 'entrepreneurship') :
    state.questions

  return _.reduce(questions, (acc, q) => {
    return acc += q.worth
  }, 0) + 10 // + code checklist
}

export const sectionPointsPossible = (state, getters) => (section) => {
  let possible = _.reduce(getters.sectionQuestions(section), (acc, q) => {
    return acc += q.worth
  }, 0)

  if (section === 'technical') possible += 10 // + code checklist

  return possible
}

export const sectionPointsTotal = (state) => (section) => {
  let total = _.reduce(_.filter(state.questions, q => {
    return q.section === section
  }), (acc, q) => { return acc += q.score }, 0)

  if (section === 'technical')
    total += state.submission.total_checklist_points

  return total
}

export const sectionQuestions = (state) => (section) => {
  return _.filter(state.questions, q => {
    return q.section === section
  })
}
