instances = {}
Mercury.View.Modules.Singleton =

  ensureSingleton: (name, args...) ->
    instance = instances[name]
    if instance && instance.constructor == @constructor
      instance.update(args...)
      return instance
    else
      instance?.release()
      instances[name] = @
      return false


  removeSingleton: (name) ->
    instances[name] = null
