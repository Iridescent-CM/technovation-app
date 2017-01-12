(function() {
  enableAdminDataTables();

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
})();
