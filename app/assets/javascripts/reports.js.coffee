ready =->
  # Setup - add a text input to each footer cell
  $("#report_table tfoot th").each ->
    title = $("#report_table thead th").eq($(this).index()).text()
    $(this).html "<input type=\"text\" placeholder=\"Search " + title + "\" />"
    return
  dTable = $('#report_table').DataTable(
    sDom: "<'row'<'col-xs-6'T><'col-xs-6'>r>t<'row'<'col-xs-6'i><'col-xs-6'p>>"
    sPaginationType: "full_numbers"
    bSort: false
    bProcessing: true
    bServerSide: true
    iDisplayLength: 20
    bFilter: true
    sAjaxSource: $('#report_table').data('source')
  )
  # Apply the search
  dTable.columns().eq(0).each (colIdx) ->
    $("input", dTable.column(colIdx).footer()).on "keyup change", ->
      dTable.column(colIdx).search(@value).draw()
  $('body').on 'click', "#form", ->
    sData = JSON.stringify(dTable.ajax.params())
    alert( "The following data submitted to the server: \n\n"+sData )
    return false
  $('.coll').on 'ajax:success', (event,data) ->
    $('#data_fields').html(data.html) if(data.success == true)
    $('.coll').removeClass('active')
    $(this).addClass('active')
  $('body').on 'click', ".coll_field", ->
    $(this).removeClass("coll_field")
    $(this).addClass("coll_field_selected")
    $('#report_main_type_fields').val(main_field_values)
    $('#report_parent_type_fields').val(parent_field_values)
  $('body').on 'click', ".coll_field_selected", ->
    $(this).addClass("coll_field")
    $(this).removeClass("coll_field_selected")
    $('#report_main_type_fields').val(main_field_values)
    $('#report_parent_type_fields').val(parent_field_values)


main_field_values =->
   $('.main_fields > .coll_field_selected').map( (i,n) ->
    $(n).attr('name')
    ).get()

parent_field_values =->
   $('.parent_fields > .coll_field_selected').map( (i,n) ->
    $(n).attr('name')
    ).get()

$(document).ready(ready)
$(document).on('page:load', ready)
