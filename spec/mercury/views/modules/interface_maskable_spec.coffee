#= require spec_helper
#= require mercury/core/view
#= require mercury/views/modules/interface_maskable

describe "Mercury.View.Modules.InterfaceMaskable", ->

  Klass = null
  Module = Mercury.View.Modules.InterfaceMaskable
  subject = null

  beforeEach ->
    class Klass extends Mercury.View
      @include Module
    subject = new Klass()
    @mock =
      on: spy(),
      buildInterfaceMaskable: ->

  describe "#included", ->

    it "binds to the build event", ->
      Module.included.call(@mock)
      expect( @mock.on ).calledWith('build', @mock.buildInterfaceMaskable)


  describe "#extended", ->

    it "binds to the build event", ->
      Module.extended.call(@mock)
      expect( @mock.on ).calledWith('build', @mock.buildInterfaceMaskable)
      Module.extended.call(@mock)


  describe "#buildInterfaceMaskable", ->

    it "appends a mask element", ->
      spyOn(window, '$', -> '_mask_')
      spyOn(subject, 'append')
      subject.buildInterfaceMaskable()
      expect( $ ).calledWith('<div class="mercury-interface-mask">')
      expect( subject.append ).calledWith('_mask_')

    it "calls #delegateEvents", ->
      spyOn(subject, 'delegateEvents')
      subject.buildInterfaceMaskable()
      expect( subject.delegateEvents ).calledWith
        'mercury:interface:mask': subject.mask
        'mercury:interface:unmask': subject.unmask
        'mousedown .mercury-interface-mask': subject.prevent
        'mouseup .mercury-interface-mask': subject.prevent
        'click .mercury-interface-mask': subject.onMaskClick


  describe "#mask", ->

    beforeEach ->
      subject.$mask = show: spy()

    it "calls show on the mask", ->
      subject.mask()
      expect( subject.$mask.show ).called


  describe "#unmask", ->

    beforeEach ->
      subject.$mask = hide: spy()

    it "calls hide on the mask", ->
      subject.unmask()
      expect( subject.$mask.hide ).called


  describe 'onMaskClick', ->

    beforeEach ->
      @e =
        preventDefault: spy()
        stopPropagation: spy()

    it "prevents the event and stops propagation", ->
      subject.onMaskClick(@e)
      expect( @e.preventDefault ).called
      expect( @e.stopPropagation ).called

    it "triggers a global dialogs:hide event", ->
      spyOn(Mercury, 'trigger')
      subject.onMaskClick(@e)
      expect( Mercury.trigger ).calledWith('dialogs:hide')
