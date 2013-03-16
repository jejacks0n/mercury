#= require spec_helper
#= require mercury/core/stack

describe "Mercury.Stack", ->

  Klass = ->
  subject = null

  beforeEach ->
    Klass:: = Mercury.Stack
    subject = new Klass()
    subject.included()

  describe "#included", ->

    it "sets up the expected variables", ->
      expect( subject.stackPosition ).to.eq(0)
      expect( subject.stack ).to.eql([])
      expect( subject.maxStackLength ).to.eq(200)


  describe "#pushStack", ->

    it "pushes the item onto the array", ->
      subject.pushStack('a')
      expect( subject.stack.length ).to.eq(1)
      expect( subject.stack[0] ).to.eq('a')

    it "sets the stack position", ->
      subject.pushStack('a')
      expect( subject.stackPosition ).to.eq(0)
      subject.pushStack('b')
      expect( subject.stackPosition ).to.eq(1)

    it "truncates the array if it's longer than what we expect", ->
      subject.stack = [1, 2, 3, 4, 5]
      subject.pushStack('a')
      expect( subject.stack ).to.eql([1, 'a'])

    it "shifts off the beginning if the length is more than the max", ->
      subject.maxStackLength = 5
      subject.stack = [1, 2, 3, 4, 5]
      subject.stackPosition = 5
      subject.pushStack('a')
      expect( subject.stack ).to.eql([2, 3, 4, 5, 'a'])

    it "does nothing if the value is null", ->
      subject.pushStack(null)
      subject.pushStack(null)
      subject.pushStack(null)
      expect( subject.stackPosition ).to.eq(0)
      expect( subject.stack ).to.eql([])

    it "doesn't push if the current value is being pushed more than once", ->
      subject.pushStack(1)
      subject.pushStack(1)
      subject.pushStack(1)
      expect( subject.stackPosition ).to.eq(0)
      expect( subject.stack ).to.eql([1])


  describe "#undoStack", ->

    it "returns null if we're at the beginning of the stack", ->
      expect( subject.undoStack() ).to.be.null

    it "descreases the stack position", ->
      subject.stackPosition = 5
      subject.undoStack()
      expect( subject.stackPosition ).to.eq(4)

    it "returns the value at the expected position", ->
      subject.stack = ['a', 'b', 'c', 'd', 'e']
      subject.stackPosition = 5
      expect( subject.undoStack() ).to.eq('e')
      expect( subject.undoStack() ).to.eq('d')
      expect( subject.undoStack() ).to.eq('c')


  describe "#redoStack", ->

    beforeEach ->
      subject.stack = ['a', 'b', 'c', 'd', 'e']
      subject.stackPosition = 1

    it "returns null if we're at the end of the stack", ->
      subject.stackPosition = 5
      expect( subject.redoStack() ).to.be.null

    it "increases the stack position", ->
      subject.redoStack()
      expect( subject.stackPosition ).to.eq(2)

    it "returns the value at the expected position", ->
      expect( subject.redoStack() ).to.eq('c')
      expect( subject.redoStack() ).to.eq('d')
      expect( subject.redoStack() ).to.eq('e')
