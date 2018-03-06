import Vue from "vue";
import TeamSearch from "TeamSearch";

test('performs remote search when filteredItems is empty', () => {
  const vm = new Vue(TeamSearch).$mount();
  let spy = jest.spyOn(vm, "fetchRemoteItems");

  vm.query = "longer than 2 chars";

  setTimeout(() => {
    expect(spy).toBeCalledWith({ expandSearch: "1" });
  }, 300);
});
