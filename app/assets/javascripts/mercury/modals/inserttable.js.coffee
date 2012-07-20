@Mercury.modalHandlers.insertTable = {

  initialize: ->
    @table = @element.find('#table_display table')

    @table.on 'click', (event) => @onCellClick($(event.target))

    @element.find('#table_alignment').on 'change', => @setTableAlignment()
    @element.find('#table_border').on 'keyup', => @setTableBorder()
    @element.find('#table_spacing').on 'keyup', => @setTableCellSpacing()
    @element.find('[data-action]').on 'click', (event) =>
      event.preventDefault()
      @onActionClick(jQuery(event.target).data('action'))

    @selectFirstCell()

    @element.find('form').on 'submit', (event) =>
      event.preventDefault()
      @submitForm()
      @hide()


  selectFirstCell: ->
    firstCell = @table.find('td, th').first()
    firstCell.addClass('selected')
    Mercury.tableEditor(@table, firstCell, '&nbsp;')


  onCellClick: (@cell) ->
    @table = @cell.closest('table')
    @table.find('.selected').removeAttr('class')
    @cell.addClass('selected')
    Mercury.tableEditor(@table, @cell, '&nbsp;')


  onActionClick: (action) ->
    return unless action
    Mercury.tableEditor[action]()


  setTableAlignment: ->
    @table.attr({align: @element.find('#table_alignment').val()})

  setTableBorder: ->
    border = parseInt(@element.find('#table_border').val(), 10)
    if isNaN(border)
      @table.removeAttr('border')
    else
      @table.attr({border: border})

  setTableCellSpacing: ->
    cellspacing = parseInt(@element.find('#table_spacing').val(), 10)
    if isNaN(cellspacing)
      @table.removeAttr('cellspacing')
    else
      @table.attr({cellspacing: cellspacing})


  submitForm: ->
    @table.find('.selected').removeAttr('class')
    @table.find('td, th').html('<br/>')

    html = jQuery('<div>').html(@table).html()
    value = html.replace(/^\s+|\n/gm, '').replace(/(<\/.*?>|<table.*?>|<tbody>|<tr>)/g, '$1\n')

    Mercury.trigger('action', {action: 'insertTable', value: value})

}
