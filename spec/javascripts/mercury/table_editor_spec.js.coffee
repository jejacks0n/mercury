describe "Mercury.tableEditor", ->

  template 'mercury/table_editor.html'

  beforeEach ->
    @table = $('#table1')
    @cell = @table.find('th, td').first()

  describe "singleton method", ->

    beforeEach ->
      @loadSpy = spyOn(Mercury.tableEditor, 'load').andCallFake(=>)

    it "calls load", ->
      Mercury.tableEditor(@table, @cell)
      expect(@loadSpy.callCount).toEqual(1)

    it "returns the function object", ->
      ret = Mercury.tableEditor(@table, @cell)
      expect(ret).toEqual(Mercury.tableEditor)


  describe "#load", ->

    it "expects a table and a table cell", ->
      Mercury.tableEditor(@table, @cell)
      expect(Mercury.tableEditor.table).toEqual(@table)
      expect(Mercury.tableEditor.cell).toEqual(@cell)

    it "accepts content that will be placed inside cells", ->
      Mercury.tableEditor(@table, @cell, '<br/>')
      expect(Mercury.tableEditor.cellContent).toEqual('<br/>')

    it "sets row based on where the cell is", ->
      Mercury.tableEditor(@table, @cell)
      expect(Mercury.tableEditor.row.get(0)).toEqual(@table.find('tr').get(0))

    it "gets the column count", ->
      Mercury.tableEditor(@table, @cell)
      expect(Mercury.tableEditor.columnCount).toEqual(6)

    it "gets the row count", ->
      Mercury.tableEditor(@table, @cell)
      expect(Mercury.tableEditor.rowCount).toEqual(8)


  describe "#getColumnCount", ->

    it "gets the column count from the alpha row", ->
      Mercury.tableEditor(@table, @cell)
      expect(Mercury.tableEditor.columnCount).toEqual(6)


  describe "#getRowCount", ->

    it "gets the row count", ->
      Mercury.tableEditor(@table, @cell)
      expect(Mercury.tableEditor.rowCount).toEqual(8)


  describe "#cellIndexFor", ->

    it "gives the right index for different cells", ->
      cell = @table.find('#row1 td:nth-child(1n)').get(0)
      expect(Mercury.tableEditor.cellIndexFor(cell)).toEqual(0)

      cell = @table.find('#row2 th:nth-child(2n)').get(0)
      expect(Mercury.tableEditor.cellIndexFor(cell)).toEqual(1)

      cell = @table.find('#row2 th:nth-child(6n)').get(0)
      expect(Mercury.tableEditor.cellIndexFor(cell)).toEqual(5)

      cell = @table.find('#row3 td:nth-child(4n)').get(0)
      expect(Mercury.tableEditor.cellIndexFor(cell)).toEqual(5)

      cell = @table.find('#row7 td:nth-child(2n)').get(0)
      expect(Mercury.tableEditor.cellIndexFor(cell)).toEqual(2)


  describe "#cellSignatureFor", ->

    it "returns an object with cell information", ->
      cell = @table.find('#row2 th:nth-child(3n)').get(0)
      sig = Mercury.tableEditor.cellSignatureFor(cell)
      expect(sig.width).toEqual(1)
      expect(sig.height).toEqual(2)
      expect(sig.right).toEqual(3)

      cell = @table.find('#row2 th:nth-child(5n)').get(0)
      sig = Mercury.tableEditor.cellSignatureFor(cell)
      expect(sig.width).toEqual(1)
      expect(sig.height).toEqual(4)
      expect(sig.right).toEqual(5)

      cell = @table.find('#row7 td:nth-child(1n)').get(0)
      sig = Mercury.tableEditor.cellSignatureFor(cell)
      expect(sig.width).toEqual(2)
      expect(sig.height).toEqual(1)
      expect(sig.right).toEqual(2)

  describe "#findCellByOptionsFor", ->

    it "finds a matching cell in a specific row, based on right", ->
      row = @table.find('#row2').get(0)
      sig = Mercury.tableEditor.findCellByOptionsFor(row, { right: 5 })
      expect(sig.cell.get(0)).toEqual(@table.find('#row2 th:nth-child(5n)').get(0))

    it "finds a cell based on left", ->
      row = @table.find('#row5').get(0)
      sig = Mercury.tableEditor.findCellByOptionsFor(row, { left: 5 })
      expect(sig.cell.get(0)).toEqual(@table.find('#row5 th:nth-child(5n)').get(0))

    it "finds a cell based on left and width", ->
      row = @table.find('#row7').get(0)
      sig = Mercury.tableEditor.findCellByOptionsFor(row, { left: 2, width: 4 })
      expect(sig.cell.get(0)).toEqual(@table.find('#row7 td:nth-child(2n)').get(0))

    describe "when a cell isn't there", ->

      beforeEach ->
        @row = @table.find('#row3').get(0)

      it "returns null", ->
        sig = Mercury.tableEditor.findCellByOptionsFor(@row, { left: 2 })
        expect(sig).toEqual(null)

      it "can force to an adjacent cell", ->
        sig = Mercury.tableEditor.findCellByOptionsFor(@row, { left: 2, forceAdjacent: true })
        expect(sig.cell.get(0)).toEqual(@table.find('#row3 td:nth-child(2n)').get(0))
        expect(sig.direction).toEqual('after')


  describe "#findCellByIntersectionFor", ->

    it "finds cells that intersect vertically, based on the signature of another cell", ->
      sig = Mercury.tableEditor.cellSignatureFor(@table.find('#row6 td:nth-child(3n)'))
      intersectingSig = Mercury.tableEditor.findCellByIntersectionFor(@table.find('#row7'), sig)
      expect(intersectingSig.cell.get(0)).toEqual(@table.find('#row7 td:nth-child(2n)').get(0))


  describe "#columnsFor", ->

    it "returns the total number of cells and colspans for a given collection of cells", ->
      expect(Mercury.tableEditor.columnsFor(@table.find('#row7 td'))).toEqual(6)


  describe "#colspanFor", ->

    it "returns the colspan of a given cell", ->
      cell = @table.find('#row7 td:nth-child(2n)')
      expect(Mercury.tableEditor.colspanFor(cell)).toEqual(4)

    it "defaults to 1", ->
      cell = @table.find('#row6 td:first-child')
      expect(Mercury.tableEditor.colspanFor(cell)).toEqual(1)


  describe "#rowspanFor", ->

    it "returns the rowspan of a given cell", ->
      cell = @table.find('#row2 th:nth-child(5n)')
      expect(Mercury.tableEditor.rowspanFor(cell)).toEqual(4)

    it "defaults to 1", ->
      cell = @table.find('#row6 td:first-child')
      expect(Mercury.tableEditor.rowspanFor(cell)).toEqual(1)


  describe "setColspanFor", ->

    beforeEach ->
      @cell = @table.find('#row2 th:first-child')

    it "sets the colspan for a cell", ->
      Mercury.tableEditor.setColspanFor(@cell, 20)
      expect(@cell.attr('colspan')).toEqual('20')

    it "removes the attribute if it's 1", ->
      Mercury.tableEditor.setColspanFor(@cell, 1)
      expect(@cell.attr('colspan')).toEqual(undefined)


  describe "setRowspanFor", ->

    beforeEach ->
      @cell = @table.find('#row2 th:first-child')

    it "sets the rowspan for a cell", ->
      Mercury.tableEditor.setRowspanFor(@cell, 20)
      expect(@cell.attr('rowspan')).toEqual('20')

    it "removes the attribute if it's 1", ->
      Mercury.tableEditor.setRowspanFor(@cell, 1)
      expect(@cell.attr('rowspan')).toEqual(undefined)
