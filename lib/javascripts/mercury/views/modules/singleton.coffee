Mercury.View.Modules.Singleton =

  ensureSingleton: ->
    instance = @constructor.instance
    if instance && instance instanceof @constructor
      instance.update(arguments...)
      return instance
    else
      instance?.release()
      @constructor.instance = @
      return false
