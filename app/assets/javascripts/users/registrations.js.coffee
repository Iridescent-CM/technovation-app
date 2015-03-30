# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready -> 
  getValidEvents = () ->
    $.get('/valid_events', { conflict_region: $('.js-conflict-region').val() }, (data) ->
      currentOption = parseInt($('.js-events option:selected').val(), 10)
      $('.js-events').each( ->
        options = this.options
        options.length = 0
        data.forEach((event) ->
          options[options.length] = new Option(event.name, event.id, options.length == 0, event.id == currentOption)
        )
      )
    )

  $('.js-conflict-region').change(getValidEvents)
  getValidEvents()