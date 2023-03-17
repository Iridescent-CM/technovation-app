import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    currentRound: "qf",

    scores: {
      not_started: [],
      finished: {
        qf: [],
        sf: [],
      },

      incomplete: {
        qf: [],
        sf: [],
      },
    },

    deadline: "",
  },

  getters: {
    finishedQuarterfinalsScores(state) {
      return state.scores.finished.qf.map((score) => ({
        ...JSON.parse(score).data.attributes,
      }));
    },

    finishedSemifinalsScores(state) {
      return state.scores.finished.sf.map((score) => ({
        ...JSON.parse(score).data.attributes,
      }));
    },

    notStartedSubmissions(state) {
      return state.scores.not_started
    },
  },

  mutations: {
    populateScores(state, payload) {
      state.scores = payload;
      state.currentRound = payload.current_round;
    },

    deadline(state, date) {
      state.deadline = date;
    },
  },
});
