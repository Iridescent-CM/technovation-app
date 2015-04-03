# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  showEventDetails = () ->
    eventId = $('.js-event-select option:selected').val()
    $.get('/events/' + eventId, { }, (data) ->
      $('.js-event-description').html(data.description)
      $('.js-event-location').html(data.location)
      date = new Date(data.whentooccur)
      $('.js-event-date').html(date.toLocaleDateString() + ', ' + date.toTimeString())
    )

  if $('.js-event-select').length
    $('.js-event-select').change(showEventDetails)
    showEventDetails()
