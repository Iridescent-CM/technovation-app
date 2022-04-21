const emptyComment = {
  text: '',
  word_count: 0,
}

export default {
  problemSections: [],

  score: {
    id: null,
    incomplete: null,
    comments: {
      project_details: emptyComment,
      ideation: emptyComment,
      entrepreneurship: emptyComment,
      pitch: emptyComment,
      demo: emptyComment,
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
