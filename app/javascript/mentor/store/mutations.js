import Vue from 'vue'

export default {
  htmlDataset (state, dataset) {
    [
      'regionalAmbassador',
      'currentAccount',
      'currentMentor',
      'consentWaiver',
      'backgroundCheck',
      'settings',
    ].forEach(key => {
      if (dataset[key])
        Vue.set(state, key, JSON.parse(dataset[key]))
    })

    if (dataset.currentTeams)
      Vue.set(state, 'currentTeams', JSON.parse(dataset.currentTeams).data)
  },
}
