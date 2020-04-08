import flatMap from 'lodash/flatMap'

export const anyScoresEmpty = state => {
  let expectedScoreLength = 12

  if (state.team.division === 'senior')
    expectedScoreLength = 16

  const scores = flatMap(state.questions, 'score')

  const actualScoreLength = scores.filter((score) => { return score > 0 }).length

  return actualScoreLength < expectedScoreLength
}

export const anyCommentsInvalid = state => {
  let expectedCount = 4

  if (state.team.division === 'senior')
    expectedCount = 5

  let commentsToCount = Object.keys(state.score.comments)

  if (state.team.division === 'junior')
    commentsToCount = commentsToCount
      .filter((section) => section !== 'entrepreneurship')

  const actualCount = commentsToCount.length

  const notEnoughComments = actualCount < expectedCount

  const anyCommentsTooShort = commentsToCount.some((section) => {
    const minWordCount = (section == 'overall') ? 40 : 20

    return state.score.comments[section].word_count < minWordCount
  })

  return notEnoughComments || anyCommentsTooShort
}

export const comment = (state) => (sectionName) => {
  return state.score.comments[sectionName]
}

export const totalScore = state => {
  const questions = state.team.division === 'junior' ?
    state.questions.filter(q => q.section !== 'entrepreneurship') :
    state.questions

  return questions.reduce((acc, q) => {
    return acc += q.score
  }, 0)
}

export const totalPossible = state => {
  const questions = state.team.division === 'junior' ?
    state.questions.filter(q => q.section !== 'entrepreneurship') :
    state.questions

  return questions.reduce((acc, q) => {
    return acc += q.worth
  }, 0)
}

export const sections = (state, getters) => {
  let sections = [
    {
      name: 'ideation',
      title: 'Ideation',
      pointsTotal: getters.sectionPointsTotal('ideation'),
      pointsPossible: getters.sectionPointsPossible('ideation'),
    },

    {
      name: 'technical',
      title: 'Technical',
      pointsTotal: getters.sectionPointsTotal('technical'),
      pointsPossible: getters.sectionPointsPossible('technical'),
    },

    {
      name: 'pitch',
      title: 'Pitch',
      pointsTotal: getters.sectionPointsTotal('pitch'),
      pointsPossible: getters.sectionPointsPossible('pitch'),
    },
  ]

  if (state.team.division === 'senior') {
    sections.push({
      name: 'entrepreneurship',
      title: 'Entrepreneurship',
      pointsTotal: getters.sectionPointsTotal('entrepreneurship'),
      pointsPossible: getters.sectionPointsPossible('entrepreneurship'),
    })
  }

  sections.push({
    name: 'overall',
    title: 'Overall Impression',
    pointsTotal: getters.sectionPointsTotal('overall'),
    pointsPossible: getters.sectionPointsPossible('overall'),
  })

  return sections
}

export const section = (state, getters) => (name) => {
  return getters.sections.filter(section => section.name === name)[0]
}

export const sectionPointsPossible = (state, getters) => (section) => {
  let possible = getters.sectionQuestions(section).reduce((acc, q) => {
    return acc += q.worth
  }, 0)
  return possible
}

export const sectionPointsTotal = (state) => (section) => {
  const sectionQuestions = state.questions.filter((q) => {
    return q.section === section
  })

  let total = sectionQuestions.reduce((acc, q) => { return acc += q.score }, 0)

  return total
}

export const sectionQuestions = (state) => (section) => {
  return state.questions.filter(question => {
    return question.section === section
  })
}

export const problemInSection = (state) => (name) => {
  return state.problemSections.includes(name)
}
