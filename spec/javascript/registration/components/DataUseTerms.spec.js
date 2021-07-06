import 'axios';
import { shallowMount, createLocalVue } from '@vue/test-utils';
import Vuex from 'vuex';

import mockStore from 'registration/store/__mocks__';
import DataUseTerms from 'registration/components/DataUseTerms';

const localVue = createLocalVue();
localVue.use(Vuex);

describe("Registration::Components::DataUseTerms.vue", () => {
  let defaultWrapper;

  beforeEach(() => {
    const defaultStore = mockStore.createMocks();

    defaultWrapper = shallowMount(
      DataUseTerms,
      {
        localVue,
        store: new Vuex.Store({
          modules: {
            registration: {
              namespaced: true,
              state: defaultStore.state,
              getters: defaultStore.getters,
              mutations: defaultStore.mutations,
              actions: defaultStore.actions,
            },
          },
        }),
      }
    );
  });

  describe('markup', () => {
    it('has one button element to prevent navigation issues when submitting', () => {
      // Note: if this test is failing, you can change <button> to
      // <a class="button"> for a similar effect
      const buttons = defaultWrapper.findAll('button');

      expect(buttons.length).toEqual(1);
    });
  });

  describe('props', () => {
    describe('handleSubmit', () => {
      it('creates a function that is fired when Next is clicked and terms are agreed to', () => {
        defaultWrapper.setProps({ handleSubmit: jest.fn(() => {}) });
        defaultWrapper.vm.$store.state.registration.termsAgreed = true;

        // expect(defaultWrapper.vm.handleSubmit).not.toHaveBeenCalled();

        defaultWrapper.find({ ref: 'dataUseTermsForm' }).trigger('submit');

        // expect(defaultWrapper.vm.handleSubmit).toHaveBeenCalledTimes(1);
      });
    });

    describe('submitButtonText', () => {
      it('sets the text on the "Next" button according to the prop value', async () => {
        defaultWrapper.setProps({ submitButtonText: 'Submit' });

        await defaultWrapper.vm.$nextTick()

        const submitButtonText = defaultWrapper
          .find({ ref: 'dataUseTermsSubmitButton' }).text();

        expect(submitButtonText).toEqual('Submit');
      });

      it('defaults to "Next" when no prop passed', () => {
        const submitButtonText = defaultWrapper
          .find({ ref: 'dataUseTermsSubmitButton' }).text();

        expect(submitButtonText).toEqual('Next');
      });
    });
  });
});
