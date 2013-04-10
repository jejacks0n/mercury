Mercury.View.Modules.Singleton =

  included: ->
    @on 'release', -> @constructor.instance = null


  ensureSingleton: ->
    instance = @constructor.instance
    ret = false unless instance
    if instance
      if instance instanceof @constructor
        instance.update(arguments...)
        @constructor.instance = instance
        ret = true
      else
        instance.release()
        @constructor.instance = null
        ret = false
    else
      @constructor.instance = @
    ret
