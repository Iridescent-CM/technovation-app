(function scrollyTable() {
  var tableWrappers = document.getElementsByClassName('scrolly-table');
  if (tableWrappers.length === 0) {
    return;
  }

  Array.prototype.forEach.call(tableWrappers, function(wrapper) {
    if (!wrapper.querySelector('.scrolly-table__overflow-handler')) {
      console.error('You must wrap the table in a ' +
        '<div class="scrolly-table__overflow-handler">');
    }

    var THs = wrapper.querySelectorAll('th');
    var dummyTRs = document.createElement('tr');

    Array.prototype.forEach.call(THs, function(th) {
      dummyTRs.appendChild(th.cloneNode(true));
    });

    var dummyTable = document.createElement('table');
    var dummyThead = document.createElement('thead');
    dummyThead.appendChild(dummyTRs);
    dummyTable.appendChild(dummyThead);
    dummyTable.classList.add('scrolly-table__dummy-table');

    wrapper.insertBefore(dummyTable, wrapper.children[0]);

    sizeFakeHeadings(wrapper);
    window.addEventListener('resize', function() {
      sizeFakeHeadings(wrapper);
    });
  });

  function sizeFakeHeadings(scrollyTableWrapper) {
    var realTHs = scrollyTableWrapper.querySelectorAll('.scrolly-table__overflow-handler th');
    var fakeTHs = scrollyTableWrapper.querySelectorAll('.scrolly-table__dummy-table th');

    for (var i = 0; i < realTHs.length; i++) {
      fakeTHs[i].style.width = realTHs[i].clientWidth + 'px';
    }
  }
})();
