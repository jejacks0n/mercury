(@Mercury ||= {}).Logger =

  logPrefix: 'Mercury:'

  # Logs the arguments passed using console.debug, adding in the prefix if it exists.
  #
  # log(1, 2)                                    => console.debug('Mercury:', 1, 2)
  #
  log: (args...) ->
    return unless Mercury.configuration.logging?.enabled
    args.unshift(@logPrefix || @constructor.logPrefix) if @logPrefix || @constructor.logPrefix
    console?.debug?(args...)


  # Notify (typically a developer) that there was a problem using console.error, falling back to throwing an exception.
  # Uses console.trace to show you where the notification came from if it's available.
  #
  # notify('something went wrong')               => console.error('Mercury: something went wrong')
  #
  notify: (msg) ->
    msg = "#{@constructor.logPrefix || @logPrefix} #{msg}" if @logPrefix || @constructor.logPrefix

    if Mercury.configuration.logging?.notifier == 'console'
      try return console.error(msg) catch e # intentionally do nothing
    else if Mercury.configuration.logging?.notifier == 'alert'
      return alert(msg)

    throw new Error(msg)
