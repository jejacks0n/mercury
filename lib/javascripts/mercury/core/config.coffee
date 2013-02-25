@Mercury ||= {}

Mercury.Config =

  # Get a configuration value by path. Locates a configuration property by using a colon delimited string (a path).
  # Returns undefined if nothing was found.
  #
  # get('localization')                          => {enabled: true, preferred: 'en-US'}
  # get('localization:enabled')                  => true
  # get('something:odd')                         => undefined
  #
  get: (path) ->
    config = @configuration ||= Mercury.configuration ||= {}
    config = config[part] for part in path.split(':') if path
    config


  # Creates(sets) or updates a configuration value or object by using a nested object structure and sets the final
  # property of that object to the value passed.
  # Returns the value passed.
  #
  # Set or update a configuration property to the value provided.
  # set('localization:enabled', false)           => false
  # set('myPlugin', {enabled: true})             => {enabled: true}
  # set('myPlugin:enabled', true)                => true
  #
  # Set the global configuration by not passing the path (careful!).
  # set({foo: 'bar'})                            => {foo: 'bar'}
  #
  set: (args...) ->
    value = args.pop()
    path = args.shift()

    return @configuration = value unless path

    config = @configuration ||= Mercury.configuration ||= {}
    parts = path.split(':')
    part = parts.shift()
    while part
      if parts.length == 0
        config[part] = value
        return config[part]
      config = if config[part] then config[part] else config[part] = {}
      part = parts.shift()


Mercury.Config.Module =

  config: Mercury.Config.get
