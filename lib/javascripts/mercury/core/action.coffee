#= require mercury/core/i18n
#= require mercury/core/logger
#= require mercury/core/module
@Mercury ||= {}

class Mercury.Action extends Mercury.Module
  @include Mercury.I18n
  @include Mercury.Logger

  @logPrefix: 'Mercury.Action:'

  # Provides the means to either resolve to a specific action class or fall back to the base action. In the case where
  # we want to pass a model (or anything other than a plain object) we return that model instance, or whatever else it
  # may be.
  #
  @create: (name, attrsOrOther = {}) ->
    if $.isPlainObject(attrsOrOther)
      klass = name.toCamelCase(true)
      return new Mercury.Action[klass](attrsOrOther) if Mercury.Action[klass]
      new Mercury.Action(name, attrsOrOther)
    else
      attrsOrOther


  # The constructor accepts attributes and will set them to @attributes, which can be retrieved using the #get method.
  # The first arg is name, the second is attributes. It's expected to pass a name when instantiating Action directly,
  # but subclasses are expected to define their own name, in which case it should not be passed. Use .create to not have
  # to worry about it.
  #
  constructor: (args...) ->
    @name ||= args.shift()
    @attributes = args.pop() || {}
    super


  # Getter for attributes. It's advised to use this method when getting attributes, but you're encouraged to provide
  # your own getters that call through to this. This provides a similar interface to models.
  # Returns the attribute value, or undefined if the attribute doesn't exist.
  #
  get: (key) ->
    @attributes[key]
