# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready -> 
  getValidEvents = (e) ->
    $.get('/valid_events', { conflict_region: e.target.value }, (data) ->
      $('.js-events').each( ->
        options = this.options
        options.length = 0
        data.forEach((event) ->
          options[options.length] = new Option(event.name, event.id)
        )
      )
    )

  $('.js-conflict-region').change(getValidEvents)