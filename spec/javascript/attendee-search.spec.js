import Vue from 'vue';
import { mount } from '@vue/test-utils';
import _ from 'lodash';

import AttendeeSearch from '../../app/javascript/events/AttendeeSearch';

describe('AttendeeSearch', () => {
  beforeEach(() => {
    // We need to make _.debounce synchronous. We could normally
    // use "jasmine.clock().tick(301)" to test any setTimeout calls
    // but _.debounce doesn't use Date objects, so we have to find
    // a way around that for testing. Boo.
    spyOn(_, 'debounce').and.callFake((func) => {
      return function() {
        func.apply(this, arguments);
      };
    });
  });

  it('performs remote search when filteredItems is empty', () => {
    const cmp = mount(AttendeeSearch);
    const { vm } = cmp;

    spyOn(vm, 'fetchRemoteItems').and.stub();

    cmp.setData({
      query: 'longer than 2 chars',
    });

    expect(_.debounce).toHaveBeenCalled();
    expect(vm.fetchRemoteItems).toHaveBeenCalledWith({ expandSearch: 1 });
  });
});
