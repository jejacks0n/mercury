#= require spec_helper
#= require mercury/models/page

describe "Mercury.Model.Page", ->

  Klass = Mercury.Model.Page
  subject = null

  beforeEach ->
    Mercury.configure 'saving', foo: 'bar'
    subject = new Klass()

  describe "#save", ->

    it "merges the configuration with the options and calls super", ->
      spyOn(Klass.__super__, 'save')
      subject.save()
      expect( Klass.__super__.save ).calledWith(foo: 'bar')
      subject.save(bar: 'baz')
      expect( Klass.__super__.save ).calledWith(foo: 'bar', bar: 'baz')
