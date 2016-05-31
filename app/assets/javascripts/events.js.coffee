$(document).ready ->
  showEventDetails = () ->
    eventId = $('.js-event-select option:selected').val()
    $.get('/events/' + eventId, { }, (data) ->
      $('.js-event-description').html(data.description)
      $('.js-event-location').html(data.location)
      $('.js-event-date').html(data.when_to_occur_formatted)
    )

  if $('.js-event-select').length
    $('.js-event-select').change(showEventDetails)
    showEventDetails()
