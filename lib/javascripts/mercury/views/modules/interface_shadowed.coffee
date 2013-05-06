Mercury.View.Modules.InterfaceShadowed =

  included: ->
    @on('init', @buildInterfaceShadowed)


  extended: ->
    @on('init', @buildInterfaceShadowed)


  buildInterfaceShadowed: ->
    return unless @el.webkitCreateShadowRoot
    @shadow = $(@el.webkitCreateShadowRoot())
    # todo: this is a problem in that it allows css to bleed, which isn't exactly what we want here, but getting css
    #       to load internally isn't viable. ??
    @el = document.createElement(@tag || @constructor.tag)
    @$el = $(@el)
    @shadow.get(0).applyAuthorStyles = true
    @shadow.append(@el)
