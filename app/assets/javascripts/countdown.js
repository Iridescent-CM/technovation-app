(function countdowns() {
  var deadline = 'April 26 2017 17:00:00 GMT-0700';
  initializeClock('countdown', deadline);

  function getTimeRemaining(endtime){
    var t = Date.parse(endtime) - Date.parse(new Date());
    var seconds = Math.floor( (t/1000) % 60 );
    var minutes = Math.floor( (t/1000/60) % 60 );
    var hours = Math.floor( (t/(1000*60*60)) % 24 );
    var days = Math.floor( t/(1000*60*60*24) );
    return {
    'total': t,
    'days': days,
    'hours': hours,
    'minutes': minutes,
    'seconds': seconds
    };
  }

  function initializeClock(id, endtime){
    var clock = document.getElementById(id);

    if (!clock)
      return;

    var timeinterval = setInterval(function(){
      var t = getTimeRemaining(endtime);
          html = '';

      clock.innerHTML = t.hours + ' hours, ' +
                        t.minutes + ' minutes, ' +
                        t.seconds + ' seconds!';
      if(t.total<=0){
        clearInterval(timeinterval);
      }
    },1000);
  }
})();
