#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/content_editable

describe "Mercury.Region.Modules.ContentEditable", ->

  Klass = null
  Module = Mercury.Region.Modules.ContentEditable
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    class Klass extends Mercury.Region
      @include Module
    subject = new Klass('<div id="foo">')

  describe "#buildContentEditable (via the build event)", ->

    it "sets @editableDropBehavior", ->
      subject.trigger('build')
      expect( subject.editableDropBehavior ).to.be.true
      subject.editableDropBehavior = false
      subject.trigger('build')
      expect( subject.editableDropBehavior ).to.be.false

    it "gets the @document from the element", ->
      subject.trigger('build')
      expect( subject.document ).to.eq(document)

    it "calls #makeContentEditable", ->
      spyOn(subject, 'makeContentEditable')
      subject.trigger('build')
      expect( subject.makeContentEditable ).called

    it "calls #forceContentEditableDisplay", ->
      spyOn(subject, 'forceContentEditableDisplay')
      subject.trigger('build')
      expect( subject.forceContentEditableDisplay ).called

    it "calls #setContentEditablePreferences", ->
      spyOn(subject, 'setContentEditablePreferences')
      subject.trigger('build')
      expect( subject.setContentEditablePreferences ).called


  describe "#toggleContentEditable (via the preview event)", ->

    beforeEach ->
      spyOn(subject, 'makeContentEditable')
      spyOn(subject, 'makeNotContentEditable')

    it "calls #makeNotContentEditable when previewing", ->
      subject.previewing = true
      subject.trigger('preview')
      expect( subject.makeNotContentEditable ).called

    it "calls #makeContentEditable when not previewing", ->
      subject.previewing = false
      subject.trigger('preview')
      expect( subject.makeContentEditable ).called


  describe "#releaseContentEditable (via the release event)", ->

    it "sets content editable to false on the element", ->
      expect( subject.el.get(0).contentEditable ).to.eq('true')
      subject.trigger('release')
      expect( subject.el.get(0).contentEditable ).to.eq('false')

    it "sets the display back to the original", ->
      subject.originalDisplay = 'none'
      subject.trigger('release')
      expect( subject.el.css('display') ).to.eq('none')


  describe "#makeContentEditable", ->

    it "sets content editable on the element", ->
      expect( subject.el.get(0).contentEditable ).to.eq('true')


  describe "#makeNotContentEditable", ->

    it "sets content editable on the element", ->
      subject.makeNotContentEditable()
      expect( subject.el.get(0).contentEditable ).to.eq('false')


  describe "#forceContentEditableDisplay", ->

    it "sets display to inline block if the display is inline", ->
      subject.el.css(display: 'inline')
      subject.forceContentEditableDisplay()
      expect( subject.originalDisplay ).to.eq('inline')
      expect( subject.el.css('display') ).to.eq('inline-block')

    it "leaves other display types alone", ->
      subject.el.css(display: 'block')
      subject.forceContentEditableDisplay()
      expect( subject.el.css('display') ).to.eq('block')


  describe "#setContentEditablePreferences", ->

    it "sets the various preferences using execCommand", ->
      subject.document = execCommand: spy()
      subject.setContentEditablePreferences()
      expect( subject.document.execCommand ).calledWith('styleWithCSS', false, false)
      expect( subject.document.execCommand ).calledWith('insertBROnReturn', false, true)
      expect( subject.document.execCommand ).calledWith('enableInlineTableEditing', false, false)
      expect( subject.document.execCommand ).calledWith('enableObjectResizing', false, false)

    it "doesn't throw if there's a problem", ->
      subject.document = execCommand: -> throw new Error('foo')
      expect(-> subject.setContentEditablePreferences() ).not.to.throw(Error, 'foo')


  describe "#stackEquality", ->

    it "returns true if the val matches when the stackPosition is 0", ->
      subject.stackPosition = 0
      subject.stack[0] = {sel: 'foo', val: '_val_'}
      expect( subject.stackEquality(sel: 'bar', val: '_val_') ).to.be.true
      expect( subject.stackEquality(sel: 'bar', val: '_value_') ).to.be.false

    it "returns true if the value matches using JSON comparison", ->
      subject.stackPosition = 1
      subject.stack = [{}, {sel: 'foo', val: '_val_'}]
      expect( subject.stackEquality(sel: 'foo', val: '_val_') ).to.be.true


    it "returns false if the value doesn't match using JSON comparison", ->
      subject.stackPosition = 1
      subject.stack = [{}, {sel: 'bar', val: '_val_'}]
      expect( subject.stackEquality(sel: 'foo', val: '_val_') ).to.be.false
