#= require spec_helper
#= require mercury/core/view

describe "Mercury.View", ->

  Klass = ->
  subject = null

  beforeEach ->
    Mercury.configure 'templates:asyncFetch', true
    class Klass extends Mercury.View
    subject = new Klass()

  describe "Modules", ->

    it "includes in the expected modules", ->
      expect( subject.config ).to.be.a('Function')
      expect( subject.on ).to.be.a('Function')
      expect( subject.t ).to.be.a('Function')
      expect( subject.log ).to.be.a('Function')


  describe "#constructor", ->

    it "assigns instance vars from options passed", ->
      subject = new Klass(foo: 'bar')
      expect( subject.foo ).to.eq('bar')

    it "calls #buildElement", ->
      spyOn(Klass::, 'buildElement')
      subject = new Klass(foo: 'bar')
      expect( Klass::buildElement ).called

    it "merges elements with constructor elements", ->
      Klass.elements = element1: 'foo'
      subject = new Klass(elements: {foo: 'bar'})
      expect( subject.elements ).to.eql(element1: 'foo', foo: 'bar')

    it "merges events with constructor events", ->
      Klass.events = event1: '$'
      subject = new Klass(events: {foo: '$'})
      expect( subject.events ).to.eql(event1: '$', foo: '$')

    it "merges attributes with constructor attributes", ->
      Klass.attributes = attribute1: 'foo'
      subject = new Klass(attributes: {foo: 'bar'})
      expect( subject.attributes ).to.eql(attribute1: 'foo', foo: 'bar')

    it "defaults @subViews to an array", ->
      expect( subject.subviews ).to.eql([])
      subject = new Klass(subviews: [1, 2])
      expect( subject.subviews ).to.eql([1, 2])

    it "calls #build if one is defined", ->
      Klass::build = spy()
      subject = new Klass()
      expect( subject.build ).called

    it "triggers a build event", ->
      spyOn(Klass::, 'trigger')
      subject = new Klass()
      expect( subject.trigger ).calledWith('build')

    it "calls #delegateEvents if there's events", ->
      spyOn(Klass::, 'delegateEvents')
      subject = new Klass(events: {foo: 'bar'})
      expect( subject.delegateEvents ).calledWith(foo: 'bar')

    it "calls #refreshElements", ->
      spyOn(Klass::, 'refreshElements')
      subject = new Klass(elements: {foo: 'bar'})
      expect( subject.refreshElements ).called

    it "calls super", ->
      spyOn(Klass.__super__, 'constructor')
      subject = new Klass(foo: 'bar')
      expect( Klass.__super__.constructor ).calledWith(foo: 'bar')

    it "triggers an init event", ->
      spyOn(Klass::, 'trigger')
      subject = new Klass()
      expect( subject.trigger ).calledWith('init')


  describe "#buildElement", ->

    beforeEach ->
      subject.$el = subject.el = null

    it "creates an element", ->
      subject.buildElement()
      expect( subject.$el.is('div') ).to.be.true

    it "creates an element with expected attributes", ->
      subject.tag = 'section'
      subject.className = 'test_class'
      subject.attributes = id: 'test_id', class: 'extra_class'
      subject.buildElement()
      expect( subject.$el.is('section') ).to.be.true
      expect( subject.$el.attr('id') ).to.eq('test_id')
      expect( subject.$el.attr('class') ).to.eq('extra_class test_class')

    it "doesn't create an element if already created", ->
      subject.$el = $('<foo>')
      subject.buildElement()
      expect( subject.$el.is('foo') ).to.be.true
      expect( subject.el ).to.eq(subject.$el.get(0))

    it "calls #renderTemplate if one is set", ->
      subject.template = '_foo_'
      spyOn(subject, 'renderTemplate')
      subject.buildElement()
      expect( subject.renderTemplate ).calledWith('_foo_')

    it "calls #renderTemplate if one is set on the constructor", ->
      Klass.template = '_bar_'
      spyOn(subject, 'renderTemplate')
      subject.buildElement()
      expect( subject.renderTemplate ).calledWith('_bar_')


  describe "#$", ->

    it "finds within the scope of @$el", ->
      subject.$el.append('<section id="test"></section>')
      expect( subject.$('#test').is('#test') ).to.be.true


  describe "#addClass", ->

    it "adds the class to @$el", ->
      subject.addClass('foo')
      expect( subject.$el.hasClass('foo') ).to.be.true


  describe "#removeClass", ->

    it "removes the class from @$el", ->
      subject.$el.addClass('foo')
      subject.removeClass('foo')
      expect( subject.$el.hasClass('foo') ).to.be.false


  describe "#attr", ->

    it "adds the attributes to @$el", ->
      subject.attr('id', 'test_id')
      expect( subject.$el.is('#test_id') ).to.be.true
      subject.attr(title: 'test_title')
      expect( subject.$el.is('[title=test_title]') ).to.be.true

    it "returns the attr requested", ->
      subject.$el.attr(foo: 'bar')
      expect( subject.attr('foo') ).to.eq('bar')
      expect( subject.attr() ).to.eq(subject.$el)


  describe "#css", ->

    it "adds the css to @$el", ->
      subject.css(backgroundColor: 'blue')
      expect( subject.css('backgroundColor') ).to.eq('blue')
      subject.css('backgroundColor', 'red')
      expect( subject.css('backgroundColor') ).to.eq('red')

    it "returns the css requested", ->
      subject.$el.css('backgroundColor', 'blue')
      expect( subject.css('background') ).to.eq('blue')


  describe "#html", ->

    it "sets the html to the element passed (or element.el/element.$el)", ->
      html = '<section id="test"></section>'
      subject.html(html)
      expect( subject.$el.html() ).to.eq(html)
      subject.html('')
      expect( subject.$el.html() ).to.eq('')
      subject.html($el: html)
      expect( subject.$el.html() ).to.eq(html)
      subject.html(el: html)
      expect( subject.$el.html() ).to.eq(html)

    it "calls #refreshElements", ->
      spyOn(subject, 'refreshElements')
      subject.html('')
      expect( subject.refreshElements ).called

    it "returns @$el for chaining", ->
      expect( subject.html('') ).to.eq(subject.$el)

    it "returns the content if no arguments were passed", ->
      subject.$el.append('foo')
      expect( subject.html() ).to.eq('foo')


  describe "#append", ->

    it "appends the elements (or [elements].el/[elements].$el)", ->
      els = ['<section id="test"></section>', '<section id="test2"></section>', '<section id="test3"></section>']
      subject.append(els[0], {el: els[1]}, {$el: els[2]})
      expect( subject.$el.find('#test').is('section') ).to.be.true
      expect( subject.$el.find('#test2').is('section') ).to.be.true
      expect( subject.$el.find('#test3').is('section') ).to.be.true

    it "calls #refreshElements", ->
      spyOn(subject, 'refreshElements')
      subject.append('')
      expect( subject.refreshElements ).called

    it "returns @$el for chaining", ->
      expect( subject.append('') ).to.eq(subject.$el)


  describe "#appendTo", ->

    beforeEach ->
      @el = $('<div>')

    it "appends itself to the element passed (or element.el/element.$el)", ->
      subject.appendTo(@el)
      expect( @el.html() ).to.eq('<div></div>')
      @el.html('')
      subject.appendTo(el: @el)
      expect( @el.html() ).to.eq('<div></div>')
      @el.html('')
      subject.appendTo($el: @el)
      expect( @el.html() ).to.eq('<div></div>')

    it "returns @$el for chaining", ->
      expect( subject.appendTo(@el) ).to.eq(subject.$el)


  describe "#appendView", ->

    beforeEach ->
      @subview =
        $el: '_$el_'
        el: '_el_'

    it "calls appendTo on the view if it's available", ->
      el = foo: 'bar'
      @subview.appendTo = spy()
      subject.appendView(el, @subview)
      expect( @subview.appendTo ).calledWith(el)

    it "appends the view to the element we provide", ->
      el = append: spy()
      subject.appendView(el, @subview)
      expect( el.append ).calledWith('_$el_')

    it "tracks the view that was added", ->
      el = append: spy()
      subject.appendView(el, @subview)
      expect( subject.subviews ).to.eql([@subview])

    it "allows providing just the view (to append to @$el)", ->
      @subview.$el = null
      spyOn(subject.$el, 'append')
      subject.appendView(@subview)
      expect( subject.$el.append ).calledWith('_el_')

    it "allows providing a selector", ->
      subject.$el.append('<div class="subview">')
      subject.appendView('.subview', @subview)
      expect( subject.$el.find('.subview').html() ).to.eq('_$el_')

    it "returns the view", ->
      expect( subject.appendView(@subview) ).to.eq(@subview)


  describe "#delay", ->

    it "delays and then calls the method", ->
      spyOn(window, 'setTimeout')
      window.setTimeout.yields()
      callback = spy()
      subject.delay(1, callback)
      expect( window.setTimeout ).called
      expect( callback ).calledOn(subject)


  describe "#refreshElements", ->

    it "assigns elements to instance variables", ->
      subject.html('<section id="test"></section><section id="test2"></section>')
      subject.elements = test: '#test', test2: '#test2'
      subject.refreshElements()
      expect( subject.$test.is('section#test') ).to.be.true
      expect( subject.$test2.is('section#test2') ).to.be.true


  describe "#renderTemplate", ->

    it "renders the template", ->
      JST['/mercury/templates/foo'] = ->
      spyOn(JST, '/mercury/templates/foo', -> '_foo_function_template_')
      options = foo: 'bar'
      expect( subject.renderTemplate('foo', options) ).to.eq('_foo_function_template_')
      expect( JST['/mercury/templates/foo'] ).calledOn(options)

    it "falls back to a string", ->
      JST['/mercury/templates/foo'] = '_foo_string_template_'
      expect( subject.renderTemplate('foo') ).to.eq('_foo_string_template_')

    it "calls #fetchTemplate if a template wasn't found and we allow falling back", ->
      Mercury.configure 'templates:enabled', true
      spyOn(subject, 'fetchTemplate', -> '_ajax_template_')
      expect( subject.renderTemplate('bar') ).to.eq('_ajax_template_')
      expect( subject.fetchTemplate ).calledWith('bar')

    it "doesn't calls #fetchTemplate if we don't allow falling back", ->
      Mercury.configure 'templates:enabled', false
      spyOn(subject, 'fetchTemplate', -> '_ajax_template_')
      expect( subject.renderTemplate('bar') ).to.be.undefined
      expect( subject.fetchTemplate ).not.called

    it "allows passing a function to render", ->
      template = spy(-> "_spy_template_#{@foo}_")
      options = foo: 'bar'
      expect( subject.renderTemplate(template, options) ).to.eql('_spy_template_bar_')
      expect( template ).called


  describe "#fetchTemplate", ->

    beforeEach ->
      Mercury.configure 'templates:prefixUrl', '/foo/bar'
      @server = sinon.fakeServer.create()
      @server.respondWith('GET', '/foo/bar/baz', [200, {'Content-Type': 'text/html'}, '_ajax_template_'])

    it "makes an ajax call for the template", ->
      result = subject.fetchTemplate('baz')
      expect( result ).to.eq('_ajax_template_')


  describe "#focusFirstFocusable", ->

    it "focuses the first element that can be focused", ->
      mock = focus: spy()
      spyOn(subject, '$', -> [mock])
      subject.focusFirstFocusable()
      expect( subject.$ ).calledWith(':input:visible[tabindex != "-1"]')
      expect( mock.focus ).called


  describe "#prevent", ->

    beforeEach ->
      @e =
        preventDefault: spy()
        stopPropagation: spy()

    it "calls preventDefault on the event", ->
      subject.prevent(@e)
      expect( @e.preventDefault ).called

    it "calls stopPropagation on the event if asked", ->
      subject.prevent(@e, true)
      expect( @e.preventDefault ).called
      expect( @e.stopPropagation ).called

    it "does nothing if the event isn't a valid event", ->
      subject.prevent({})
      subject.prevent(false)


  describe "#preventStop", ->

    it "calls #prevent", ->
      spyOn(subject, 'prevent')
      subject.preventStop('_e_')
      expect( subject.prevent ).calledWith('_e_', true)


  describe "#release", ->

    it "triggers a release event", ->
      spyOn(subject, 'trigger')
      subject.release()
      expect( subject.trigger ).calledWith('release')

    it "calls #releaseSubviews", ->
      spyOn(subject, 'releaseSubviews')
      subject.release()
      expect( subject.releaseSubviews ).called

    it "removes the element", ->
      el = $('<div>').append(subject.$el)
      subject.release()
      expect( el.html() ).to.eq('')

    it "calls #off", ->
      spyOn(subject, 'off')
      subject.release()
      expect( subject.off ).called

    it "calls Mercury.off for all events stored in the global handlers", ->
      spyOn(Mercury, 'off')
      subject.__global_handlers__ = foo: 'bar', bar: 'baz'
      subject.release()
      expect( Mercury.off ).calledWith('foo', 'bar')
      expect( Mercury.off ).calledWith('bar', 'baz')


  describe "#releaseSubviews", ->

    beforeEach ->
      @mock1 = release: spy()
      @mock2 = release: spy()
      subject.subviews = [@mock1, @mock2]

    it "calls release on each of the subviews", ->
      subject.releaseSubviews()
      expect( @mock1.release ).called
      expect( @mock2.release ).called

    it "resets subviews back to an empty array", ->
      subject.releaseSubviews()
      expect( subject.subviews ).to.eql([])


  describe "#delegateEvents", ->

    beforeEach ->
      subject.$el = on: ->
      spyOn(subject.$el, 'on')

    it "accepts an element and events, or just events", ->
      otherEl = on: spy()
      subject.delegateEvents(otherEl, foo: ->)
      expect( otherEl.on ).calledWith('foo', null, sinon.match.func)


    describe "binding to a callback directly", ->

      it "adds the event", ->
        callback = spy()
        subject.delegateEvents(event: callback)
        expect( subject.$el.on ).calledWith('event', null)
        subject.$el.on.callArg(2, 'foo')
        expect( callback ).calledWith('foo')
        expect( callback ).calledOn(subject)

    describe "binding to a method (by string)", ->

      it "locates the method and binds the event", ->
        spyOn(subject, 'release')
        subject.delegateEvents('event   ': 'release')
        expect( subject.$el.on ).calledWith('event', null)
        subject.$el.on.callArg(2, 'foo')
        expect( subject.release ).calledWith('foo')

      it "throws an exception if the method doesn't exist", ->
        expect(-> subject.delegateEvents(event: 'foo') ).to.throw(Error, "foo doesn't exist")

    describe "binding to global events (by using : in the event name)", ->

      beforeEach ->
        spyOn(Mercury, 'on')

      it "calls the global Mercury.on", ->
        callback = spy()
        subject.delegateEvents('mercury:global:event': callback)
        expect( Mercury.on ).calledWith('global:event')
        Mercury.on.callArg(1, 'foo')
        expect( callback ).calledWith('foo')
        expect( callback ).calledOn(subject)
        expect( subject.__global_handlers__ ).to.have.keys(['global:event'])

    describe "binding to trigger a global event (by using : in the key)", ->

      it "triggers a global event", ->
        spyOn(Mercury, 'trigger')
        subject.delegateEvents(event: 'mercury:global:event')
        expect( subject.$el.on ).calledWith('event')
        subject.$el.on.callArg(2)
        expect( Mercury.trigger ).calledWith('global:event', subject)

    describe "with a selector", ->

      it "binds the event using that selector", ->
        callback = spy()
        subject.delegateEvents('event selector': callback)
        expect( subject.$el.on ).calledWith('event', 'selector')
        subject.$el.on.callArg(2)
        expect( callback ).called
