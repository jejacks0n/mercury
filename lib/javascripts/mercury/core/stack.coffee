(@Mercury ||= {}).Stack =

  # When included as a module this method is called and will setup the required instance variables. You can override the
  # maxStackLength by setting it in your constructor.
  #
  included: ->
    @stackPosition = 0
    @maxStackLength = 200
    @stack = []


  # Pushes a given value to the stack.
  # Returns the position of the new item in the stack.
  #
  pushStack: (value) ->
    return if value == null || @stackEquality(value)
    @stack = @stack[0...@stackPosition + 1]
    @stack.push(value)
    @stack.shift() if @stack.length > @maxStackLength
    @stackPosition = @stack.length - 1


  # Provides a way to override how values are compared before being pushed onto the stack.
  # Returns true if the values are the same.
  #
  stackEquality: (value) ->
    JSON.stringify(@stack[@stackPosition]) == JSON.stringify(value)


  # Rolls back to the previous stack item.
  # Returns the value at the previous position in the stack, or null if at the beginning of the stack.
  #
  undoStack: ->
    return null if @stackPosition < 1
    @stackPosition -= 1
    return @stack[@stackPosition]


  # Moves forward in the stack to the version after this one.
  # Returns the value at the next position in the stack, or null if at the end of the stack.
  #
  redoStack: ->
    return null if @stackPosition >= @stack.length - 1
    @stackPosition += 1
    return @stack[@stackPosition]
