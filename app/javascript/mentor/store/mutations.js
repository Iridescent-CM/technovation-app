import Vue from 'vue'

export default {
  htmlDataset (state, dataset) {
    [
      'currentAccount',
      'currentMentor',
      'currentTeams',
      'consentWaiver',
      'backgroundCheck'
    ].forEach(key => Vue.set(state, key, JSON.parse(dataset[key])))
  },
}