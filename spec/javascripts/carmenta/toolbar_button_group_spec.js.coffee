Carmenta = {}
require '/assets/carmenta/toolbar_button_group.js'

describe "Carmenta.Toolbar.ButtonGroup", ->

  it "builds an element", ->
    button = new Carmenta.Toolbar.Button('undo', ['Preview', 'Preview this page', {toggle: true, mode: true}]})
