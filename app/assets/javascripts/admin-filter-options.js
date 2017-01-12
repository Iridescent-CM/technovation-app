(function adminFilterOptions() {
  enableAdminFilterOptions();

  function enableAdminFilterOptions() {
    var fields = document.querySelectorAll(
      ".admin-search__filter-options input, .admin-search__filter-options select, .per_page, [data-reload]"
    );

    fields.forEach(function(field) {
      field.addEventListener('change', updateURLSearchParams);
      field.addEventListener('keydown', function(e) {
        if (e.keyCode === 13) // ENTER
          updateURLSearchParams(e);
      });
    });

    function updateURLSearchParams(e) {
      var paramName = e.target.name,
          paramValue = e.target.value,
          url = new URL(window.location),
          params = new URLSearchParams(url.search.slice(1));

      params.set(paramName, paramValue);

      location.href = window.location.pathname + "?" + params.toString();
    }
  }
})();
