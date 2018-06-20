import { shallow } from '@vue/test-utils'

import AttendeeSearch from "ra/events/AttendeeSearch";

test('performs remote search when filteredItems is empty', () => {
  const wrapper = shallow(AttendeeSearch);
  const fetchRemoteItemsSpy = jest.spyOn(wrapper.vm, "fetchRemoteItems");

  wrapper.vm.query = "longer than 2 chars";

  setTimeout(() => {
    expect(fetchRemoteItemsSpy).toBeCalledWith({ expandSearch: "1" });
  }, 300);
});
