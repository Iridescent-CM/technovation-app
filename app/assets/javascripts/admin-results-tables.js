(function() {
  enableAdminDataTables();
  syncTableScrolling();
  enableHeaderFilterMenus();

  function enableAdminDataTables() {
    var wrappers = document.querySelectorAll('.admin-results-table');

    wrappers.forEach(function(wrapper) {
      var headers = wrapper.querySelectorAll('.header'),
          cells = wrapper.querySelectorAll('.cell'),
          maxWidths = {};

      if (cells.length === 0)
        return;

      cells.forEach(function(cell) {
        var index = getRowIndex(cell);

        maxWidths[index] = maxWidths[index] || headers[index].offsetWidth;

        if (cell.offsetWidth > maxWidths[index])
          maxWidths[index] = cell.offsetWidth;
      });

      cells.forEach(function(cell) {
        var index = getRowIndex(cell);

        cell.style.width = maxWidths[index].toString() + "px";
      });

      var firstRowCells = wrapper.querySelectorAll('.row:first-child .cell');

      headers.forEach(function(header, i) {
        if (header.offsetWidth < firstRowCells[i].offsetWidth)
          header.style.width = firstRowCells[i].offsetWidth.toString() + "px";
      });
    });

    function getRowIndex(cell) {
      var row = cell.parentNode;
      return Array.prototype.indexOf.call(row.children, cell);
    }
  }

  function syncTableScrolling() {
    var body = document.querySelector('.admin-results-data-table'),
        header = document.querySelector('.admin-results-header-table');

    if (!body)
      return

    body.addEventListener('scroll', function(e) {
      header.scrollLeft = e.target.scrollLeft;
    });

    header.addEventListener('scroll', function(e) {
      body.scrollLeft = e.target.scrollLeft;
    });
  }

  function enableHeaderFilterMenus() {
    var menuBtns = document.querySelectorAll('.header-filter-menu'),
        menuItems = document.querySelectorAll('.header-menu li'),
        underlay = document.getElementById('menu-underlay');

    if (underlay)
      underlay.addEventListener('click', function() { closeActiveMenus(); });

    menuItems.forEach(function(item) {
      item.addEventListener('click', function(e) {
        if (!item.dataset.filterSelect) {
          closeActiveMenus();
          var option = e.target.querySelector('.fa');
          Admin.Utils.updateURLSearchParams(option.dataset.name, option.dataset.value);
        }
      });
    });

    menuBtns.forEach(function(btn) {
      btn.addEventListener('click', function(e) {
        var menu = document.getElementById(e.target.dataset.menu),
            viewportOffset = e.target.getBoundingClientRect();

        menu.style.top = e.pageY + 10 + "px";
        menu.style.left = e.pageX + "px";
        menu.classList.toggle('active');

        if (menu.classList.contains('active')) {
          underlay.style.display = "block";
        } else {
          closeActiveMenus();
        }
      });
    });
  }

  function closeActiveMenus() {
    var underlay = document.getElementById('menu-underlay'),
        activeMenus = document.querySelectorAll('.header-menu.active');

    underlay.style.display = "none";

    activeMenus.forEach(function(m) {
      m.classList.remove('active');
    });
  }
})();
