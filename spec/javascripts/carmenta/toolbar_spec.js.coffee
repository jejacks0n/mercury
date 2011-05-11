Carmenta = {}
require '/assets/carmenta/config.js'
require '/assets/carmenta/toolbar.js'
require '/assets/carmenta/toolbar_button.js'
require '/assets/carmenta/toolbar_buttongroup.js'

describe "Carmenta.Toolbar", ->

  beforeEach ->
    @toolbar = new Carmenta.Toolbar({appendTo: '#test'})

  afterEach ->
    @toolbar = null
    delete(@toolbar)

  it "accepts options as an argument", ->
    expect(@toolbar.options).toEqual({appendTo: '#test'})

  it "appends to an element", ->
    expect($('.carmenta-toolbar-container').length).toEqual(1);

  it "builds out toolbar elements", ->
    expect($('.carmenta-primary-toolbar').length).toEqual(1);
    expect($('.carmenta-htmlregion-toolbar').length).toEqual(1);

  it "builds out buttons, buttongroups, and separators", ->
    expect($('.carmenta-primary-toolbar .carmenta-save-button').length).toEqual(1);
    expect($('.carmenta-htmlregion-toolbar .carmenta-decoration-group .carmenta-bold-button').length).toEqual(1);

    expect($('.carmenta-separator').length).toBeGreaterThan(1);
    expect($('.carmenta-line-separator').length).toBeGreaterThan(1);
