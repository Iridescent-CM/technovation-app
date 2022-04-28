import flatMap from 'lodash/flatMap'

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
      name: 'project_details',
      title: 'Project Name & Description',
      pointsTotal: getters.sectionPointsTotal('project_details'),
      pointsPossible: getters.sectionPointsPossible('project_details'),
      isComplete: getters.isSectionComplete('project_details')
    },

    {
      name: 'ideation',
      title: 'Learning Journey',
      pointsTotal: getters.sectionPointsTotal('ideation'),
      pointsPossible: getters.sectionPointsPossible('ideation'),
      isComplete: getters.isSectionComplete('ideation')
    },

    {
      name: 'pitch',
      title: 'Pitch',
      pointsTotal: getters.sectionPointsTotal('pitch'),
      pointsPossible: getters.sectionPointsPossible('pitch'),
      isComplete: getters.isSectionComplete('pitch')
    },

    {
      name: 'demo',
      title: 'Demo',
      pointsTotal: getters.sectionPointsTotal('demo'),
      pointsPossible: getters.sectionPointsPossible('demo'),
      isComplete: getters.isSectionComplete('demo')
    },
  ]

  if (state.team.division === 'senior' || state.team.division === 'junior') {
    sections.push({
      name: 'entrepreneurship',
      title: state.team.division === 'senior' ? 'Business Plan' : 'User Adoption Plan',
      pointsTotal: getters.sectionPointsTotal('entrepreneurship'),
      pointsPossible: getters.sectionPointsPossible('entrepreneurship'),
      isComplete: getters.isSectionComplete('entrepreneurship')
    })
  }

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

export const isScoreComplete = (state) => {
  return state.score.complete
}

export const hasScoreBeenStarted = (state, getters) => {
  return state.questions.some(question => (
    question.score > 0
  ))
}

export const hasIncompleteSections = (state, getters) => {
  return getters.sections.some((section) => (
    !getters.isSectionComplete(section.name)
  ))
}

export const isSectionComplete = (state, getters) => (section) => {
  const questions = getters.sectionQuestions(section)
  const hasValidComment = state.score.comments[section].word_count >= 20
  const allQuestionsHaveBeenAnswered = questions && questions.every((q) => q.score > 0)

  return hasValidComment && allQuestionsHaveBeenAnswered
}
