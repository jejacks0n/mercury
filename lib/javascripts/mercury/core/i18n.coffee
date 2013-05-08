#= require mercury/core/extensions/string

(@Mercury ||= {}).I18n =

  __locales__: {}

  # Define a locale with a given name and mapping object. This is the main interface for exposing locales to the
  # translation engine.
  #
  # Mercury.I18n.define('en', {'original': 'translated'})
  # Mercury.I18n.define('en', {'original %s': 'translated %s'})
  #
  define: (name, mapping) ->
    @__locales__[name] = mapping


  # Determines the locale that should be used when running translations.
  # Returns/sets the determined localization mapping that will be used for translation.
  #
  locale: ->
    return @__determined__ if @__determined__
    return [{}, {}] unless Mercury.configuration.localization?.enabled

    [top, sub] = @detectLocale()
    top = @.__locales__[top]
    sub = if top && sub then top["_#{sub.toUpperCase()}_"] else false

    @__determined__ = [top || {}, sub || {}]


  # Detects the locale that should be used when running translations.
  # Returns array containing the top and sub locales.
  #
  detectLocale: ->
    return @__detected__ if @__detected__
    possible = (@clientLocale() || Mercury.configuration.localization?.preferred).split('-')
    possible = (Mercury.configuration.localization?.preferred || 'en-US').split('-') unless @.__locales__[possible[0]]
    @__detected__ = possible


  # Translates a given string with printf-like variable replacement using the determined translation. Check
  # String.printf for more information about variable replacement.
  # Returns the original string (with replacements) if no translation was found, otherwise the translation.
  #
  # t('original')                                => 'translated'
  # t('original %s', 'value')                    => 'translated value'
  #
  t: (source, args...) ->
    [top, sub] = Mercury.I18n.locale()
    translated = (sub[source] || top[source] || source || '').toString()
    return translated.printf(args...) if args.length
    translated


  # Returns the language as determined by the browser.
  #
  clientLocale: ->
    # todo: add support for IE (does IE10 properly provide this now?)
    navigator.language?.toString()


Mercury.I18n.Module =

  t: Mercury.I18n.t
