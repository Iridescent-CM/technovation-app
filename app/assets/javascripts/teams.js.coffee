# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  initial_region = $('#team_region_id').val()

  openRegionForChange = ->
    $('a#region_button').text('To cancel changes click here.')

  closeRegionForChange = ->
    $("#select_region select").val(initial_region)
    $("#select_region select").trigger('change')
    $('a#region_button').text('To make changes click here.')

  cancelDefaultBehaviourOfBrowser = (e) ->
    e.preventDefault()

  toggleForChangeRegion = (e) ->
    cancelDefaultBehaviourOfBrowser(e)
    $('#select_region').toggleClass('opened')
    if $('#select_region').hasClass('opened')
      openRegionForChange()
    else
      closeRegionForChange()

  getCurrentRegion = () ->
    $('#team_region_id').val()

  changeRegion = (e) ->
    new_region = $('#select_region option:selected' ).text() + '.'
    $('#region_name').html(new_region)
    $('input#team_confirm_region[type=checkbox]').attr('checked', false))

    if getCurrentRegion() != initial_region
      $('#region_name').addClass('hightlight')
    else
      $('#region_name').removeClass('hightlight')

  validateFiles = (event) ->
    inputFile = event.currentTarget
    maxExceededMessage = 'This file exceeds the maximum allowed file size (100KB)'
    maxFileSize = $(inputFile).data('max-file-size')
    $.each inputFile.files, ->
      if @size and maxFileSize and @size > parseInt(maxFileSize)
        alert maxExceededMessage
        $(inputFile).val ''
      return
    return

  $('a#region_button').click(toggleForChangeRegion)
  $('#team_region_id').change(changeRegion)
  $('input[type="file"]').change(validateFiles)
