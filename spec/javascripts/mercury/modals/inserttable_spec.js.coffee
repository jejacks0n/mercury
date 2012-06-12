describe "Mercury.modalHandlers.insertTable", ->

  template 'mercury/modals/inserttable.html'

  beforeEach ->
    @modal =
      element: $('#test')
      hide: ->
    @insertTable = $.extend(@modal, Mercury.modalHandlers.insertTable)

  describe "initializing", ->

    beforeEach ->
      @tableEditorSpy = spyOn(Mercury, 'tableEditor').andCallFake(=>)
      @insertTable.initialize()

    it "selects the first cell", ->
      expect($('#cell1').hasClass('selected')).toEqual(true)

    it "sets the table editor up", ->
      expect(@tableEditorSpy.callCount).toEqual(1)
      expect(@tableEditorSpy.argsForCall[0][0].get(0)).toEqual($('table').get(0))
      expect(@tableEditorSpy.argsForCall[0][1].get(0)).toEqual($('#cell1').get(0))

  describe "clicking on the cells", ->

    beforeEach ->
      @tableEditorSpy = spyOn(Mercury, 'tableEditor').andCallFake(=>)
      @insertTable.initialize()

    it "should unselect any selected cells", ->
      jasmine.simulate.click($('#cell2').get(0))
      expect($('#cell1').hasClass('selected')).toEqual(false)

    it "selects the cell clicked on", ->
      jasmine.simulate.click($('#cell2').get(0))
      expect($('#cell2').hasClass('selected')).toEqual(true)

    it "sets the table editor to use the selected cell", ->
      jasmine.simulate.click($('#cell2').get(0))
      expect(@tableEditorSpy.callCount).toEqual(2)
      expect(@tableEditorSpy.argsForCall[1][1].get(0)).toEqual($('#cell2').get(0))


  describe "clicking on the action buttons", ->

    beforeEach ->
      @addRowBeforeSpy    = spyOn(Mercury.tableEditor, 'addRowBefore').andCallFake(=>)
      @addRowSpy          = spyOn(Mercury.tableEditor, 'addRow').andCallFake(=>)
      @removeRowSpy       = spyOn(Mercury.tableEditor, 'removeRow').andCallFake(=>)
      @addColumnBeforeSpy = spyOn(Mercury.tableEditor, 'addColumnBefore').andCallFake(=>)
      @addColumnSpy       = spyOn(Mercury.tableEditor, 'addColumn').andCallFake(=>)
      @removeColumnSpy    = spyOn(Mercury.tableEditor, 'removeColumn').andCallFake(=>)
      @increaseColspanSpy = spyOn(Mercury.tableEditor, 'increaseColspan').andCallFake(=>)
      @decreaseColspanSpy = spyOn(Mercury.tableEditor, 'decreaseColspan').andCallFake(=>)
      @increaseRowspanSpy = spyOn(Mercury.tableEditor, 'increaseRowspan').andCallFake(=>)
      @decreaseRowspanSpy = spyOn(Mercury.tableEditor, 'decreaseRowspan').andCallFake(=>)
      @insertTable.initialize()

    it "adds a row before the selected cell", ->
      jasmine.simulate.click($('[data-action=addRowBefore]').get(0))
      expect(@addRowBeforeSpy.callCount).toEqual(1)

    it "adds a row after the selected cell", ->
      jasmine.simulate.click($('[data-action=addRow]').get(0))
      expect(@addRowSpy.callCount).toEqual(1)

    it "deletes the row of the selected cell", ->
      jasmine.simulate.click($('[data-action=removeRow]').get(0))
      expect(@removeRowSpy.callCount).toEqual(1)

    it "adds a column before the selected cell", ->
      jasmine.simulate.click($('[data-action=addColumnBefore]').get(0))
      expect(@addColumnBeforeSpy.callCount).toEqual(1)

    it "adds a column after the selected cell", ->
      jasmine.simulate.click($('[data-action=addColumn]').get(0))
      expect(@addColumnSpy.callCount).toEqual(1)

    it "deletes the column of the selected cell", ->
      jasmine.simulate.click($('[data-action=removeColumn]').get(0))
      expect(@removeColumnSpy.callCount).toEqual(1)

    it "increases the colspan of the selected cell", ->
      jasmine.simulate.click($('[data-action=increaseColspan]').get(0))
      expect(@increaseColspanSpy.callCount).toEqual(1)

    it "decreases the colspan of the selected cell", ->
      jasmine.simulate.click($('[data-action=decreaseColspan]').get(0))
      expect(@decreaseColspanSpy.callCount).toEqual(1)

    it "increases the rowspan of the selected cell", ->
      jasmine.simulate.click($('[data-action=increaseRowspan]').get(0))
      expect(@increaseRowspanSpy.callCount).toEqual(1)

    it "decreases the rowspan of the selected cell", ->
      jasmine.simulate.click($('[data-action=decreaseRowspan]').get(0))
      expect(@decreaseRowspanSpy.callCount).toEqual(1)


  describe "changing the alignment", ->

    it "changes the alignment of the table", ->


  describe "changing the border", ->

    beforeEach ->
      @insertTable.initialize()

    it "changes the border of the table", ->
      $('#table_border').val('19')
      jasmine.simulate.keyup($('#table_border').get(0))
      expect($('table').attr('border')).toEqual('19')

    it "handles non-numeric values", ->
      $('#table_border').val('2x')
      jasmine.simulate.keyup($('#table_border').get(0))
      expect($('table').attr('border')).toEqual('2')


  describe "changing the cellspacing", ->

    beforeEach ->
      @insertTable.initialize()

    it "changes the cellspacing of the table", ->
      $('#table_spacing').val('5')
      jasmine.simulate.keyup($('#table_spacing').get(0))
      expect($('table').attr('cellspacing')).toEqual('5')

    it "handles non-numeric values", ->
      $('#table_spacing').val('12x')
      jasmine.simulate.keyup($('#table_spacing').get(0))
      expect($('table').attr('cellspacing')).toEqual('12')


  describe "submitting", ->

    beforeEach ->
      @insertTable.initialize()

    it "triggers an action", ->
      spy = spyOn(Mercury, 'trigger').andCallFake(=>)
      jasmine.simulate.click($('input[type=submit]').get(0))
      expect(spy.callCount).toEqual(1)
      expect(spy.argsForCall[0][0]).toEqual('action')
      expect(spy.argsForCall[0][1]['action']).toEqual('insertTable')
      value = spy.argsForCall[0][1]['value']
      expect(value).toContain('border="1"')
      expect(value).toContain('cellspacing="0"')
      expect(value).toContain('<td id="cell2"><br></td>')

    it "hides the modal", ->
      spy = spyOn(@modal, 'hide').andCallFake(=>)
      jasmine.simulate.click($('input[type=submit]').get(0))
      expect(spy.callCount).toEqual(1)
