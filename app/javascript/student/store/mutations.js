import Vue from 'vue'

export default {
  htmlDataset (state, dataset) {
    [
      'regionalAmbassador',
      'currentAccount',
      'currentTeam',
      'parentalConsent',
    ].forEach(key => Vue.set(state, key, JSON.parse(dataset[key])))
  },
}