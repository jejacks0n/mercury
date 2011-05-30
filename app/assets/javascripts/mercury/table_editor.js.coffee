# there's several bugs here
Mercury.tableEditor = (table, cell) ->
  Mercury.tableEditor.load(table, cell)
  return Mercury.tableEditor

$.extend Mercury.tableEditor, {

  load: (@table, @cell) ->
    @row = @cell.parent('tr')


  # counts the columns of the first row in the table, using colspans
  columnCount: ->
    count = 0
    section = @table.find('thead tr:first-child, tbody tr:first-child, tfoot tr:first-child').first()
    return @columnIndex(section.find('th, td'))


  # counts the rows of the table
  rowCount: ->
    return @table.find('tr').length


  # counts the columns including colspans, given a set of cells (in px)
  columnIndex: (cells) ->
    count = 0
    count += @colSpan($(cell)) for cell in cells
    return count


  # calculates the left, and optionally the width of a cell
  columnOffset: (cell, includeWidth = true) ->
    @table.css({position: 'relative'}) # todo: can we reset this back quickly?
    offset = @columnLeft(cell)
    offset += @columnWidth(cell) if includeWidth
    return offset


  # calculates the left of a cell (in px)
  columnLeft: (cell) ->
    return cell.position().left


  # calculates the width of a cell (in px)
  columnWidth: (cell) ->
    return cell.outerWidth()


  # gets the colspans of a cell, and falls back to 1
  colSpan: (cell) ->
    return parseInt(cell.attr('colspan')) || 1


  # gets the rowspans of a cell, and falls back to 1
  rowSpan: (cell) ->
    return parseInt(cell.attr('rowspan')) || 1


  # sets the colspan of a cell, removing it if it's 1
  setColSpan: (cell, value) ->
    cell.attr('colspan', if value > 1 then value else null)


  # sets the rowspan of a cell, removing it if it's 1
  setRowSpan: (cell, value) ->
    cell.attr('rowspan', if value > 1 then value else null)


  # work through cells in a row to find the one at a given index
  cellAtIndex: (row, index) ->
    cellIndex = 0
    for cell in row.find('th, td')
      cellIndex += @colSpan($(cell))
      return $(cell) if cellIndex == index
      break if cellIndex > index
    return false


  addColumn: (position = 'after') ->
    includeWidth = @cell.siblings('th, td').length > 1
    currentOffset = @columnOffset(@cell, includeWidth)
    currentColSpan = @colSpan(@cell)

    for row, index in @table.find('tr')
      for cell in $(row).find('th, td')
        cell = $(cell)
        offset = @columnOffset(cell, includeWidth)

        if offset == currentOffset
          colSpan = @colSpan(cell)
          if colSpan > currentColSpan
            @setColSpan(cell, colSpan + 1)
          else
            rowSpan = @rowSpan(cell)
            newCell = $("<#{cell.get(0).tagName}>", {rowspan: rowSpan})
            if position == 'before'
              cell.before(newCell)
              currentOffset = @columnOffset(newCell, includeWidth)
            else
              cell.after(newCell)
            index += rowSpan - 1
          break
        else if offset > currentOffset
          @setColSpan(cell, @colSpan(cell) + 1)
          break


  addRow: (position = 'after') ->
    cellCount = 0
    newRow = $('<tr>')
    for cell in @row.find('th, td')
      cellCount += @colSpan($(cell))
      newCell = $("<#{cell.tagName.toLowerCase()}>", {colspan: cellCount})
      if (rowSpan = @rowSpan($(cell))) > 1
        if position == 'after'
          @setRowSpan($(cell), rowSpan + 1)
          continue
        else
          @setRowSpan(newCell, 1)
      newRow.append(newCell)

    # go up in rows, adjusting cells that intersect
    if cellCount < @columnCount()
      rowCount = 0
      for previousRow in @row.prevAll('tr')
        rowCount += 1
        for cell in $(previousRow).find('td[rowspan], th[rowspan]')
          rowSpan = @rowSpan($(cell))
          if rowSpan > rowCount then @setRowSpan($(cell), rowSpan + 1)

    if position == 'before'
      @row.before(newRow)
    else
      @row.after(newRow)


  removeColumn: ->
    currentLeft = @columnLeft(@cell)
    currentWidth = @columnWidth(@cell)
    currentColSpan = @colSpan(@cell)

    # figure out what we should delete, or adjust
    deletable = []
    adjustable = []
    for row in @table.find('tr')
      for cell in $(row).find('th, td')
        cell = $(cell)
        left = @columnLeft(cell)
        width = @columnWidth(cell)
        if left == currentLeft && width == currentWidth
          deletable.push(cell)
        else if left + width >= currentLeft + currentWidth && !(left > currentLeft)
          adjustable.push(cell)
        else if left == currentLeft && width < currentWidth
          return

    # make the deletions and adjustments
    $(cell).remove() for cell in deletable
    @setColSpan($(cell), @colSpan($(cell)) - currentColSpan) for cell in adjustable


  removeRow: ->
    columnCount = @columnIndex(@row.find('th, td'))

    # go up in rows, adjusting cells that intersect
    if columnCount < @columnCount()
      rowCount = 0
      for previousRow in @row.prevAll('tr')
        rowCount += 1
        for cell in $(previousRow).find('td[rowspan], th[rowspan]')
          rowSpan = @rowSpan($(cell))
          if rowSpan > rowCount then @setRowSpan($(cell), rowSpan - 1)

    # figure out if we should move any cells down
    cells = @row.find('td[rowspan], th[rowspan]')
    moveable = []
    if cells.length
      nextRow = @row.next('tr')
      count = 0
      for cell in cells
        index = @columnIndex($(cell).prevAll('td, th'))
        count += 1
        if cellAtIndex = @cellAtIndex(nextRow, index)
          newCell = $(cell).clone(false)
          @setRowSpan(newCell, @rowSpan(newCell) - 1)
          cellAtIndex.after(newCell)

    @row.remove()


  increaseColSpan: ->
    currentIndex = @columnIndex(@cell.prevAll('td, th')) + @colSpan(@cell)
    currentRowSpan = @rowSpan(@cell)

    nextCell = @cell.next('td, th')
    if nextCell.length
      rowSpan = @rowSpan($(nextCell))
      if rowSpan == currentRowSpan
        # go up in rows to see if there's any intersections
        columnCount = @columnIndex(@row.find('th, td'))
        if columnCount < @columnCount()
          console.debug('intersection possible')
          rowCount = 0
          for previousRow in @row.prevAll('tr')
            rowCount += 1
            for cell in $(previousRow).find('td[rowspan], th[rowspan]')
              console.debug('intersection probable')
              console.debug(@columnIndex($(cell).prevAll('td, th')), currentIndex)


        @setColSpan(@cell, @colSpan(@cell) + @colSpan($(nextCell)))
        $(nextCell).remove()


  increaseRowSpan: ->
    currentLeft = @columnLeft(@cell)
    currentWidth = @columnWidth(@cell)
    currentRowSpan = @rowSpan(@cell)

    nextRow = @row.nextAll('tr').get(currentRowSpan - 1)
    if nextRow
      for cell in $(nextRow).find('th, td')
        left = @columnLeft($(cell))
        width = @columnWidth($(cell))
        if left == currentLeft && width == currentWidth
          @setRowSpan(@cell, @rowSpan(@cell) + @rowSpan($(cell)))
          $(cell).remove()


}

