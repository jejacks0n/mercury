#= require spec_helper
#= require mercury/core/view
#= require mercury/views/modules/filterable_list

describe "Mercury.View.Modules.FilterableList", ->

  Klass = null
  Module = Mercury.View.Modules.FilterableList
  subject = null

  beforeEach ->
    class Klass extends Mercury.View
      @include Module
    subject = new Klass()

  describe "#included", ->

    beforeEach ->
      @mock =
        on: spy(),
        buildFilterable: ->

    it "binds to the build event", ->
      Module.included.call(@mock)
      expect( @mock.on ).calledWith('show', @mock.buildFilterable)


  describe "#buildFilterable", ->

    beforeEach ->
      @cachedLiquidMetal = window.LiquidMetal

    afterEach ->
      window.LiquidMetal = @cachedLiquidMetal

    it "hides the filter and returns if LiquidMetal isn't defined", ->
      window.LiquidMetal = null
      mock = hide: spy(-> '_hide_')
      spyOn(subject, '$', -> mock)
      ret = subject.buildFilterable()
      expect( mock.hide ).called
      expect( ret ).to.eq('_hide_')

    it "calls #delegateEvents", ->
      spyOn(subject, 'delegateEvents')
      subject.buildFilterable()
      expect( subject.delegateEvents ).calledWith
        'keyup input.mercury-filter': subject.onFilter # todo: this could go away eventually
        'search input.mercury-filter': subject.onFilter


  describe "#onFilter", ->

    beforeEach ->
      @e = target: '<input value="_val_">'

    it "loops through all the elements with a data-filter and shows / hides them", ->
      spyOn(subject, '$', -> ['<i data-filter="foo">', '<i data-filter="bar">'])
      spyOn(LiquidMetal, 'score', (val) -> if val == 'foo' then 1 else 0)
      spyOn($.fn, 'hide')
      spyOn($.fn, 'show')
      subject.onFilter(@e)
      expect( LiquidMetal.score ).calledWith('foo', '_val_')
      expect( LiquidMetal.score ).calledWith('bar', '_val_')
      expect( $.fn.hide ).calledOnce
      expect( $.fn.show ).calledOnce
