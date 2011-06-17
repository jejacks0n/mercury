@Mercury.modalHandlers.inserttable = ->
  table = @element.find('#table_display table')
  # make td's selectable
  table.click (event) =>
    cell = $(event.target)
    table = cell.closest('table')
    table.find('.selected').removeClass('selected')
    cell.addClass('selected')
    @tableEditor = Mercury.tableEditor(table, cell)

  # select the first td
  firstCell = table.find('td, th').first()
  firstCell.addClass('selected')
  Mercury.tableEditor(table, firstCell)

  # make the buttons work
  @element.find('input.action').click (event) =>
    action = $(event.target).attr('name')
    switch action

      when 'insertrowbefore' then Mercury.tableEditor.addRow('before')
      when 'insertrowafter' then Mercury.tableEditor.addRow('after')
      when 'deleterow' then Mercury.tableEditor.removeRow()
      when 'insertcolumnbefore' then Mercury.tableEditor.addColumn('before')
      when 'insertcolumnafter' then Mercury.tableEditor.addColumn('after')
      when 'deletecolumn' then Mercury.tableEditor.removeColumn()
      when 'increasecolspan' then Mercury.tableEditor.increaseColspan()
      when 'decreasecolspan' then Mercury.tableEditor.decreaseColspan()
      when 'increaserowspan' then Mercury.tableEditor.increaseRowspan()
      when 'decreaserowspan' then Mercury.tableEditor.decreaseRowspan()

  # set the alignment
  @element.find('#table_alignment').change =>
    table.attr({align: @element.find('#table_alignment').val()})

  # set the border
  @element.find('#table_border').change =>
    table.attr({border: parseInt(@element.find('#table_border').val())})

  # set the cellspacing
  @element.find('#table_spacing').change =>
    table.attr({cellspacing: parseInt(@element.find('#table_spacing').val())})

  # build the table on form submission
  @element.find('form').submit (event) =>
    event.preventDefault()
    table.find('.selected').removeClass('selected')
    table.find('td, th').html('&nbsp;')

    tableHTML = $('<div>').html(table).html()
    tableHTML = tableHTML.replace(/^\s+|\n/gm, '')
    tableHTML = tableHTML.replace(/(<\/.*?>|<table.*?>|<tbody>|<tr>)/g, '$1\n')

    Mercury.trigger('action', {action: 'insertHTML', value: tableHTML})
    Mercury.modal.hide()

