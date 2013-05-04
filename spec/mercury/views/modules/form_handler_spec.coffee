#= require spec_helper
#= require mercury/core/view
#= require mercury/views/modules/form_handler

describe "Mercury.View.Modules.FormHandler", ->

  Klass = null
  Module = Mercury.View.Modules.FormHandler
  subject = null

  beforeEach ->
    Mercury.configure 'logging:enabled', false
    class Klass extends Mercury.View
      @include Module
    subject = new Klass()

  describe "#included", ->

    beforeEach ->
      @mock =
        on: spy(),
        buildFormHandler: ->

    it "binds to the build event", ->
      Module.included.call(@mock)
      expect( @mock.on ).calledWith('build', @mock.buildFormHandler)


  describe "#buildFormHandler", ->

    it "calls #delegateEvents", ->
      spyOn(subject, 'delegateEvents')
      subject.buildFormHandler()
      expect( subject.delegateEvents ).calledWith('submit': subject.onFormSubmit)


  describe "#validate", ->

    it "calls @clearInputErrors", ->
      spyOn(subject, 'clearInputErrors')
      subject.validate()
      expect( subject.clearInputErrors ).called


  describe "#addInputError", ->

    beforeEach ->
      @input = after: spy(=> @input), closest: spy(=> @input), addClass: spy(=> @input)

    it "adds a span with the message after the input", ->
      subject.addInputError(@input, '_message_')
      expect( @input.after ).calledWith("""<span class="help-inline error-message">_message_</span>""")

    it "adds the error class to the control group", ->
      subject.addInputError(@input, '_message_')
      expect( @input.closest ).calledWith('.control-group')
      expect( @input.addClass ).calledWith('error')

    it "sets @valid to false", ->
      subject.valid = true
      subject.addInputError(@input, '_message_')
      expect( subject.valid ).to.be.false


  describe "#clearInputErrors", ->

    beforeEach ->
      @group = removeClass: spy(=> @group), find: spy(=> @group), remove: spy(=> @group)
      spyOn(subject, '$', => @group)

    it "removes all errors", ->
      subject.clearInputErrors()
      expect( subject.$ ).calledWith('.control-group.error')
      expect( @group.removeClass ).calledWith('error')
      expect( @group.find ).calledWith('.error-message')
      expect( @group.remove ).called

    it "sets @valid to true", ->
      @valid = false
      subject.clearInputErrors()
      expect( subject.valid ).to.be.true


  describe "#onFormSubmit", ->

    beforeEach ->
      @e = preventDefault: spy()
      spyOn(subject, 'validate')

    it "prevents the default event", ->
      subject.onFormSubmit(@e)
      expect( @e.preventDefault ).called

    it "calls #validate", ->
      subject.onFormSubmit(@e)
      expect( subject.validate ).called

    it "calls #onSubmit if it's defined and we're valid", ->
      subject.onSubmit = spy()
      subject.onFormSubmit(@e)
      subject.valid = false
      expect( subject.onSubmit ).not.called
      subject.valid = true
      subject.onFormSubmit(@e)
      expect( subject.onSubmit ).called

