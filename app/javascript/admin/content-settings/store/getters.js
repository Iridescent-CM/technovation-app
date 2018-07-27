export default {
  judgingEnabled: (state) => {
    return state.judging_round !== 'off'
  },
}