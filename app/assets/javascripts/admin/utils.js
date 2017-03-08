window.Admin = {
  Utils: {
    updateURLSearchParams: function(name, value) {
      var params = new URLSearchParams(window.location.search);

      params.set(name, value);

      location.href = window.location.pathname + "?" + params.toString();
    },
  },
};
