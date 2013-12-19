# ## Require all the dependencies
#= require mercury/dependencies/jquery-ui-1.8.13.custom
#= require mercury/dependencies/jquery.additions
#= require mercury/dependencies/jquery.htmlClean
#= require mercury/dependencies/liquidmetal
#= require mercury/dependencies/showdown
#
# ## Require all mercury files
#= require_self
#= require ./native_extensions
#= require ./page_editor
#= require ./history_buffer
#= require ./table_editor
#= require ./dialog
#= require ./palette
#= require ./select
#= require ./panel
#= require ./modal
#= require ./lightview
#= require ./statusbar
#= require ./toolbar
#= require ./toolbar.button
#= require ./toolbar.button_group
#= require ./toolbar.expander
#= require ./tooltip
#= require ./snippet
#= require ./snippet_toolbar
#= require ./region
#= require ./uploader
#= require_tree ./regions
#= require_tree ./dialogs
#= require_tree ./modals
#= require ./finalize
#
@Mercury ||= {}
jQuery.extend @Mercury,
  version: '0.9.0'

  # Mercury object namespaces
  Regions: Mercury.Regions || {}
  modalHandlers: Mercury.modalHandlers || {}
  lightviewHandlers: Mercury.lightviewHandlers || {}
  dialogHandlers: Mercury.dialogHandlers || {}
  preloadedViews: Mercury.preloadedViews || {}

  # Custom ajax headers
  ajaxHeaders: ->
    headers = {}
    headers[Mercury.config.csrfHeader] = Mercury.csrfToken
    return headers


  # Custom event methods
  on: (eventName, callback) ->
    jQuery(window).on("mercury:#{eventName}", callback)


  off: (eventName, callback) ->
    jQuery(window).off("mercury:#{eventName}", callback)


  one: (eventName, callback) ->
    jQuery(window).one("mercury:#{eventName}", callback)


  trigger: (eventName, options) ->
    Mercury.log(eventName, options)
    jQuery(window).trigger("mercury:#{eventName}", options)


  # Alerting and logging methods
  notify: (args...) ->
    window.alert(Mercury.I18n.apply(@, args))


  warn: (message, severity = 0) ->
    if console
      try console.warn(message)
      catch e1
        if severity >= 1
          try console.debug(message) catch e2
    else if severity >= 1
      Mercury.notify(message)


  deprecated: (message)->
    message = "#{message} -- #{console.trace()}" if console && console.trace
    #throw "deprecated: #{message}"
    Mercury.warn("deprecated: #{message}", 1)


  log: ->
    if Mercury.debug && console
      return if arguments[0] == 'hide:toolbar' || arguments[0] == 'show:toolbar'
      try console.debug(arguments)
      catch e


  # I18n / Translation methods
  locale: ->
    return Mercury.determinedLocale if Mercury.determinedLocale
    if Mercury.config.localization.enabled
      locale = []
      if navigator.language && (locale = navigator.language.toString().split('-')).length
        topLocale = Mercury.I18n[locale[0]] || {}
        subLocale = if locale.length > 1 then topLocale["_#{locale[1].toUpperCase()}_"]
      if !Mercury.I18n[locale[0]]
        locale = Mercury.config.localization.preferredLocale.split('-')
        topLocale = Mercury.I18n[locale[0]] || {}
        subLocale = if locale.length > 1 then topLocale["_#{locale[1].toUpperCase()}_"]
    return Mercury.determinedLocale = {top: topLocale || {}, sub: subLocale || {}}


  I18n: (sourceString, args...) ->
    locale = Mercury.locale()
    translation = (locale.sub[sourceString] || locale.top[sourceString] || sourceString || '').toString()
    return if args.length then translation.printf.apply(translation, args) else translation
