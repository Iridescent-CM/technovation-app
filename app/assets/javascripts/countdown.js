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

      var hoursTxt = ' hours, ',
          minutesTxt = ' minutes, ',
          secondsTxt = ' seconds!';

      if (t.hours === 1)
        hoursTxt = ' hour, ';

      if (t.minutes === 1)
        minutesTxt = ' minute, ';

      if (t.seconds === 1)
        secondsTxt = ' second!';

      html = '';

      if (t.hours > 0)
        html += t.hours + hoursTxt;

      if (t.minutes > 0)
        html += t.minutes + minutesTxt;

      clock.innerHTML = html + t.seconds + secondsTxt;
      if(t.total<=0){
        clearInterval(timeinterval);
      }
    },1000);
  }
})();
