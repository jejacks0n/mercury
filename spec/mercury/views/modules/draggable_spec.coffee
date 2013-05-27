#= require spec_helper
#= require mercury/core/view
#= require mercury/views/modules/draggable

describe "Mercury.View.Modules.Draggable", ->

  Klass = null
  Module = Mercury.View.Modules.Draggable
  subject = null

  beforeEach ->
    class Klass extends Mercury.View
      @include Module
    subject = new Klass()

  describe "#startDrag", ->

    beforeEach ->
      @e =
        button: 1
        preventDefault: spy()
        pageX: 666
        pageY: 42
      spyOn(subject.$el, 'position', -> left: 20, top: 40)

    it "does nothing if the button wasn't the left button", ->
      @e.button = 2
      expect( subject.startDrag(@e) ).to.be.undefined
      expect( @e.preventDefault ).not.called

    it "prevents the event", ->
      subject.startDrag(@e)
      expect( @e.preventDefault ).called

    it "gets and assigns the @viewportSize", ->
      spyOn($.fn, 'width', -> 200)
      spyOn($.fn, 'height', -> 400)
      subject.startDrag(@e)
      expect( subject.viewportSize ).to.eql(width: 200, height: 400)

    it "calculates the @dragPosition from the element position", ->
      subject.startDrag(@e)
      expect( subject.dragPosition ).to.eql(x: -20, y: -40)

    it "calls #potentialDragStart with the x/y of the event", ->
      spyOn(subject, 'potentialDragStart')
      subject.startDrag(@e)
      expect( subject.potentialDragStart ).calledWith(666, 42)


  describe "#potentialDragStart", ->

    beforeEach ->
      subject.dragPosition = x: 100, y: 200
      spyOn(subject, 'bindDocumentDragEvents')

    it "sets the @startPosition from @dragPosition", ->
      subject.potentialDragStart(10, 20)
      expect( subject.startPosition ).to.eql(x: 100, y: 200)

    it "sets the @initialPosition", ->
      subject.potentialDragStart(10, 20)
      expect( subject.initialPosition ).to.eql(x: 10, y: 20)

    it "tracks that we're potentially dragging", ->
      subject.potentiallyDragging = false
      subject.potentialDragStart(10, 20)
      expect( subject.potentiallyDragging ).to.be.true

    it "calls #bindDocumentDragEvents with the current document", ->
      subject.potentialDragStart(10, 20)
      expect( subject.bindDocumentDragEvents ).calledWith(document)

    it "calls #bindDocumentDragEvents with Mercury.interface.document if it's not the same as the current document", ->
      Mercury.interface.document = document
      subject.potentialDragStart(10, 20)
      expect( subject.bindDocumentDragEvents ).calledOnce
      Mercury.interface.document = '_document_'
      subject.potentialDragStart(10, 20)
      expect( subject.bindDocumentDragEvents ).calledWith('_document_')


  describe "#onStartDragging", ->

    it "adds a mercury-no-animation class", ->
      spyOn(subject, 'addClass')
      subject.onStartDragging()
      expect( subject.addClass ).calledWith('mercury-no-animation')

    it "sets @dragging to true", ->
      subject.dragging = false
      subject.onStartDragging()
      expect( subject.dragging ).to.be.true

    it "re-sets the @initialPosition", ->
      subject.onStartDragging(1, 2)
      expect( subject.initialPosition ).to.eql(x: 1, y: 2)

    it "calls #onDragStart if there's one defined", ->
      subject.onDragStart = spy()
      subject.onStartDragging()
      expect( subject.onDragStart ).called


  describe "#onDrag", ->

    beforeEach ->
      subject.startPosition = x: 100, y: 200
      subject.initialPosition = x: 10, y: 20
      @e =
        preventDefault: spy()
        pageX: 1
        pageY: 2

    it "prevents the event", ->
      subject.onDrag(@e)
      expect( @e.preventDefault ).called

    describe "when potentially dragging", ->

      beforeEach ->
        @e.pageX = 10
        @e.pageY = 20

      it "calls #onStartDragging if dragged more than 5 pixels in any direction", ->
        spyOn(subject, 'onStartDragging')
        subject.onDrag(@e)
        expect( subject.onStartDragging ).not.called

        @e.pageY = 2
        subject.dragging = true
        subject.onDrag(@e)
        expect( subject.onStartDragging ).not.called

        subject.dragging = false
        subject.onDrag(@e)
        expect( subject.onStartDragging ).calledWith(10, 2)

        @e.pageX = 2
        @e.pageY = 20
        subject.onDrag(@e)
        expect( subject.onStartDragging ).calledWith(2, 20)

    describe "when dragging", ->

      beforeEach ->
        subject.dragging = true

      it "tracks the @lastPosition (from the current @dragPosition)", ->
        subject.dragPosition = '_drag_position_'
        subject.onDrag(@e)
        expect( subject.lastPosition ).to.eq('_drag_position_')

      it "updates the @dragPosition", ->
        subject.onDrag(@e)
        expect( subject.dragPosition ).to.eql(x: -109, y: -218)

      it "calls #setPositionOnDrag", ->
        spyOn(subject, 'setPositionOnDrag')
        subject.onDrag(@e)
        expect( subject.setPositionOnDrag ).calledWith(-109, -218)


  describe "#onEndDragging", ->

    beforeEach ->
      spyOn(subject, 'unbindDocumentDragEvents')

    it "calls #onDragEnd if it's defined and we're dragging", ->
      subject.onDragEnd = spy()
      subject.dragging = false
      subject.onEndDragging('_e_')
      expect( subject.onDragEnd ).not.called
      subject.dragging = true
      subject.onEndDragging('_e_')
      expect( subject.onDragEnd ).calledWith('_e_')

    it "sets @dragging/@potentiallyDragging to false", ->
      subject.dragging = true
      subject.potentiallyDragging = true
      subject.onEndDragging()
      expect( subject.dragging ).to.be.false
      expect( subject.potentiallyDragging ).to.be.false

    it "calls #unbindDocumentDragEvents with the current document", ->
      subject.onEndDragging()
      expect( subject.unbindDocumentDragEvents ).calledWith(document)

    it "calls #unbindDocumentDragEvents with Mercury.interface.document if it's not the same as the current document", ->
      Mercury.interface.document = document
      subject.onEndDragging()
      expect( subject.unbindDocumentDragEvents ).calledOnce
      Mercury.interface.document = '_document_'
      subject.onEndDragging()
      expect( subject.unbindDocumentDragEvents ).calledWith('_document_')


  describe "#bindDocumentDragEvents", ->

    beforeEach ->
      @mock = on: spy(=> @mock)
      spyOn(window, '$', => @mock)
      subject.bindDocumentDragEvents()

    it "binds to mousemove and mouseup", ->
      expect( @mock.on ).calledWith('mousemove', sinon.match.func)
      expect( @mock.on ).calledWith('mouseup', sinon.match.func)

    it "assigns @onDragHandler that calls #onDrag", ->
      spyOn(subject, 'onDrag')
      subject.onDragHandler('_e_')
      expect( subject.onDrag ).calledWith('_e_')

    it "assigns @onEndDraggingHandler that calls #onEndDragging", ->
      spyOn(subject, 'onEndDragging')
      subject.onEndDraggingHandler('_e_')
      expect( subject.onEndDragging ).calledWith('_e_')


  describe "#unbindDocumentDragEvents", ->

    beforeEach ->
      @mock = off: spy(=> @mock)
      spyOn(window, '$', => @mock)

    it "removes the mousemove and mouseup event handlers", ->
      subject.onDragHandler = '_on_drag_handler_'
      subject.onEndDraggingHandler = '_on_end_dragging_handler_'
      subject.unbindDocumentDragEvents()
      expect( @mock.off ).calledWith('mousemove', '_on_drag_handler_')
      expect( @mock.off ).calledWith('mouseup', '_on_end_dragging_handler_')


  describe "#setPositionOnDrag", ->

    it "calls #css with top and left", ->
      spyOn(subject, 'css')
      subject.setPositionOnDrag(666, 42)
      expect( subject.css ).calledWith(top: 42, left: 666)
