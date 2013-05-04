#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/selection_value

describe "Mercury.Region.Modules.SelectionValue", ->

  Klass = null
  Module = Mercury.Region.Modules.SelectionValue
  subject = null

  beforeEach ->
    class Klass extends Mercury.Region
      @include Module
    subject = new Klass('<div id="foo">')

  describe "#toStack", ->

    beforeEach ->
      spyOn(subject, 'toJSON', -> '_json_')

    it "returns the expected object", ->
      expect( subject.toStack() ).to.eql(val: '_json_', sel: undefined)

    it "includes the selection if possible", ->
      subject.getSerializedSelection = -> '_selection_'
      expect( subject.toStack() ).to.eql(val: '_json_', sel: '_selection_')


  describe "#fromStack", ->

    beforeEach ->
      spyOn(subject, 'fromJSON')

    it "calls #fromJSON", ->
      subject.fromStack(val: '_val_')
      expect( subject.fromJSON ).calledWith('_val_')

    it "calls #setSerializeSelection if there's a method and a selection", ->
      subject.setSerializedSelection = spy()
      subject.fromStack(val: '_val_', sel: '_sel_')
      expect( subject.setSerializedSelection ).calledWith('_sel_')

    it "does nothing if the value isn't present", ->
      subject.fromStack()
      expect( subject.fromJSON ).not.called
