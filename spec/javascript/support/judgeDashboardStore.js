import Vuex from "vuex";

const getters = {
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
    return state.scores.not_started;
  },
};

export function buildFinishedScorePayload(attributes) {
  return JSON.stringify({ data: { attributes } });
}

export function buildJudgeDashboardStore({
  finishedQf = [],
  finishedSf = [],
  notStarted = [],
} = {}) {
  return new Vuex.Store({
    state: {
      currentRound: "qf",
      scores: {
        not_started: notStarted,
        finished: { qf: finishedQf, sf: finishedSf },
        incomplete: { qf: [], sf: [] },
      },
      deadline: "May 20, 2026",
    },
    getters,
  });
}
