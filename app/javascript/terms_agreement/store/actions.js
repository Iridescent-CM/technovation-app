import actions from 'registration/store/actions';

export default Object.assign({}, actions, {
  updateTermsAgreed ({ commit }, { termsAgreed }) {
    commit('termsAgreed', termsAgreed);
  },
});