#= require spec_helper
#= require mercury/core/i18n

describe "Mercury.I18n", ->

  Klass = ->
  subject = null
  locales =
    foo:
      'original': 'translated -- top level'
      'uniquE': 'translated unique'
      'complex %s with %d, and %f': 'translated %s with %d, and %f'
      _BAR_:
        'original': 'translated -- sub level'
        'unique': 'undesired unique'
    swedish_chef:
      'foo': 'bar'

  beforeEach ->
    Mercury.configure 'localization', enabled: true, preferred: 'swedish_chef-BORK'
    Klass.prototype = Mercury.I18n.Module
    subject = $.extend(Mercury.I18n, __determined__: null, __locales__: locales)

  describe ".define", ->

    it "defines a locale", ->
      subject.define('bar', {bit: 'bot'})
      expect( subject.__locales__['bar'] ).to.eql({bit: 'bot'})


  describe ".locale", ->

    it "memoizes the determinined locale", ->
      subject.__determined__ = {foo: 'BAR'}
      expect( subject.locale() ).to.eql({foo: 'BAR'})

    it "returns empty information if not enabled in configuration", ->
      Mercury.configure('localization:enabled', false)
      expect( subject.locale() ).to.eql([{}, {}])

    it "detects from the navigator.language", ->
      spyOn(subject, 'clientLocale', -> 'foo-BAR')
      [top, sub] = subject.locale()
      expect( top ).to.eql(subject.__locales__['foo'])
      expect( sub ).to.eql(subject.__locales__['foo']['_BAR_'])

    it "falls back to the preferred language provided in the configuration", ->
      spyOn(subject, 'clientLocale', -> false)
      [top, sub] = subject.locale()
      expect( top ).to.eq(subject.__locales__['swedish_chef'])
      expect( sub ).to.be.empty

    it "returns empty information if not no translations were found", ->
      spyOn(subject, 'clientLocale', -> 'missing')
      expect( subject.locale() ).to.eql([{}, {}])


  describe ".t", ->

    beforeEach ->
      spyOn(subject, 'clientLocale', -> 'foo-BAR')

    it "returns a string if nothing was passed", ->
      expect( subject.t() ).to.eq('')

    it "returns the original string if there's no translation", ->
      expect( subject.t('foo') ).to.eq('foo')

    it "translates typical strings at the top level", ->
      expect( subject.t('uniquE') ).to.eq('translated unique')

    it "translates typical strings at the sub level", ->
      expect( subject.t('original') ).to.eq('translated -- sub level')

    it "translates complex strings using a simple printf style", ->
      expect( subject.t('complex %s with %d, and %f', 'string', 1, 2.4) ).to.eq('translated string with 1, and 2.4')


  describe ".clientLocale", ->

    it "returns the navigator language", ->
      expect( subject.clientLocale() ).to.eq(navigator.language?.toString())


  describe "Module", ->

    beforeEach ->
      subject = new Klass()

    describe "#t", ->

      it "translates", ->
        expect( subject.t('foo %s', 'bar') ).to.eq('foo bar')
