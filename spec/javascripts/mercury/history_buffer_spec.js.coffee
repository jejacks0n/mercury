describe "Mercury.HistoryBuffer", ->

  beforeEach ->
    @buffer = new Mercury.HistoryBuffer(5)

  afterEach ->
    @buffer = null
    delete(@buffer)

  describe "constructor", ->

    it "accepts a max length", ->
      expect(@buffer.maxLength).toEqual(5)

    it "initializes an empty stack", ->
      expect(@buffer.index).toEqual(0)
      expect(@buffer.stack).toEqual([])


  describe "#push", ->

    it "won't duplicate items if the content is the same", ->
      @buffer.push('1')
      expect(@buffer.stack).toEqual(['1'])

      @buffer.push('2<em class="mercury-marker"></em>')
      expect(@buffer.stack).toEqual(['1', '2<em class="mercury-marker"></em>'])

    it "pushes onto the stack where it should", ->
      @buffer.push('1')
      @buffer.push('2')
      expect(@buffer.stack).toEqual(['1', '2'])

      @buffer.index = 0
      @buffer.push('3')
      expect(@buffer.stack).toEqual(['1', '3'])

    it "keeps the number of items within the max length by dropping the oldest items", ->
      @buffer.push('1')
      @buffer.push('2')
      @buffer.push('3')
      @buffer.push('4')
      @buffer.push('5')
      expect(@buffer.stack).toEqual(['1', '2', '3', '4', '5'])
      @buffer.push('6')
      expect(@buffer.stack).toEqual(['2', '3', '4', '5', '6'])


  describe "#undo", ->

    beforeEach ->
      @buffer.push('1')
      @buffer.push('2')

    it "returns the correct item", ->
      expect(@buffer.undo()).toEqual('1')

    it "returns null if there are no more items to undo", ->
      expect(@buffer.undo()).toEqual('1')
      expect(@buffer.undo()).toEqual(null)


  describe "#redo", ->

    beforeEach ->
      @buffer.push('1')
      @buffer.push('2')

    it "returns the correct item", ->
      @buffer.undo()
      expect(@buffer.redo()).toEqual('2')

    it "returns null if there are no more items to redo", ->
      @buffer.undo()
      expect(@buffer.redo()).toEqual('2')
      expect(@buffer.redo()).toEqual(null)
