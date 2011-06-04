class Mercury.HistoryBuffer

  constructor: (@maxLength = 200) ->
    @index = 0
    @stack = []
    @markerRegExp = /<em class="mercury-marker"><\/em>/g


  push: (item) ->
    return if @stack[@index] && typeof(item) == 'string' && @stack[@index].replace(@markerRegExp, '') == item.replace(@markerRegExp, '')

    @stack = @stack[0...@index + 1]
    @stack.push(item)
    @stack.shift() if @stack.length > @maxLength
    @index = @stack.length - 1

    #Mercury.log(@stack.length, '------------------------------------------------------------')
    #Mercury.log(@stack)


  undo: ->
    return null if @index < 1
    @index -= 1
    return @stack[@index]


  redo: ->
    return null if @index >= @stack.length - 1
    @index += 1
    return @stack[@index]
