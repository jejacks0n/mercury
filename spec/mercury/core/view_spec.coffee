#= require spec_helper
#= require mercury/core/view

describe "Mercury.View", ->

  Klass = ->
  subject = null

  beforeEach ->
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

    it "creates an element", ->
      subject = new Klass()
      expect( $('<div>').append(subject.el).html() ).to.eq('<div></div>')

    it "creates an element with expected attributes", ->
      subject = new Klass(tag: 'section', className: 'test_class', attributes: {id: 'test_id', class: 'extra_class'})
      expect( subject.el.is('section') ).to.be.true
      expect( subject.el.attr('id') ).to.eq('test_id')
      expect( subject.el.attr('class') ).to.eq('extra_class test_class')

    it "doesn't create an element if already created", ->
      subject = new Klass(el: $('<foo>'))
      expect( subject.el.is('foo') ).to.be.true

    it "loads a template if one was set", ->
      spyOn(Klass.prototype, 'renderTemplate')
      subject = new Klass(template: '_foo_')
      expect( subject.renderTemplate ).calledWith('_foo_')

    it "assigns events to constructor events unless already set", ->
      Klass.events = event1: '$'
      subject = new Klass()
      expect( subject.events ).to.eq(Klass.events)
      subject = new Klass(events: {foo: '$'})
      expect( subject.events ).to.eql(foo: '$')

    it "assigns elements to constructor elements unless passed", ->
      Klass.elements = element1: 'foo'
      subject = new Klass()
      expect( subject.elements ).to.eq(Klass.elements)
      subject = new Klass(elements: {foo: 'bar'})
      expect( subject.elements ).to.eql(foo: 'bar')

    it "calls #build", ->
      Klass.prototype.build = spy()
      subject = new Klass()
      expect( subject.build ).called

    it "calls #delegateEvents if there's events", ->
      spyOn(Klass.prototype, 'delegateEvents')
      subject = new Klass(events: {foo: 'bar'})
      expect( subject.delegateEvents ).calledWith(foo: 'bar')

    it "calls #refreshElements", ->
      spyOn(Klass.prototype, 'refreshElements')
      subject = new Klass(elements: {foo: 'bar'})
      expect( subject.refreshElements ).called


  describe "#$", ->

    it "finds within the scope of @el", ->
      subject.el.append('<section id="test"></section>')
      expect( subject.$('#test').is('#test') ).to.be.true


  describe "#addClass", ->

    it "adds the class to @el", ->
      subject.addClass('foo')
      expect( subject.el.hasClass('foo') ).to.be.true


  describe "#attr", ->

    it "adds the attributes to @el", ->
      subject.attr('id', 'test_id')
      expect( subject.el.is('#test_id') ).to.be.true
      subject.attr(title: 'test_title')
      expect( subject.el.is('[title=test_title]') ).to.be.true

    it "returns the attr requested", ->
      subject.el.attr(foo: 'bar')
      expect( subject.attr('foo') ).to.eq('bar')
      expect( subject.attr() ).to.eq(subject.el)


  describe "#html", ->

    it "sets the html to the element passed (or element.el)", ->
      html = '<section id="test"></section>'
      subject.html(html)
      expect( subject.el.html() ).to.eq(html)
      subject.html('')
      expect( subject.el.html() ).to.eq('')
      subject.html(el: html)
      expect( subject.el.html() ).to.eq(html)

    it "calls #refreshElements", ->
      spyOn(subject, 'refreshElements')
      subject.html('')
      expect( subject.refreshElements ).called

    it "returns @el for chaining", ->
      expect( subject.html('') ).to.eq(subject.el)

    it "returns the content if no arguments were passed", ->
      subject.el.append('foo')
      expect( subject.html() ).to.eq('foo')


  describe "#append", ->

    it "appends the elements (or [elements].el)", ->
      els = ['<section id="test"></section>', '<section id="test2"></section>']
      subject.append(els[0], el: els[1])
      expect( subject.el.find('#test').is('section') ).to.be.true
      expect( subject.el.find('#test2').is('section') ).to.be.true

    it "calls #refreshElements", ->
      spyOn(subject, 'refreshElements')
      subject.append('')
      expect( subject.refreshElements ).called

    it "returns @el for chaining", ->
      expect( subject.append('') ).to.eq(subject.el)


  describe "#appendTo", ->

    beforeEach ->
      @el = $('<div>')

    it "appends itself to the element passed (or element.el)", ->
      subject.appendTo(@el)
      expect( @el.html() ).to.eq('<div></div>')
      @el.html('')
      subject.appendTo(el: @el)
      expect( @el.html() ).to.eq('<div></div>')

    it "returns @el for chaining", ->
      expect( subject.appendTo(@el) ).to.eq(subject.el)


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
      expect( subject.test.is('section#test') ).to.be.true
      expect( subject.test2.is('section#test2') ).to.be.true


  describe "#renderTemplate", ->

    it "renders the template", ->
      JST['/mercury/templates/foo'] = ->
      spyOn(JST, '/mercury/templates/foo', -> '_foo_function_template_')
      expect( subject.renderTemplate('foo', foo: 'bar') ).to.eq('_foo_function_template_')
      expect( JST['/mercury/templates/foo'] ).calledWith(foo: 'bar')

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


  describe "#fetchTemplate", ->

    beforeEach ->
      Mercury.configure 'templates:prefixUrl', '/foo/bar'
      @server = sinon.fakeServer.create()
      @server.respondWith('GET', '/foo/bar/baz', [200, {'Content-Type': 'text/html'}, '_ajax_template_'])

    it "makes an ajax call for the template", ->
      result = subject.fetchTemplate('baz')
      expect( result ).to.eq('_ajax_template_')


  describe "#release", ->

    it "triggers a release event", ->
      spyOn(subject, 'trigger')
      subject.release()
      expect( subject.trigger ).calledWith('release')

    it "removes the element", ->
      el = $('<div>').append(subject.el)
      subject.release()
      expect( el.html() ).to.eq('')

    it "calls #off", ->
      spyOn(subject, 'off')
      subject.release()
      expect( subject.off ).called


  describe "#delegateEvents", ->

    beforeEach ->
      subject.el = on: ->
      spyOn(subject.el, 'on')

    it "accepts an element and events, or just events", ->
      otherEl = on: spy()
      subject.delegateEvents(otherEl, foo: ->)
      expect( otherEl.on ).calledWith('foo', null, sinon.match.func)


    describe "binding to a callback directly", ->

      it "adds the event", ->
        callback = spy()
        subject.delegateEvents(event: callback)
        expect( subject.el.on ).calledWith('event', null)
        subject.el.on.callArg(2, 'foo')
        expect( callback ).calledWith('foo')
        expect( callback ).calledOn(subject)

    describe "binding to a method (by string)", ->

      it "locates the method and binds the event", ->
        spyOn(subject, 'release')
        subject.delegateEvents('event   ': 'release')
        expect( subject.el.on ).calledWith('event', null)
        subject.el.on.callArg(2, 'foo')
        expect( subject.release ).calledWith('foo')

      it "throws an exception if the method doesn't exist", ->
        expect(-> subject.delegateEvents(event: 'foo') ).to.throw(Error, "foo doesn't exist")

    describe "binding to global events (by using : in the event name)", ->

      beforeEach ->
        spyOn(Mercury, 'on')

      it "calls the global Mercury.on", ->
        callback = spy()
        subject.delegateEvents('global:event': callback)
        expect( Mercury.on ).calledWith('global:event')
        Mercury.on.callArg(1, 'foo')
        expect( callback ).calledWith('foo')
        expect( callback ).calledOn(subject)

    describe "binding to trigger a global event (by using : in the key)", ->

      it "triggers a global event", ->
        spyOn(Mercury, 'trigger')
        subject.delegateEvents(event: 'global:event')
        expect( subject.el.on ).calledWith('event')
        subject.el.on.callArg(2)
        expect( Mercury.trigger ).calledWith('global:event', subject)

    describe "with a selector", ->

      it "binds the event using that selector", ->
        callback = spy()
        subject.delegateEvents('event selector': callback)
        expect( subject.el.on ).calledWith('event', 'selector')
        subject.el.on.callArg(2)
        expect( callback ).called
