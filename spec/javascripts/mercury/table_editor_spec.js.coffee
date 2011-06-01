require '/assets/mercury/mercury_editor.js'

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
      Mercury.tableEditor(@table, @cell)
      expect(Mercury.tableEditor.cellIndexFor(@table.find('#row1 td:nth-child(1n)'))).toEqual(0)

      cell = @table.find('#row2 th:nth-child(2n)').get(0)
      expect(Mercury.tableEditor.cellIndexFor(cell)).toEqual(1)

      cell = @table.find('#row2 th:nth-child(6n)').get(0)
      expect(Mercury.tableEditor.cellIndexFor(cell)).toEqual(5)

      cell = @table.find('#row3 td:nth-child(4n)').get(0)
      expect(Mercury.tableEditor.cellIndexFor(cell)).toEqual(5)

      cell = @table.find('#row7 td:nth-child(2n)').get(0)
      expect(Mercury.tableEditor.cellIndexFor(cell)).toEqual(2)


#  describe "#columnCount", ->
#
#    beforeEach ->
#      Mercury.tableEditor(@table, @cell)
#
#    it "counts all the columns, including colspans of the first row", ->
#      count = Mercury.tableEditor.columnCount()
#      expect(count).toEqual(6)
#
#
#  describe "#rowCount", ->
#
#    beforeEach ->
#      Mercury.tableEditor(@table, @cell)
#
#    it "it returns the count of all the rows", ->
#      count = Mercury.tableEditor.rowCount()
#      expect(count).toEqual(8)
#
#
#  describe "#columnOffset", ->
#
#    beforeEach ->
#      @cell = @table.find('#row2 th:first-child')
#      Mercury.tableEditor(@table, @cell)
#
#    it "returns the offset (left) + width of a cell", ->
#      offset = Mercury.tableEditor.columnOffset(@cell)
#      expect(offset).toEqual(104)
#
#    it "returns just the offset (left) of a cell if width isn't included", ->
#      offset = Mercury.tableEditor.columnOffset(@cell, false)
#      expect(offset).toEqual(2)
#
#
#  describe "#colSpan", ->
#
#    beforeEach ->
#
#    it "returns the colspan of a cell", ->
#      @cell = @table.find('#row7 td:nth-child(2n)')
#      expect(Mercury.tableEditor.colSpan(@cell)).toEqual(4)
#
#    it "returns 1 if the cell doesn't have a colspan", ->
#      @cell = @table.find('#row6 td:first-child')
#      expect(Mercury.tableEditor.colSpan(@cell)).toEqual(1)
#
#
#  describe "#rowSpan", ->
#
#    it "returns the rowspan of a cell", ->
#      @cell = @table.find('#row2 th:nth-child(5n)')
#      expect(Mercury.tableEditor.rowSpan(@cell)).toEqual(4)
#
#    it "returns 1 if the cell doesn't have a rowspan", ->
#      @cell = @table.find('#row6 td:first-child')
#      expect(Mercury.tableEditor.rowSpan(@cell)).toEqual(1)
#
#
#  describe "#setColSpan", ->
#
#    beforeEach ->
#      @cell = @table.find('#row2 th:first-child')
#
#    it "sets the colspan of a cell", ->
#      Mercury.tableEditor.setColSpan(@cell, 20)
#      expect(@cell.attr('colspan')).toEqual('20')
#
#    it "removes the colspan entirely if the value was 1", ->
#      Mercury.tableEditor.setColSpan(@cell, 1)
#      expect(@cell.attr('colspan')).toEqual(undefined)
#
#
#  describe "#setRowSpan", ->
#
#    beforeEach ->
#      @cell = @table.find('#row2 th:first-child')
#
#    it "sets the rowspan of a cell", ->
#      Mercury.tableEditor.setRowSpan(@cell, 20)
#      expect(@cell.attr('rowspan')).toEqual('20')
#
#    it "removes the rowspan if the value was 1", ->
#      Mercury.tableEditor.setRowSpan(@cell, 1)
#      expect(@cell.attr('rowspan')).toEqual(undefined)
