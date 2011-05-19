Carmenta = {}
require '/assets/carmenta/table.js'

describe "Carmenta.Table", ->

  template('table.html')

  it "accepts a table in the constructor", ->
    table = new Carmenta.Table($('#carmenta_table'))
    expect(table.element).toBeDefined()
