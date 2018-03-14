import Vue from "vue";
import AttendeeSearch from "events/AttendeeSearch";

test('performs remote search when filteredItems is empty', () => {
  const vm = new Vue(AttendeeSearch).$mount();
  let spy = jest.spyOn(vm, "fetchRemoteItems");

  vm.query = "longer than 2 chars";

  setTimeout(() => {
    expect(spy).toBeCalledWith({ expandSearch: "1" });
  }, 300);
});
