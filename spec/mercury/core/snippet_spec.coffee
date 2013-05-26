#= require spec_helper
#= require mercury/core/snippet

describe "Mercury.Snippet", ->

  Klass = ->
  Module = Mercury.Snippet.Module
  subject = null

  beforeEach ->
    class Klass extends Mercury.Snippet
    subject = new Klass(name: 'name')

  describe ".register", ->

    it "instantiates and returns the snippet definition it instantiated", ->
      spyOn(Mercury.Snippet, 'Definition', -> definition: '_definition_')
      expect( Klass.register('foo', foo: 'bar') ).to.eql(definition: '_definition_')
      expect( Mercury.Snippet.Definition ).calledWith(name: 'foo', foo: 'bar')


  describe ".get", ->

    beforeEach ->
      @definition = Klass.register('foo', foo: 'bar')

    it "returns the registered snippet definition by name", ->
      expect( Klass.get('foo') ).to.eql(@definition)

    it "returns a new snippet instance from the definition if asked", ->
      spyOn(Mercury, 'Snippet', -> snippet: '_snippet_')
      expect( Klass.get('foo', true) ).to.eql(snippet: '_snippet_')
      expect( Mercury.Snippet ).calledWith(name: 'foo', foo: 'bar')

    it "throws an error if there's no snippet with that name", ->
      expect(-> Klass.get('bar') ).to.throw('unable to locate the bar snippet')


  describe ".fromSerializedJSON", ->

    beforeEach ->
      @args = name: '_name_', cid: '_cid_', attributes: {foo: 'bar'}
      @mock = set: spy()
      spyOn(Klass, 'get', => @mock)

    it "gets a new instance of the snippet", ->
      Klass.fromSerializedJSON(@args)
      expect( Klass.get ).calledWith('_name_', true)

    it "sets cid and attributes on the new snippet instance", ->
      Klass.fromSerializedJSON(@args)
      expect( @mock.cid ).to.eq('_cid_')
      expect( @mock.set ).calledWith(foo: 'bar')

    it "returns the new instance", ->
      expect( Klass.fromSerializedJSON(@args) ).to.eq(@mock)


  describe ".all", ->

    beforeEach ->
      @definition = Klass.register('foo', foo: 'bar')

    it "returns all the registered snippet definitions", ->
      expect( Klass.all()['foo'] ).to.eql(@definition)


  describe ".unregister", ->

    beforeEach ->
      @definition = Klass.register('foo', foo: 'bar')

    it "removes the definition from the list of registered snippet definitions", ->
      Klass.unregister('foo')
      expect( Klass.all()['foo'] ).to.be.undefined

    it "throws an error if there's no snippet with that name", ->
      expect(-> Klass.unregister('bar') ).to.throw('unable to locate the bar snippet')


  describe "#constructor", ->

    it "assigns instance vars from options passed", ->
      subject = new Klass(name: 'foo', foo: 'bar', config: '_config_')
      expect( subject.foo ).to.eq('bar')
      expect( subject.configuration ).to.eq('_config_')

    it "throws an exception if there was no name provided", ->
      expect(-> new Klass() ).to.throw('must provide a name for snippets')

    it "calls super", ->
      spyOn(Mercury.Snippet.__super__, 'constructor')
      subject = new Klass(name: 'foo', defaults: {foo: 'bar'})
      expect( Mercury.Snippet.__super__.constructor ).calledWith(foo: 'bar')


  describe "#toSerializedJSON", ->

    it "returns an object with our cid, name, and attributes", ->
      subject.cid = '_cid_'
      spyOn(subject, 'toJSON', -> foo: 'bar')
      expect( subject.toSerializedJSON() ).to.eql
        cid: '_cid_'
        name: 'name'
        attributes: {foo: 'bar'}
      expect( subject.toJSON ).called


  describe "#initialize", ->

    beforeEach ->
      @mock = type: spy(-> 'bar')
      spyOn(window, 'alert')

    it "assigns @region", ->
      subject.initialize(@mock)
      expect( subject.region ).to.eq(@mock)

    it "alerts if the region isn't supported", ->
      subject.supportedRegions = ['foo']
      subject.initialize(@mock)
      expect( alert ).calledWith('Unable to use the name snippet in that region. Supported regions: foo')

    it "allows all regions by default", ->
      subject.initialize(@mock)
      expect( alert ).not.called

    it "calls #displayForm if there's a form to display", ->
      spyOn(subject, 'displayForm')
      subject.form = true
      subject.initialize()
      expect( subject.displayForm ).called

    it "calls render if there's no form", ->
      spyOn(subject, 'render')
      subject.initialize()
      expect( subject.render ).called


  describe "#delay", ->

    it "delays and then calls the method", ->
      spyOn(window, 'setTimeout')
      window.setTimeout.yields()
      callback = spy()
      subject.delay(1, callback)
      expect( window.setTimeout ).called
      expect( callback ).calledOn(subject)


  describe "#displayForm", ->

    beforeEach ->
      spyOn(subject, 'get', -> '_title_')
      spyOn(subject, 'templateClosure', -> '_template_')
      @mock = on: ->
      subject.form = '_form_'
      spyOn(Mercury, 'Modal', => @mock)

    it "creates a new modal", ->
      subject.displayForm()
      expect( Mercury.Modal ).calledWith
        title: '_title_'
        template: '_template_'
        width: 600
        model: subject
        hideOnValidSubmit: true
      expect( subject.get ).calledWith('title')
      expect( subject.templateClosure ).calledWith('_form_')

    it "allows the modal to be overridden", ->
      subject.Modal = spy(=> @mock)
      subject.displayForm('_my_form_')
      expect( subject.templateClosure ).calledWith('_my_form_')
      expect( subject.Modal ).called

    it "binds to form:success and calls #render", ->
      spyOn(subject, 'render')
      spyOn(@mock, 'on').yieldsOn(subject)
      subject.displayForm()
      expect( @mock.on ).calledWith('form:success', sinon.match.func)
      expect( subject.render ).called


  describe "#render", ->

    beforeEach ->
      subject.renderOptions = foo: 'bar'

    it "calls #save with the options if we have a url and no rendered view", ->
      spyOn(subject, 'save')
      spyOn(subject, 'url', -> true)
      subject.render(bar: 'baz')
      expect( subject.save ).calledWith(foo: 'bar', bar: 'baz')

    it "calls #renderView if there's no url", ->
      spyOn(subject, 'renderView')
      subject.render()
      subject.render(template: '_template_')
      expect( subject.renderView ).calledWith('_template_')


  describe "#renderView", ->

    beforeEach ->
      spyOn(subject, 'view', -> '_view_')
      spyOn(subject, 'templateClosure', -> '_template_')

    it "calls #view with the template closure and assigns it to @renderedView", ->
      subject.renderView('_my_template_')
      expect( subject.view ).calledWith('_template_')
      expect( subject.templateClosure ).calledWith('_my_template_')

    it "triggers the rendered event", ->
      spyOn(subject, 'trigger')
      subject.renderView()
      expect( subject.trigger ).calledWith('rendered', subject.renderedView)

    it "delays a call to #afterRender", ->
      spyOn(subject, 'delay').yieldsOn(subject)
      subject.renderView()
      expect( subject.delay ).calledWith(1, subject.afterRender)


  describe "#afterRender", ->

    it "does nothing by default", ->
      subject.afterRender()


  describe "#view", ->

    it "creates a new view", ->
      spyOn(Mercury.Snippet, 'View', -> inst: '_view_')
      subject.view('_template_')
      expect( Mercury.Snippet.View ).calledWith(template: '_template_', snippet: subject)


  describe "#saveSuccess", ->

    it "calls #renderView with the preview, falling back to the content from the request", ->
      func = null
      spyOn(subject, 'renderView', (template) -> func = template)
      subject.saveSuccess('_content_')
      expect( subject.renderView ).calledWith(sinon.match.func)
      expect( func() ).to.eq('_content_')
      spyOn(subject, 'get', -> '_preview_')
      expect( func() ).to.eq('_preview_')


  describe "#templateClosure", ->

    it "it wraps and returns a closure if the template is a function", ->
      res = subject.templateClosure(-> "_template_#{arguments[0]}")
      expect( res('foo_') ).to.eq('_template_foo_')

    it "returns the template normally if it's just a string", ->
      expect( subject.templateClosure('_template_') ).to.eq('_template_')


  describe "#getRenderedView", ->

    it "returns the @renderedView", ->
      subject.renderedView = '_rendered_'
      expect( subject.getRenderedView() ).to.eq('_rendered_')


  describe "#replaceWithView", ->

    beforeEach ->
      @$el = replaceWith: spy()
      subject.renderedView = $el: $('<section>')

    it "replaces the element with our renderedView element", ->
      subject.replaceWithView(@$el)
      expect( @$el.replaceWith ).calledWith(subject.renderedView.$el)

    it "calls #afterRender", ->
      spyOn(subject, 'afterRender')
      subject.replaceWithView(@$el)
      expect( subject.afterRender ).called


  describe "#renderAndReplaceWithView", ->

    beforeEach ->
      @$el = replaceWith: spy()
      @view = $el: $('<section>')
      spyOn(subject, 'render', => subject.trigger('rendered', @view))

    it "calls render", ->
      subject.renderAndReplaceWithView(@$el)
      expect( subject.render ).called

    it "binds to the rendered event and replaces the element / calls the callback provided", ->
      callback = spy()
      subject.renderAndReplaceWithView(@$el, callback)
      expect( @$el.replaceWith ).calledWith(@view.$el)
      expect( callback ).calledWith(@$el, @view)


  describe "Module", ->

    it "is defined correctly", ->
      expect( Module.registerSnippet ).to.eq(Klass.register)
      expect( Module.getSnippet ).to.eq(Klass.get)


