#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/focusable_textarea
#= require mercury/regions/text

describe "Mercury.Region.Text", ->

  Klass = Mercury.Region.Text
  subject = null

  beforeEach ->
    Mercury.configure 'regions:identifier', 'id'
    subject = new Klass('<div id="foo">')

  it "is defined correctly", ->
    expect( Klass.className ).to.eq('Mercury.Region.Text')
    expect( Klass.type ).to.eq('text')
    expect( Klass.supported ).to.be.true

  describe "#value", ->

    it "sets the value", ->
      subject.value('_value_')
      expect( subject.focusable.val() ).to.eq('_value_')

    it "sets the value and selection if we pass an object", ->
      subject.setSerializedSelection = spy()
      subject.value(val: '_value_', sel: '_sel_')
      expect( subject.focusable.val() ).to.eq('_value_')
      expect( subject.setSerializedSelection ).calledWith('_sel_')

    it "returns the value when getting", ->
      subject.focusable.val('_foo_')
      expect( subject.value() ).to.eq('_foo_')

    describe "with stripTags", ->

      beforeEach ->
        Mercury.configure 'regions:text:stripTags', true

      it "sanitizes and sets the value", ->
        subject.value('<br><br/>this is<br>some<br/>text\n')
        expect( subject.focusable.val() ).to.eq('this is\nsome\ntext')

      it "sanitizes and returns the value when getting", ->
        subject.focusable.val('\n\nthis <a href="">is</a>\nsome\ntext\n')
        expect( subject.value() ).to.eq('this is<br>some<br>text')


  describe "#sanitizedValue", ->

    it "returns the sanitized value", ->
      subject.focusable.val('this\nis\n\nsome text\n\n\n')
      expect( subject.sanitizedValue() ).to.eq('this<br>is<br><br>some text')
