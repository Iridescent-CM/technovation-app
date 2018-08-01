export default {
  judgingEnabled: (state) => {
    return state.settings.judging_round !== 'off'
  },
}