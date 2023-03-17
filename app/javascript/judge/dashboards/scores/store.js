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

    submissions: [],

    deadline: "",
  },

  getters: {
    finishedScores(state) {
      return state.scores.finished[state.currentRound].map((score) => ({
        ...JSON.parse(score).data.attributes,
      }));
    },

    quarterFinalsScores(state) {
      return state.scores.incomplete.qf.map((score) => ({
        ...JSON.parse(score).data.attributes,
      }));
    },

    finishedQuarterfinalsScores(state) {
      return state.scores.finished.qf.map((score) => ({
        ...JSON.parse(score).data.attributes,
      }));
    },

    semiFinalsScores(state) {
      return state.scores.incomplete.sf.map((score) => ({
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

    populateSubmissions(state, payload) {
      state.submissions = payload;
    },

    deadline(state, date) {
      state.deadline = date;
    },
  },
});
