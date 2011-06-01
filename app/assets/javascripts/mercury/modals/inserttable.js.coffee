Mercury.modalHandlers.inserttable = ->
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

  #todo: finish me
  # make the alignment option work

  # make the border option work

  # make the cellspacing option work

  # build the table on form submission
  @element.find('form').submit (event) =>
    event.preventDefault()
    table.find('.selected').removeClass('selected')
    table.find('td, th').html('&nbsp;')

    Mercury.trigger('action', {action: 'insertHTML', value: table})
    Mercury.modal.hide()