describe "Mercury.Snippet.Definition", ->

  Klass = ->
  subject = null

  beforeEach ->
    class Klass extends Mercury.Snippet.Definition
    @func = ->
    subject = new Klass(name: 'definition', config: {foo: 'bar'}, func: @func)

  describe "#constructor", ->

    it "sets @name, @title, @description, @version, and @configuration from the options", ->
      subject = new Klass(name: '_name_', title: '_title_', description: '_description_', version: '_version_', config: {foo: 'bar'})
      expect( subject.name ).to.eql('_name_')
      expect( subject.title ).to.eql('_title_')
      expect( subject.description ).to.eql('_description_')
      expect( subject.version ).to.eql('_version_')
      expect( subject.configuration ).to.eql(foo: 'bar')

    it "registers the definition", ->
      expect( Mercury.Snippet.get('definition') ).to.eq(subject)

    it "throws an error if there's no name", ->
      expect(-> new Klass() ).to.throw('must provide a name for snippets')


  describe "#signature", ->

    it "returns a clone of the @options", ->
      expect( subject.signature() ).to.eql(name: 'definition', config: {foo: 'bar'}, func: @func)
      expect( subject.signature(false) ).to.eql(name: 'definition', config: {foo: 'bar'})


describe "Mercury.Snippet.View", ->

  Klass = ->
  subject = null

  beforeEach ->
    class Klass extends Mercury.Snippet.View
    @mock = {name: 'mock', cid: 'c42'}
    subject = new Klass(snippet: @mock)

  describe "#build", ->

    it "adds the snippet classname", ->
      spyOn(subject, 'addClass')
      subject.build()
      expect( subject.addClass ).calledWith('mercury-mock-snippet')

    it "adds the data attribute so we can select it", ->
      expect( subject.$el.attr('data-mercury-snippet') ).to.eq('c42')

    it "adds a data reference to the snippet model instance", ->
      expect( subject.$el.data('snippet') ).to.eq(@mock)
