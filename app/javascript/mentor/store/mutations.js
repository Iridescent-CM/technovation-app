import Vue from 'vue'

export default {
  htmlDataset (state, dataset) {
    [
      'regionalAmbassador',
      'currentAccount',
      'currentMentor',
      'consentWaiver',
      'backgroundCheck'
    ].forEach(key => {
      if (dataset[key])
        Vue.set(state, key, JSON.parse(dataset[key]))
    })

    if (dataset.currentTeams)
      Vue.set(state, 'currentTeams', JSON.parse(dataset.currentTeams).data)
  },

  location (state, attributes) {
    state.currentAccount.data.attributes.city = attributes.city
    state.currentAccount.data.attributes.state = attributes.state
    state.currentAccount.data.attributes.country = attributes.country
    state.currentAccount.data.attributes.countryCode = attributes.countryCode || null
    state.currentAccount.data.attributes.stateCode = attributes.stateCode || null
  },
}