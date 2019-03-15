import { shallowMount } from '@vue/test-utils'

import AttendeeSearch from 'ra/events/AttendeeSearch';

import Event from 'ra/events/Event';

test('performs remote search when filteredItems is empty', () => {
  const wrapper = shallowMount(AttendeeSearch, {
    propsData: {
      type: "team",
      handleSelection: jest.fn(() => {}),
      handleDeselection: jest.fn(() => {}),
      event: new Event({
        id: 88,
      }),
    },
  });

  const fetchRemoteItemsSpy = jest.spyOn(wrapper.vm, "fetchRemoteItems");

  wrapper.vm.query = "longer than 2 chars";

  setTimeout(() => {
    expect(fetchRemoteItemsSpy).toBeCalledWith({ expandSearch: "1" });
  }, 300);
});

describe('methods', () => {
  describe('eventAtCapacity', () => {
    const eventAtCapacity = Object.assign(
      {},
      new Event({
        id: 88,
        capacity: 1,
      }),
      {
        selectedTeams: [
          {
            id: 13,
            name: 'Team 1'
          },
        ],
      }
    );

    const eventNotAtCapacity = new Event({
      id: 88,
      capacity: 10,
    });

    it('returns false if we are dealing with a non-team search', () => {
      const wrapper = shallowMount(AttendeeSearch, {
        propsData: {
          type: "account",
          handleSelection: jest.fn(() => {}),
          handleDeselection: jest.fn(() => {}),
          event: eventAtCapacity,
        },
      });

      expect(wrapper.vm.eventAtCapacity()).toBe(false);
    });

    it('returns false if we are dealing with a team search for an event not at capacity', () => {
      const wrapper = shallowMount(AttendeeSearch, {
        propsData: {
          type: "team",
          handleSelection: jest.fn(() => {}),
          handleDeselection: jest.fn(() => {}),
          event: eventNotAtCapacity,
        },
      });

      expect(wrapper.vm.eventAtCapacity()).toBe(false);
    });

    it('returns true if we are dealing with a team search for an event at capacity', () => {
      const wrapper = shallowMount(AttendeeSearch, {
        propsData: {
          type: "team",
          handleSelection: jest.fn(() => {}),
          handleDeselection: jest.fn(() => {}),
          event: eventAtCapacity,
        },
      });

      expect(wrapper.vm.eventAtCapacity()).toBe(true);
    });
  });
});
