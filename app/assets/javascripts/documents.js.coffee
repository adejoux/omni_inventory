ready =->
  $('.tabtext').on 'ajax:success', (event,data) ->
    $('#tab-content').html(data.html) if(data.success == true)
    $('.tabtext').removeClass('active')
    $(this).addClass('active')

$(document).ready(ready)
$(document).on('page:load', ready)