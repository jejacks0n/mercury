Carmenta = {}
require '/assets/carmenta/config.js'
require '/assets/carmenta/toolbar_button.js'

describe "Carmenta.Toolbar.Button", ->

  it "builds an element", ->
    button = new Carmenta.Toolbar.Button('undo', ['Preview', 'Preview this page', {toggle: true, mode: true}]})
