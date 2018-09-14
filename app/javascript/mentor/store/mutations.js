import Vue from 'vue'

export default {
  htmlDataset (state, dataset) {
    [
      'currentAccount',
      'currentMentor',
      'consentWaiver',
      'backgroundCheck'
    ].forEach(key => Vue.set(state, key, JSON.parse(dataset[key])))

    Vue.set(state, 'currentTeams', JSON.parse(dataset.currentTeams).data)
  },
}