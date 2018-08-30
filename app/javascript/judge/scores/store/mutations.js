export const setComment = (state, commentData) => {
  const originalComment = state.score.comments[commentData.sectionName]
  const comment = Object.assign({}, originalComment, commentData)

  state.score.comments[commentData.sectionName] = comment
}

export const resetComment = (state, sectionName) => {
  const originalComment = state.score.comments[sectionName]
  const comment = Object.assign({}, originalComment, {
    text: '',
    isProfanityAnalyzed: false,
    isSentimentAnalyzed: false,
    sentiment: {
      negative: 0,
      positive: 0,
      neutral: 0,
    },
    bad_word_count: 0,
    word_count: 0,
  })

  state.score.comments[sectionName] = comment
}

export const saveComment = (state, sectionName) => {
  if (!state.score.comments[sectionName])
    return false

  const data = new FormData()

  data.append(
    `submission_score[${sectionName}_comment]`,
    state.score.comments[sectionName].text
  )

  data.append(
    `submission_score[${sectionName}_comment_positivity]`,
    state.score.comments[sectionName].sentiment.positive
  )

  data.append(
    `submission_score[${sectionName}_comment_negativity]`,
    state.score.comments[sectionName].sentiment.negative
  )

  data.append(
    `submission_score[${sectionName}_comment_neutrality]`,
    state.score.comments[sectionName].sentiment.neutral
  )

  data.append(
    `submission_score[${sectionName}_comment_word_count]`,
    wordCount(state.score.comments[sectionName].text)

  )

  data.append(
    `submission_score[${sectionName}_comment_bad_word_count]`,
    state.score.comments[sectionName].bad_word_count
  )

  $.ajax({
    method: "PATCH",
    url: `/judge/scores/${state.score.id}`,
    data: data,
    contentType: false,
    processData: false,
    success: resp => {
      // Verify the resp here
    },
    error: err => (console.error(err)),
  })
}

export const updateScores = (state, qData) => {
  const question = state.questions.find((q) => {
    return q.section === qData.section && q.idx === qData.idx
  })

  const data = new FormData()
  data.append(`submission_score[${question.field}]`, qData.score)

  $.ajax({
    method: "PATCH",
    url: `/judge/scores/${state.score.id}`,

    data: data,
    contentType: false,
    processData: false,

    success: resp => {
      question.score = qData.score
    },

    error: err => {
      console.error(err)
    },
  })
}

export const setStateFromJSON = (state, json) => {
  state.questions = json.questions
  state.team = json.team
  state.submission = json.submission
  state.score = json.score
}

export const setProblemSections = (state, arr) => {
  state.problemSections = arr
}

export const deadline = (state, date) => {
  state.deadline = date
}

function wordCount (text) {
  if (!text) text = ''

  return text.split(' ').filter(word => {
    return word.split('').filter(char => char.match(/\w/)).length > 2
  }).length
}