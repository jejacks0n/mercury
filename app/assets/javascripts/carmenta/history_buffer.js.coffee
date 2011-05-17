class Carmenta.HistoryBuffer

  constructor: (@maxLength = 200) ->
    @index = 0
    @stack = []


  push: (item) ->
    return if @stack[@index] && @stack[@index].replace(/<em class="carmenta-marker"><\/em>/g, '') == item.replace(/<em class="carmenta-marker"><\/em>/g, '') # if it's the same, don't do anything

    @stack = @stack[0...@index + 1]
    @stack.push(item)
    @stack.shift() if @stack.length > @maxLength
    @index = @stack.length - 1

    console.debug('----------------------------------------------------------------', @stack.length)
    console.debug(@stack[0...@stack.length])


  undo: ->
    return null if @index < 1
    @index -= 1
    return @stack[@index]


  redo: ->
    return null if @index > @stack.length - 2
    @index += 1
    return @stack[@index]
