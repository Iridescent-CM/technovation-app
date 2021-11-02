import { shallowMount } from '@vue/test-utils'

import IntegerInput from 'components/IntegerInput'

describe('IntegerInput Vue component', () => {
  const validKeys = [
    "Backspace",
    "Delete",
    "Enter",
    "Tab",
    "ArrowUp",
    "ArrowDown",
    "ArrowLeft",
    "ArrowRight",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
  ];

  const invalidKeys = [
    "Hello",
    "&",
    "a",
    "-",
    "+",
    "=",
  ];

  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(IntegerInput, {
      propsData: {
        inputName: 'test-input',
        value: 5,
      },
    });
  });

  xit('sets numericValue based on the value prop passed in', async () => {
    const valueProps = [ 33, 99, 2808 ];

    valueProps.forEach(async (value) => {
      wrapper.setProps({ value });

      await wrapper.vm.$nextTick()

      expect(wrapper.vm.numericValue).toEqual(value);
    });
  });

  it('sets the input name according to the input-name prop', async () => {
    const inputName = 'this-is-a-test-input';

    wrapper.setProps({ inputName });

    await wrapper.vm.$nextTick()

    expect(wrapper.find('input').attributes().name).toEqual(inputName);
  })

  describe('methods', () => {

    describe('isValidKey', () => {
      validKeys.forEach((validKey) => {
        it (`returns true for valid key: ${validKey}`, () => {
          const isValid = wrapper.vm.isValidKey(validKey);
          expect(isValid).toBe(true);
        });
      });

      invalidKeys.forEach((invalidKey) => {
        it (`returns false for invalid key: ${invalidKey}`, () => {
          const isValid = wrapper.vm.isValidKey(invalidKey);
          expect(isValid).toBe(false);
        });
      });
    });

    describe('restrictValue', () => {
      validKeys.forEach((validKey) => {
        it (`returns true and does not prevent default for valid key: ${validKey}`, () => {
          const event = {
            key: validKey,
            preventDefault: jest.fn(() => {}),
          };

          const returnValue = wrapper.vm.restrictValue(event);
          expect(returnValue).toBe(true);
          expect(event.preventDefault).not.toHaveBeenCalled();
        });
      });

      invalidKeys.forEach((invalidKey) => {
        it (`returns false and prevents default for invalid key: ${invalidKey}`, () => {
          const event = {
            key: invalidKey,
            preventDefault: jest.fn(() => {}),
          };

          const returnValue = wrapper.vm.restrictValue(event);
          expect(returnValue).toBe(false);
          expect(event.preventDefault).toHaveBeenCalledTimes(1);
        });
      });
    });

    describe('recalculateValue', () => {
      it('sets the numericValue to the maximum if it exceeds it', () => {
        const maximum = 99;

        wrapper.setProps({ maximum });

        wrapper.vm.recalculateValue(2000);

        expect(wrapper.vm.numericValue).toEqual(maximum);
      });

      it('sets the numericValue to the minimum if it is less than the minimum', () => {
        const minimum = 99;

        wrapper.setProps({ minimum });

        wrapper.vm.recalculateValue(13);

        // expect(wrapper.vm.numericValue).toEqual(minimum);
      });

      it('sets the numericValue to the integer value of the input if between min and max', () => {
        const minimum = 0;
        const maximum = 99;
        const expectedValue = 34;

        wrapper.setProps({ minimum, maximum });

        wrapper.vm.recalculateValue(expectedValue);

        expect(wrapper.vm.numericValue).toEqual(expectedValue);
      });

      it('does not change numericValue if value passed is not a number', async () => {
        const minimum = 0;
        const maximum = 99;
        const expectedValue = 34;

        wrapper.setProps({
          minimum,
          maximum,
          value: expectedValue,
        });

        await wrapper.vm.$nextTick()

        wrapper.vm.recalculateValue('test');

        expect(wrapper.vm.numericValue).toEqual(expectedValue);
      });
    });

  });

});
