describe "Mercury", ->

  afterEach: ->
    Mercury.config.localization.enabled = false

  describe "supported:", ->

    # this is here for documentation -- unable to test, because this is evaluated on script load
    it "checks document.getElementById", ->
    it "checks document.designMode", ->
    it "disallows konqueror and msie", ->


  describe ".on", ->

    it "binds an event prefixed with 'mercury:' to the top window", ->
      callCount = 0
      Mercury.on('test', -> callCount += 1)
      $(top).trigger("mercury:test")
      expect(callCount).toEqual(1)


  describe ".trigger", ->

    it "triggers an event prefixed with 'mercury:' on the top window", ->
      argsForCall = []
      callCount = 0
      Mercury.on('test', -> argsForCall[callCount] = arguments; callCount += 1)
      Mercury.trigger("test", {foo: 'bar'})
      expect(callCount).toEqual(1)
      expect(argsForCall[0][1]).toEqual({foo: 'bar'})


  describe ".notify", ->

    beforeEach ->
      @alertSpy = spyOn(window, 'alert').andCallFake(=>)
      @i18nSpy = spyOn(Mercury, 'I18n').andCallFake(=>)
      Mercury.notify('hello world!')

    it "translates the text first by calling Mercury.I18n", ->
      expect(@i18nSpy.callCount).toEqual(1)
      expect(@i18nSpy.argsForCall[0]).toEqual(['hello world!'])

    it "alerts the message", ->
      expect(@alertSpy.callCount).toEqual(1)
      expect(@i18nSpy.argsForCall[0]).toEqual(['hello world!'])


  describe ".warn", ->

    beforeEach ->
      window.console = {warn: (-> ''), trace: (-> '')}
      @warnSpy = spyOn(window.console, 'warn').andCallFake(=>)
      @notifySpy = spyOn(Mercury, 'notify').andCallFake(=>)

    it "calls console.warn", ->
      Mercury.warn('message', 2)
      expect(@warnSpy.callCount).toEqual(1)

    it "calls Mercury.notify if there's no console", ->
      window.console = null
      Mercury.warn('message', 2)
      expect(@notifySpy.callCount).toEqual(1)


  describe ".log", ->

    beforeEach ->
      window.console = {debug: -> ''}
      @debugSpy = spyOn(window.console, 'debug').andCallFake(=>)
      Mercury.debug = true

    it "calls console.debug", ->
      Mercury.log(1, 2)
      expect(@debugSpy.callCount).toEqual(1)

    it "does nothing if debug mode isn't on", ->
      Mercury.debug = false
      Mercury.log(1, 2)
      expect(@debugSpy.callCount).toEqual(0)

    it "does nothing if there's no console", ->
      window.console = null
      Mercury.log(1, 2)
      expect(@debugSpy.callCount).toEqual(0)


  describe ".locale", ->

    beforeEach ->
      @translationSource = Mercury.I18n['en'] = {
        'original-top': 'translated-top'
        _US_: {'original-sub': 'translated-sub'}
      }

    it "memoizes array for what the browsers language is set to (breaks with a different language set)", ->
      Mercury.config.localization.enabled = true
      expect(Mercury.determinedLocale).toEqual(undefined)
      expect(Mercury.locale()).toEqual({top: @translationSource, sub: @translationSource['_US_']})
      expect(Mercury.determinedLocale).toEqual({top: @translationSource, sub: @translationSource['_US_']})


  describe ".I18n", ->

    beforeEach ->
      Mercury.I18n['foo'] =
        'originaL': 'translated -- top level'
        'uniquE': 'translated unique'
        'complex %s with %d, and %f': 'translated %s with %d, and %f'
        BAR:
          'originaL': 'translated -- sub level'
          'unique': 'undesired unique'
      Mercury.determinedLocale = {top: Mercury.I18n['foo'], sub: Mercury.I18n['foo']['BAR']}


    it "translates from a top level locale", ->
      Mercury.determinedLocale.sub = {}
      expect(Mercury.I18n('originaL')).toEqual('translated -- top level')

    it "translates from a sub level locale", ->
      expect(Mercury.I18n('originaL')).toEqual('translated -- sub level')

    it "falls back from a sub level locale", ->
      expect(Mercury.I18n('uniquE')).toEqual('translated unique')

    it "falls back to no translation", ->
      Mercury.determinedLocale = {top: {}, sub: {}}
      expect(Mercury.I18n('original')).toEqual('original')

    it "uses printf to get any number of variables into the translation", ->
      expect(Mercury.I18n('complex %s with %d, and %f', 'string', 1, 2.4)).toEqual('translated string with 1, and 2.4')
