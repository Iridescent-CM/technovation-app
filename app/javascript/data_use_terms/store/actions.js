import actions from 'registration/store/actions';

export default Object.assign({}, actions, {
  updateTermsAgreed ({ commit, state }, { termsAgreed }) {
    commit('termsAgreed', termsAgreed)

    axios.post('/account_data/data_use_terms/edit', {
      termsAgreed,
      email: state.email,
    }).then(({ data: { data: { attributes } } }) => {
      commit('termsAgreed', attributes.termsAgreed)
      commit('termsAgreedDate', attributes.termsAgreedDate)
    }).catch(err => console.error(err))
  },
});