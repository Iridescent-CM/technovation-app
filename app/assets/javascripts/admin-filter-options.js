(function adminFilterOptions() {
  enableAdminFilterOptions();

  function enableAdminFilterOptions() {
    var fields = document.querySelectorAll(
      ".admin-search__filter-options input, .admin-search__filter-options select, .per_page, [data-reload]"
    );

    fields.forEach(function(field) {
      field.addEventListener('change', function(e) {
        Admin.Utils.updateURLSearchParams(e.target.name, e.target.value);
      });

      field.addEventListener('keydown', function(e) {
        if (e.keyCode === 13) // ENTER
          Admin.Utils.updateURLSearchParams(e.target.name, e.target.value);
      });
    });
  }
})();
