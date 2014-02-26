ready =->
  dTable = $('#report_table').dataTable(
    sDom: "<'row'<'col-xs-6'T><'col-xs-6'>r>t<'row'<'col-xs-6'i><'col-xs-6'p>>"
    sPaginationType: "bootstrap"
    bProcessing: true
    bServerSide: true
    iDisplayLength: 25
    bFilter: true
    oTableTools: 
      sSwfPath: "http://localhost:3000/dataTables/extras/swf/copy_csv_xls_pdf.swf"
    fnRowCallback: (nRow, aData, iDisplayIndex, iDisplayIndexFull) ->
      if $('#server_report').length
        $('td:eq(0)', nRow).html( '<a href='+ $(location).attr('href') + '/server_link/'+ aData[0]  + '>' + aData[0] + '</a>' )
    sAjaxSource: $('#report_table').data('source')
  )
  $('.coll').on 'ajax:success', (event,data) ->
    $('#data_fields').html(data.html) if(data.success == true)
    $('.coll').removeClass('active')
    $(this).addClass('active')
  $('body').on 'click', ".coll_field", ->
    $(this).removeClass("coll_field")
    $(this).addClass("coll_field_selected")
    $('#report_main_index_fields').val(main_field_values)
    $('#report_parent_index_fields').val(parent_field_values)
  $('body').on 'click', ".coll_field_selected", ->
    $(this).addClass("coll_field")
    $(this).removeClass("coll_field_selected")
    $('#report_main_index_fields').val(main_field_values)
    $('#report_parent_index_fields').val(parent_field_values)

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