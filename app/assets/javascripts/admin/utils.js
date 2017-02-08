window.Admin = {
  Utils: {
    updateURLSearchParams: function(name, value) {
      var url = new URL(window.location),
        params = new URLSearchParams(url.search.slice(1));

      params.set(name, value);

      location.href = window.location.pathname + "?" + params.toString();
    },
  },
};
