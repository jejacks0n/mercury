#= require spec_helper
#= require mercury/views/modal

describe "Mercury.Modal", ->

  Klass = Mercury.Modal
  subject = null

  beforeEach ->
    subject = new Klass()

  afterEach ->
    subject.release()

  describe "#buildElement", ->

    it "sets @releaseOnHide to false if we're hidden (assumes that it's a static interface)", ->
      subject.releaseOnHide = true
      subject.hidden = true
      subject.buildElement()
      expect( subject.releaseOnHide ).to.be.false

    it "calls #negotiateTemplate", ->
      spyOn(subject, 'negotiateTemplate')
      subject.buildElement()
      expect( subject.negotiateTemplate ).called

    it "calls super", ->
      spyOn(Klass.__super__, 'buildElement')
      subject.buildElement()
      expect( Klass.__super__.buildElement ).called


  describe "#build", ->

    it "calls #appendTo", ->
      spyOn(subject, 'appendTo')
      subject.build()
      expect( subject.appendTo ).called

    it "calls #preventScrollPropagation", ->
      spyOn(subject, 'preventScrollPropagation')
      subject.build()
      expect( subject.preventScrollPropagation ).calledWith(subject.$contentContainer)


  describe "#negotiateTemplate", ->

    it "sets @options.template if it's not set", ->
      subject.template = 'foo'
      subject.options.template = null
      subject.negotiateTemplate()
      expect( subject.options.template ).to.eq('foo')

    it "sets @subTemplate", ->
      subject.options.template = 'bar'
      subject.negotiateTemplate()
      expect( subject.subTemplate ).to.eq('bar')

    it "sets @template", ->
      subject.primaryTemplate = 'baz'
      subject.negotiateTemplate()
      expect( subject.template ).to.eq('baz')


  describe "#update", ->

    beforeEach ->
      spyOn(subject, 'updateForOptions', -> true)
      spyOn(subject, 'refreshElements')
      spyOn(subject, 'resize')
      spyOn(subject, 'show')

    it "does nothing if not visible or #updateForOptions returns false", ->
      subject.visible = false
      expect( subject.update() ).to.be.undefined
      subject.visible = true
      subject.updateForOptions.restore()
      spyOn(subject, 'updateForOptions', -> false)
      expect( subject.update() ).to.be.undefined
      expect( subject.resize ).not.called

    it "calls #resize", ->
      subject.update()
      expect( subject.resize ).called

    it "calls #show", ->
      subject.update()
      expect( subject.show ).called

    it "calls #refreshElements", ->
      subject.update()
      expect( subject.refreshElements ).called

    it "triggers an update event", ->
      spyOn(subject, 'trigger')
      subject.update()
      expect( subject.trigger ).calledWith('update')

    it "focuses the first focusable element it can find after a delay", ->
      spyOn(subject, 'delay')
      subject.update()
      expect( subject.delay ).calledWith(300, subject.focusFirstFocusable)


  describe "#updateForOptions", ->

    beforeEach ->
      spyOn(subject, 'contentFromOptions', -> '_content_')
      spyOn(subject, 'setWidth')
      spyOn(subject, 'refreshElements')
      spyOn(subject, 'resize')
      spyOn(subject, 'show')

    it "merges options", ->
      subject.options = foo: 'bar'
      subject.updateForOptions(bar: 'baz')
      expect( subject.options ).to.eql(foo: 'bar', bar: 'baz', template: 'modal')

    it "sets instance variables from options", ->
      subject.updateForOptions(baz: 'foo')
      expect( subject.baz ).to.eq('foo')

    it "calls #negotiateTemplate", ->
      spyOn(subject, 'negotiateTemplate')
      subject.updateForOptions()
      expect( subject.negotiateTemplate ).called

    it "sets the title html", ->
      subject.title = '_title_'
      subject.updateForOptions()
      expect( subject.$title.html() ).to.eq('_title_')
      subject.updateForOptions(title: '_new_title_')
      expect( subject.$title.html() ).to.eq('_new_title_')

    it "calls #setWidth", ->
      subject.updateForOptions(width: 42)
      expect( subject.setWidth ).calledWith(42)

    it "calls #contentFromOptions", ->
      subject.updateForOptions()
      expect( subject.contentFromOptions ).called

    it "returns if it looks like things haven't changed", ->
      subject.lastWidth = 42
      subject.lastContent = '_content_'
      expect( subject.updateForOptions(width: 42, content: '_content_') ).to.be.false

    it "stores the current width in @lastWidth", ->
      subject.lastWidth = null
      subject.width = 42
      subject.updateForOptions()
      expect( subject.lastWidth ).to.eq(42)

    it "adds the loading class", ->
      subject.updateForOptions()
      expect( subject.$el.hasClass('loading') ).to.be.true

    it "sets the content and content css for sizing", ->
      spyOn(subject.$content, 'css', -> subject.$content)
      spyOn(subject.$content, 'html')
      subject.updateForOptions(width: 42)
      expect( subject.$content.css ).calledWith(visibility: 'hidden', opacity: 0, width: 42)
      expect( subject.$content.html ).calledWith('_content_')

    it "stores the content in @lastContent so we can tell if it's changed", ->
      subject.lastContent = null
      expect( subject.updateForOptions() ).to.be.true
      expect( subject.lastContent ).to.eq('_content_')

    it "calls localize on the content element", ->
      spyOn(subject, 'localize')
      subject.updateForOptions()
      expect( subject.localize ).calledWith(subject.$content)


  describe "#setWidth", ->

    it "sets the dialog width", ->
      spyOn(subject.$dialog, 'css')
      subject.setWidth(42)
      expect( subject.$dialog.css ).calledWith(width: 42)


  describe "#resize", ->

    beforeEach ->
      spyOn(subject.$titleContainer, 'outerHeight', -> 6)
      spyOn(subject.$content, 'outerHeight', -> 42)

    it "does nothing if not visible", ->
      subject.visible = false
      expect( subject.resize() ).to.be.undefined

    it "clears the @showContentTimeout", ->
      spyOn(window, 'clearTimeout')
      subject.showContentTimeout = '_timeout_'
      subject.resize()
      expect( window.clearTimeout ).calledWith('_timeout_')

    it "adds the mercury-no-animation class if we're not animating", ->
      spyOn(subject, 'addClass')
      subject.resize(false)
      expect( subject.addClass ).calledWith('mercury-no-animation')

    it "sets the content container height to auto", ->
      spyOn(subject.$contentContainer, 'css')
      subject.resize()
      expect( subject.$contentContainer.css ).calledWith(height: 'auto')

    it "ses the content position to absolute and static to detect the width -- if no width has been specified", ->
      spyOn(subject.$content, 'css')
      subject.width = null
      subject.resize()
      expect( subject.$content.css ).calledWith(position: 'absolute')
      expect( subject.$content.css ).calledWith(position: 'static')

    it "sets the dialog height and width", ->
      subject.width = 100
      spyOn(subject.$dialog, 'css')
      subject.resize()
      expect( subject.$dialog.css ).calledWith(height: 48, width: 100)

    it "sets the content container height", ->
      spyOn(subject.$contentContainer, 'css')
      subject.resize()
      expect( subject.$contentContainer.css ).calledWith(height: 42)

    it "calls #showContent (in a delay if animating)", ->
      spyOn(subject, 'delay').yieldsOn(subject)
      spyOn(subject, 'showContent')
      subject.resize(false)
      expect( subject.showContent ).calledWith(false)
      subject.resize(true)
      expect( subject.delay ).calledWith(300, subject.showContent)
      expect( subject.showContent ).called

    it "removes the mercury-no-animation class with a delay", ->
      spyOn(subject, 'delay').yieldsOn(subject)
      spyOn(subject, 'removeClass')
      subject.resize()
      expect( subject.delay ).calledWith(250, sinon.match.func)
      expect( subject.removeClass ).calledWith('mercury-no-animation')

    it "sets animate to false if you pass an object for the first arg", ->
      spyOn(subject, 'delay')
      subject.resize({})
      expect( subject.delay ).calledOnce


  describe "#contentFromOptions", ->

    it "calls #renderTemplate with a sub template if one is set", ->
      spyOn(subject, 'renderTemplate', -> '_rendered_template_')
      subject.subTemplate = '_sub_template_'
      expect( subject.contentFromOptions() ).to.eq('_rendered_template_')

    it "returns @content", ->
      subject.content = '_content_'
      expect( subject.contentFromOptions() ).to.eq('_content_')


  describe "#showContent", ->

    beforeEach ->
      spyOn(subject, 'delay').yieldsOn(subject)
      spyOn(subject.$content, 'css')

    it "clears the contentOpacityTimeout", ->
      spyOn(window, 'clearTimeout')
      subject.contentOpacityTimeout = '_timeout_'
      subject.showContent()
      expect( clearTimeout ).calledWith('_timeout_')

    it "removes the loading class", ->
      subject.$el.addClass('loading')
      subject.showContent()
      expect( subject.$el.hasClass('loading') ).to.be.false

    it "sets the content visibility and width", ->
      subject.showContent()
      expect( subject.$content.css ).calledWith(visibility: 'visible', width: 'auto', display: 'block')

    it "sets the content opacity in a timeout based on animate", ->
      subject.showContent(false)
      expect( subject.$content.css ).calledWith(opacity: 1)
      expect( subject.delay ).not.called
      subject.showContent()
      expect( subject.$content.css ).calledWith(opacity: 1)
      expect( subject.delay ).called


  describe "#appendTo", ->

    beforeEach ->
      spyOn(Klass.__super__, 'appendTo')
      Mercury.interface ||= '_interface_'

    it "only ever appends to Mercury.interface", ->
      subject.appendTo('_foo_')
      expect( Klass.__super__.appendTo ).calledWith(Mercury.interface)


  describe "#release", ->

    beforeEach ->
      spyOn(Klass.__super__, 'release')
      spyOn(subject, 'hide')
      subject.visible = false

    it "returns after calling #hide if it's visible", ->
      subject.visible = true
      subject.release()
      expect( subject.hide ).calledWith(true)
      expect( Klass.__super__.release ).not.called

    it "calls super", ->
      subject.release()
      expect( Klass.__super__.release ).called


  describe "#onShow", ->

    beforeEach ->
      spyOn(Mercury, 'trigger')

    it "triggers a global blur event", ->
      subject.onShow()
      expect( Mercury.trigger ).calledWith('blur')

    it "triggers a global modals:hide event", ->
      subject.onShow()
      expect( Mercury.trigger ).calledWith('modals:hide')


  describe "#onHide", ->

    beforeEach ->
      spyOn(Mercury, 'trigger')
      spyOn(subject, 'delay').yieldsOn(subject)

    it "triggers a global focus event", ->
      subject.onHide()
      expect( Mercury.trigger ).calledWith('focus')

    it "delays reset until after the element has animated out", ->
      subject.onHide()
      expect( subject.delay ).calledWith(250, sinon.match.func)

    it "resets @lastWidth", ->
      subject.lastWidth = 666
      subject.onHide()
      expect( subject.lastWidth ).to.be.null

    it "resets the sizes back to the originals", ->
      spyOn(subject.$dialog, 'css')
      spyOn(subject.$contentContainer, 'css')
      subject.onHide()
      expect( subject.$dialog.css ).calledWith(height: '', width: '')
      expect( subject.$contentContainer.css ).calledWith(height: '')

    it "hides the content", ->
      spyOn(subject.$content, 'hide')
      subject.onHide()
      expect( subject.$content.hide ).called
