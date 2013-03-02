@Mercury ||= {}

Mercury.Logger =

  logPrefix: 'Mercury:'

  # Logs the arguments passed using console.debug, adding in the prefix if it exists.
  #
  # log(1, 2)                                    => console.debug('Mercury:', 1, 2)
  #
  log: (args...) ->
    return unless Mercury.configuration.logging?.enabled
    args.unshift(@logPrefix) if @logPrefix
    console?.debug?(args...)


  # Notify (typically a developer) that there was a problem using console.error, falling back to throwing an exception.
  # Uses console.trace to show you where the notification came from if it's available.
  #
  # notify('something went wrong')               => console.error('Mercury: something went wrong')
  #
  notify: (msg) ->
    msg = "#{@logPrefix} #{msg}" if @logPrefix
    try
      console.error(msg)
      console.trace?()
    catch e
      switch Mercury.configuration.logging?.notifier
        when 'alert' then alert(msg)
        when 'error' then throw new Error(msg)
