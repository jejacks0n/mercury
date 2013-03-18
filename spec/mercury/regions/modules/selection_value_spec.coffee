#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/selection_value

describe "Mercury.Region.Modules.SelectionValue", ->

  Klass = null
  Module = Mercury.Region.Modules.SelectionValue
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    class Klass extends Mercury.Region
      @include Module
    subject = new Klass('<div id="foo">')

  describe "#value", ->

    it "returns the value if no value was passed", ->
      subject.html('_value_')
      expect( subject.value() ).to.eq('_value_')

    describe "setting the value", ->

      it "sets the html to the value", ->
        subject.value('_value_')
        expect( subject.html() ).to.eq('_value_')

      it "can use an object to set the value and selection", ->
        subject.setSerializedSelection = spy()
        subject.value(val: '_value_', sel: {start: 1, end: 2})
        expect( subject.setSerializedSelection ).calledWith(start: 1, end: 2)
        expect( subject.html() ).to.eq('_value_')


  describe "#valueForStack", ->

    it "returns the selection and value", ->
      spyOn(subject, 'value', -> '_value_')
      subject.getSerializedSelection = ->
      spyOn(subject, 'getSerializedSelection', -> '1:2')
      expect( subject.valueForStack() ).to.eql(sel: '1:2', val: '_value_')
