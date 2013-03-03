#= require spec_helper
#= require mercury/core/region

describe "Mercury.Region", ->

  Klass = ->
  subject = null

  beforeEach ->
    Mercury.configure 'regions', identifier: 'id', attribute: 'data-mercury'
    class Klass extends Mercury.Region
      supported: true
    subject = new Klass('<div data-mercury="foo" id="test">')

  describe "Modules", ->

    it "includes in the expected modules", ->
      expect( Klass.config ).to.be.a('Function')
      expect( Klass.on ).to.be.a('Function')
      expect( Klass.t ).to.be.a('Function')
      expect( subject.on ).to.be.a('Function')
      expect( subject.config ).to.be.a('Function')
      expect( subject.t ).to.be.a('Function')
      expect( subject.log ).to.be.a('Function')
      expect( subject.pushStack ).to.be.a('Function')


  describe ".define", ->

    it "assigns @className, @type and @actions", ->
      Klass.define('TestRegion', '_test_', foo: 'bar')
      expect( Klass.className ).to.eq('TestRegion')
      expect( Klass.type ).to.eq('_test_')
      expect( Klass.actions ).to.eql(foo: 'bar')

    it "sets the @logPrefix", ->
      Klass.define('TestRegion')
      expect( Klass.logPrefix ).to.eq('TestRegion:')
      expect( Klass.prototype.logPrefix ).to.eq('TestRegion:')

    it "calls .off", ->
      spyOn(Klass, 'off')
      Klass.define('TestRegion')
      expect( Klass.off ).called

    it "returns itself for chaining" ,->
      expect( Klass.define('TestRegion') ).to.eq(Klass)


  describe ".create", ->

    beforeEach ->
      Mercury.FooRegion = spy()
      spyOn(Klass, 'notify')
      spyOn(Klass.prototype, 'notify')

    it "instantiates the expected region class with the element", ->
      Klass.create('<div data-mercury="foo">')
      expect( Mercury.FooRegion ).called

    it "detects the type using the configurable attribute", ->
      Mercury.configure 'regions:attribute', 'data-type'
      Klass.create('<div data-type="fOo">')
      expect( Mercury.FooRegion ).called

    it "notifies if there was no type detected", ->
      Klass.create('<div id="test">')
      expect( Klass.notify ).calledWith('region type not provided')

    it "notifies if we're falling back to the base region", ->
      Klass.create('<div data-mercury="bar" id="test">')
      expect( Klass.notify ).calledWith('unknown "BarRegion" region type, falling back to base region')


  describe "#constructor", ->

    beforeEach ->
      spyOn(Klass.prototype, 'notify')

    it "notifies if not supported", ->
      Klass.supported = false
      subject = new Klass()
      expect( subject.notify ).calledWith('is unsupported in this browser')

    it "sets the name from the configurable attribute", ->
      subject = new Klass('<div id="_name_">')
      expect( subject.name ).to.eq('_name_')
      Mercury.configure 'regions:identifier', 'data-name'
      subject = new Klass('<div data-name="_name_">')
      expect( subject.name ).to.eq('_name_')

    it "sets a tabindex (so it's focusable)", ->
      subject = new Klass('<div id="_name_">', focusable: true)
      expect( subject.attr('tabindex') ).to.eq('0')
      subject = new Klass('<div id="_name_">', focusable: false)
      expect( subject.attr('tabindex') ).to.be.undefined

    it "allows passing the name", ->
      subject = new Klass('<div>', name: '_name_')
      expect( subject.name ).to.eq('_name_')

    it "notifies if we have no name", ->
      subject = new Klass('<div>')
      expect( Klass.prototype.notify ).calledWith('no name provided for the "unknown" region, falling back to random')

    it "falls back to a random name if we have no name", ->
      spyOn(Math, 'random', -> 42)
      subject = new Klass('<div>')
      expect( subject.name ).to.eq('unknown420000')

    it "sets default instance vars (and allows them to be overridden)", ->
      subject = new Klass('<div id="name">')
      expect( subject.previewing ).to.be.false
      expect( subject.focused ).to.be.false
      subject = new Klass('<div id="name">', previewing: true, focused: true)
      expect( subject.previewing ).to.be.true
      expect( subject.focused ).to.be.true

    it "calls #bindDefaultEvents", ->
      spyOn(Klass.prototype, 'bindDefaultEvents')
      subject = new Klass('<div id="name">')
      expect( Klass.prototype.bindDefaultEvents ).called


  describe "#bindDefaultEvents", ->

    it "calls #delegateEvents with commen events", ->
      spyOn(subject, 'delegateEvents')
      subject.bindDefaultEvents()
      expect( subject.delegateEvents ).calledWith
        focus: sinon.match.func
        blur: sinon.match.func

    it "binds to the global 'action' event", ->
      spyOn(subject, 'handleAction')
      spyOn(Mercury, 'on').callsArgOnWith(1, subject, 1, 2, '3')
      subject.bindDefaultEvents()
      expect( Mercury.on ).calledWith('action', sinon.match.func)
      expect( subject.handleAction ).calledWith(1, 2, '3')

    it "calls #delegateActions with what we've defined", ->
      subject.actions = {foo: 'bar'}
      subject.constructor.actions = {bit: 'bot'}
      spyOn(subject, 'delegateActions')
      subject.bindDefaultEvents()
      expect( subject.delegateActions ).calledWith(foo: 'bar', bit: 'bot')

    it "calls #delegateDropFile of we respond to #dropFile", ->
      subject.onDropFile = ->
      spyOn(subject, 'delegateDropFile')
      subject.bindDefaultEvents()
      expect( subject.delegateDropFile ).called

    describe "delegated events", ->

      beforeEach ->
        @events = {}
        spyOn(subject, 'delegateEvents', => @events = arguments[0])
        spyOn(subject, 'trigger')
        subject.bindDefaultEvents()

      it "has a focus that triggers an event and calls #onFocus if it exists", ->
        @events.focus()
        subject.onFocus = spy()
        @events.focus()
        expect( subject.trigger ).calledWith('focus')
        expect( subject.onFocus ).calledOnce

      it "has a blur that triggers an event and calls #onBlur if it exists", ->
        @events.blur()
        subject.onBlur = spy()
        @events.blur()
        expect( subject.trigger ).calledWith('blur')
        expect( subject.onBlur ).calledOnce


  describe "#handleAction", ->

    beforeEach ->
      subject.focused = true
      subject.actions = {foo: spy()}

    it "calls the action we've delegated", ->
      subject.handleAction('foo', 1, 2, '3')
      expect( subject.actions.foo ).calledWith(1, 2, '3')

    it "doesn't call the action we've delegated if not focused", ->
      subject.focused = false
      subject.handleAction('foo', 1, 2, '3')
      expect( subject.actions.foo ).not.called


  describe "#focus", ->

    it "sets @focused to true", ->
      subject.focus()
      expect( subject.focused ).to.be.true

    it "calls focus on the element", ->
      spyOn(subject.el, 'focus')
      subject.focus()
      expect( subject.el.focus ).called

    it "calls @onFocus if it's defined", ->
      subject.onFocus = spy()
      subject.focus()
      expect( subject.onFocus ).called


  describe "#blur", ->

    it "sets @focused to false", ->
      subject.blur()
      expect( subject.focused ).to.be.false

    it "calls blur on the element", ->
      spyOn(subject.el, 'blur')
      subject.blur()
      expect( subject.el.blur ).called

    it "calls @onBlur if it's defined", ->
      subject.onBlur = spy()
      subject.blur()
      expect( subject.onBlur ).called


  describe "#data", ->

    it "sets the element data", ->
      subject.data(foo: 'bar')
      expect( subject.el.data() ).to.eql(foo: 'bar', mercury: 'foo')
      subject.data('bar', 'baz')
      expect( subject.el.data() ).to.eql(foo: 'bar', mercury: 'foo', bar: 'baz')

    it "returns the element data if don't pass it arguments", ->
      subject.el.data(foo: 'bar')
      expect( subject.data() ).to.eql(foo: 'bar', mercury: 'foo')


  describe "#snippets", ->

    it "returns an object", ->
      expect( subject.snippets() ).to.eql({})


  describe "#toJSON", ->

    beforeEach ->
      subject.name = '_name_'
      subject.constructor.type = '_type_'
      spyOn(subject, 'html', -> '_html_')
      spyOn(subject, 'data', -> '_data_')
      spyOn(subject, 'snippets', -> '_snippets_')

    it "returns the expected object", ->
      expect( subject.toJSON() ).to.eql
        name: '_name_'
        type: '_type_'
        value: '_html_'
        data: '_data_'
        snippets: '_snippets_'


  describe "#release", ->

    it "triggers a release event", ->
      spyOn(subject, 'trigger')
      subject.release()
      expect( subject.trigger ).calledWith('release')

    it "calls #off", ->
      spyOn(subject, 'off')
      subject.release()
      expect( subject.off ).called


  describe "#delegateDropFile", ->

    beforeEach ->
      subject.onDropFile = spy()
      @event =
        preventDefault: spy()
        originalEvent: {dataTransfer: {files: []}}
      spyOn(subject.el, 'on').callsArgOnWith(1, subject, @event)

    it "binds to various drop events so we can drop files", ->
      subject.delegateDropFile()
      expect( subject.el.on ).calledWith('dragenter', sinon.match.func)
      expect( subject.el.on ).calledWith('dragover', sinon.match.func)
      expect( subject.el.on ).calledWith('drop', sinon.match.func)

    it "calls #onDropFile with the expected array when files are dropped (and preventDefault)", ->
      @event.originalEvent.dataTransfer.files = ['_file1_', '_file2_']
      subject.delegateDropFile()
      expect( @event.preventDefault ).calledThrice
      expect( subject.onDropFile ).calledWith(['_file1_', '_file2_'])


  describe "#delegateActions", ->

    describe "binding to a callback directly", ->

      it "resolves the action", ->
        callback = spy()
        subject.delegateActions(action: callback)
        subject.actions['action'](1, 2, '3')
        expect( callback ).calledWith(1, 2, '3')

    describe "binding to a method (by string)", ->

      it "locates the method and resolves the action", ->
        spyOn(subject, 'release')
        subject.delegateActions('action': 'release')
        subject.actions['action']()
        expect( subject.release ).called

      it "throws an exception if the method doesn't exist", ->
        expect(-> subject.delegateActions(event: 'foo') ).to.throw(Error, "foo doesn't exist")
