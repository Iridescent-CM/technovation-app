import { shallowMount } from '@vue/test-utils'

import AttendeeSearch from 'ra/events/AttendeeSearch';

import Event from 'ra/events/Event';

test('performs remote search when filteredItems is empty', () => {
  const wrapper = shallowMount(AttendeeSearch, {
    props: {
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
