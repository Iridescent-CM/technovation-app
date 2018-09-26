import Vue from 'vue'

export default {
  htmlDataset (state, dataset) {
    [
      'regionalAmbassador',
      'currentAccount',
      'currentTeam',
      'currentSubmission',
      'parentalConsent',
    ].forEach(key => {
      if (dataset[key])
        Vue.set(state, key, JSON.parse(dataset[key]))
    })
  },
}