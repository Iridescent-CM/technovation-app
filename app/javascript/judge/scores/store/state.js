const emptyComment = {
  text: '',
  word_count: 0,
}

export default {
  problemSections: [],

  score: {
    id: null,
    comments: {
      ideation: emptyComment,
      technical: emptyComment,
      entrepreneurship: emptyComment,
      pitch: emptyComment,
      overall: emptyComment,
    },
  },

  questions: [],

  team: {
    id: null,
    name: '',
    location: '',
    division: '',
    photo: '',
  },

  submission: {
    id: null,
    name: '',
    description: '',
    development_platform: '',
    deadline: '',
  },
}
