#= require spec_helper
#= require mercury/core/extensions/object
#= require mercury/core/view
#= require mercury/views/modules/form_handler

fixture.preload('form.html')

describe "Mercury.View.Modules.FormHandler", ->

  Klass = null
  Module = Mercury.View.Modules.FormHandler
  subject = null

  beforeEach ->
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

    it "calls #applySerializedModel on update if there's a model", ->
      subject.model = {}
      spyOn(subject, 'on')
      subject.buildFormHandler()
      expect( subject.on ).calledWith('update', subject.applySerializedModel)


  describe "#validate", ->

    it "calls @clearInputErrors", ->
      spyOn(subject, 'clearInputErrors')
      subject.validate()
      expect( subject.clearInputErrors ).called


  describe "#displayInputErrors", ->

    beforeEach ->
      subject.model = errors: {_error_: ['_message1_', '_message2_']}

    it "calls @addInputErrors for each of the errors in @model.error", ->
      spyOn(subject, '$', -> '_input_')
      spyOn(subject, 'addInputError')
      subject.displayInputErrors()
      expect( subject.$ ).calledWith('[name=_error_]')
      expect( subject.addInputError ).calledWith('_input_', '_message1_, _message2_')


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


  describe "#applySerializedModel", ->

    fixture.load('form.html')

    beforeEach ->
      subject.$el = fixture.$el
      subject.model = toJSON: ->
        text: '_text_'
        checkbox1: true
        checkbox2: 'foo'
        radio: 'b'
        select: '_val2_'
        textarea: '_textarea_'

    it "fills out a form from the model", ->
      subject.applySerializedModel()
      expect( subject.$('[name="text"]').val() ).to.eq('_text_')
      expect( subject.$('[name="checkbox1"]').prop('checked') ).to.be.true
      expect( subject.$('[name="checkbox2"]').prop('checked') ).to.be.false
      expect( subject.$('[name="radio"]:checked').val() ).to.eq('b')
      expect( subject.$('[name="select"]').val() ).to.eq('_val2_')
      expect( subject.$('[name="textarea"]').val() ).to.eq('_textarea_')


  describe "#serializeModel", ->

    beforeEach ->
      subject.model = set: spy(), isValid: spy(-> true)
      subject.hide = spy()
      spyOn(subject, 'clearInputErrors')

    it "calls #clearInputErrors", ->
      subject.serializeModel()
      expect( subject.clearInputErrors ).called

    it "sets the attributes of the model", ->
      spyOn(subject, 'serializeForm', -> '_form_')
      subject.serializeModel()
      expect( subject.model.set ).calledWith('_form_')

    describe "when the model is valid", ->

      it "triggers a form:success event", ->
        spyOn(subject, 'trigger')
        subject.serializeModel()
        expect( subject.trigger ).calledWith('form:success')

      it "hides if @hideOnValidSubmit", ->
        subject.hideOnValidSubmit = true
        subject.serializeModel()
        expect( subject.hide ).called

    describe "when the model isn't valid", ->

      beforeEach ->
        subject.model.isValid = spy(-> false)

      it "calls @displayInputErrors", ->
        spyOn(subject, 'displayInputErrors')
        subject.serializeModel()
        expect( subject.displayInputErrors ).called


  describe "#serializeForm", ->

    it "serializes the array, and deserialized the object", ->
      mock = serializeArray: spy(-> '_array_')
      spyOn(subject, '$', -> mock)
      spyOn(Object, 'deserialize')
      subject.serializeForm()
      expect( subject.$ ).calledWith('form')
      expect( mock.serializeArray ).called
      expect( Object.deserialize ).calledWith('_array_')


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

    it "calls #serializeModel if there's a model", ->
      spyOn(subject, 'serializeModel')
      subject.model = {}
      subject.onFormSubmit(@e)
      expect( subject.serializeModel ).called

    it "calls #onSubmit if it's defined and we're valid", ->
      subject.onSubmit = spy()
      subject.onFormSubmit(@e)
      subject.valid = false
      expect( subject.onSubmit ).not.called
      subject.valid = true
      subject.onFormSubmit(@e)
      expect( subject.onSubmit ).called

