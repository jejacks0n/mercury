describe "Mercury.modalHandlers.insertLink", ->

  beforeEach ->
    fixture.load('mercury/modals/insertlink.html')
    Mercury.region = null
    @modal =
      element: $(fixture.el)
      hide: ->
      resize: ->
    @insertLink = $.extend(@modal, Mercury.modalHandlers.insertLink)
    window.mercuryInstance = {document: $(document)}

  describe "initializing", ->

    beforeEach ->
      @insertLink.initialize()

    it "loads all links with a name into the existing bookmarks pulldown", ->
      options = $('#link_existing_bookmark').html()
      expect(options).toContain('link1')
      expect(options).toContain('link2')
      expect(options).toContain('Link Two')


  describe "clicking on a radio button (in a label)", ->

    beforeEach ->
      @insertLink.initialize()

    it "focuses the next input with a selectable class", ->
      spy = spyOn($.fn, 'focus').andCallFake(=>)
      jasmine.simulate.click($('input[value=external_url]').get(0))
      expect(spy.callCount).toEqual(1)


  describe "focusing an input", ->

    beforeEach ->
      @insertLink.initialize()

    it "checks the corresponding checkbox", ->
      $('#link_existing_bookmark').focus()
      expect($('input[value=existing_bookmark]').get(0).checked).toEqual(true)


  describe "changing the link target", ->

    it "shows options for whatever was selected", ->
      $('#link_target').val('popup')
      @insertLink.onChangeTarget()
      expect($('#popup_options').is(':visible')).toEqual(true)

    it "calls resize", ->
      spy = spyOn(@modal, 'resize')
      @insertLink.onChangeTarget()
      expect(spy.callCount).toEqual(1)


  describe "when editing", ->

    describe "a standard link", ->

      beforeEach ->
        Mercury.region = selection: => {
          commonAncestor: -> $('<a>', {href: 'http://cnn.com', target: '_top'}).html('foo'),
        }
        @insertLink.initialize()

      it "hides the link text input", ->
        expect($('#link_text_container').is(':visible')).toEqual(false)

      it "pre-fills the link url input", ->
        expect($('#link_external_url').val()).toEqual('http://cnn.com')

      it "selects the target if one's available", ->
        expect($('#link_target').val()).toEqual('_top')

    describe "a javascript popup link", ->

      beforeEach ->
        Mercury.region = selection: => {
          commonAncestor: -> $('<a>', {href: "javascript:void(window.open('http://cnn.com', 'popup_window', 'width=100,height=42,menubar=no,toolbar=no'))"}).html('foo')
        }
        @insertLink.initialize()

      it "hides the link text input", ->
        expect($('#link_text_container').is(':visible')).toEqual(false)

      it "pre-fills the link url input", ->
        expect($('#link_external_url').val()).toEqual('http://cnn.com')

      it "selects the target", ->
        expect($('#link_target').val()).toEqual('popup')

      it "sets the width and height by parsing them out of the href", ->
        expect($('#link_popup_width').val()).toEqual('100')
        expect($('#link_popup_height').val()).toEqual('42')

    describe "a bookmark link", ->

      beforeEach ->
        Mercury.region = selection: => {
          commonAncestor: -> $('<a>', {href: '#link2'}).html('foo')
        }
        @insertLink.initialize()

      it "hides the link text input", ->
        expect($('#link_text_container').is(':visible')).toEqual(false)

      it "checks the existing bookmark radio", ->
        expect($('input[value=existing_bookmark]').get(0).checked).toEqual(true)

      it "selects the correct option from the list", ->
        expect($('#link_existing_bookmark').val()).toEqual('link2')

    describe "a bookmark target", ->

      beforeEach ->
        Mercury.region = selection: => {
          commonAncestor: -> $('<a>', {name: 'link3'}).html('foo')
        }
        @insertLink.initialize()

      it "hides the link text input", ->
        expect($('#link_text_container').css('display')).toEqual('none')

      it "checks the new bookmark radio", ->
        expect($('input[value=new_bookmark]').get(0).checked).toEqual(true)

      it "sets the link name input", ->
        expect($('#link_new_bookmark').val()).toEqual('link3')


  describe "validating", ->

    beforeEach ->
      @insertLink.initialize()
      @triggerSpy = spyOn(Mercury, 'trigger').andCallFake(=>)
      $('#link_text').val('foo')

    it "displays an error if there's no content", ->
      $('#link_text').val('')
      @insertLink.validateForm()
      expect(@insertLink.valid).toEqual(false)
      expect($('#link_text').closest('.control-group').find('.error-message').html()).toEqual("can't be blank")

    describe "a standard link", ->

      it "displays an error", ->
        @insertLink.validateForm()
        expect(@insertLink.valid).toEqual(false)
        expect($('#link_external_url').closest('.control-group').find('.error-message').html()).toEqual("can't be blank")

      it "doesn't submit", ->
        @insertLink.validateForm()
        expect(@triggerSpy.callCount).toEqual(0)

    describe "a bookmark link", ->

      beforeEach ->
        jasmine.simulate.click($('input[value=existing_bookmark]').get(0))
        $('#link_existing_bookmark').html('').val('')

      it "displays an error", ->
        @insertLink.validateForm()
        expect(@insertLink.valid).toEqual(false)
        expect($('#link_existing_bookmark').closest('.control-group').find('.error-message').html()).toEqual("can't be blank")

      it "doesn't submit", ->
        @insertLink.validateForm()
        expect(@triggerSpy.callCount).toEqual(0)

    describe "a bookmark target", ->

      beforeEach ->
        jasmine.simulate.click($('input[value=new_bookmark]').get(0))

      it "displays an error", ->
        @insertLink.validateForm()
        expect(@insertLink.valid).toEqual(false)
        expect($('#link_new_bookmark').closest('.control-group').find('.error-message').html()).toEqual("can't be blank")

      it "doesn't submit", ->
        @insertLink.validateForm()
        expect(@triggerSpy.callCount).toEqual(0)


  describe "submitting", ->

    describe "a new link", ->

      beforeEach ->
        @insertLink.initialize()
        @triggerSpy = spyOn(Mercury, 'trigger').andCallFake(=>)
        $('#link_text').val('foo')

      it "doesn't submit unless it's valid", ->
        $('#link_text').val('')
        spy = spyOn(@modal, 'hide')
        jasmine.simulate.click($('input[type=submit]').get(0))
        expect(spy.callCount).toEqual(0)
        expect(@insertLink.valid).toEqual(false)

      it "hides the modal", ->
        $('#link_external_url').val('http://cnn.com')
        spy = spyOn(@modal, 'hide')
        jasmine.simulate.click($('input[type=submit]').get(0))
        expect(spy.callCount).toEqual(1)

      describe "as a standard link", ->

        beforeEach ->
          $('#link_external_url').val('http://cnn.com')
          $('#link_target').val('_top')

        it "triggers an action with the proper values", ->
          jasmine.simulate.click($('input[type=submit]').get(0))
          expect(@triggerSpy.callCount).toEqual(1)
          expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
          expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertLink')
          expect(@triggerSpy.argsForCall[0][1]['value']).toEqual({tagName: 'a', attrs: {href: 'http://cnn.com', target: '_top'}, content: 'foo'})

      describe "as a javascript popup", ->

        beforeEach ->
          $('#link_external_url').val('http://cnn.com')
          $('#link_target').val('popup')
          $('#link_popup_width').val(100)
          $('#link_popup_height').val('42')

        it "triggers an action with the proper values", ->
          jasmine.simulate.click($('input[type=submit]').get(0))
          expect(@triggerSpy.callCount).toEqual(1)
          expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
          expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertLink')
          expect(@triggerSpy.argsForCall[0][1]['value']).toEqual({tagName: 'a', attrs: {href: "javascript:void(window.open('http://cnn.com', 'popup_window', 'width=100,height=42,menubar=no,toolbar=no'))"}, content: 'foo'})

      describe "as an existing bookmark", ->

        beforeEach ->
          $('#link_existing_bookmark').val('link2')
          $('input[value=existing_bookmark]').prop('checked', true)

        it "triggers an action with the proper values", ->
          jasmine.simulate.click($('input[type=submit]').get(0))
          expect(@triggerSpy.callCount).toEqual(1)
          expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
          expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertLink')
          expect(@triggerSpy.argsForCall[0][1]['value']).toEqual({tagName: 'a', attrs: {href: '#link2'}, content: 'foo'})

      describe "as a new bookmark", ->

        beforeEach ->
          $('#link_new_bookmark').val('link3')
          $('input[value=new_bookmark]').prop('checked', true)

        it "triggers an action with the proper values", ->
          jasmine.simulate.click($('input[type=submit]').get(0))
          expect(@triggerSpy.callCount).toEqual(1)
          expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
          expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertLink')
          expect(@triggerSpy.argsForCall[0][1]['value']).toEqual({tagName: 'a', attrs: {name: 'link3'}, content: 'foo'})

    describe "editing an existing link", ->

      beforeEach ->
        @existingLink = $('<a>', {name: 'link3'}).html('foo')
        Mercury.region = selection: => {
          commonAncestor: => @existingLink
        }
        @insertLink.initialize()
        @triggerSpy = spyOn(Mercury, 'trigger').andCallFake(=>)
        $('#link_text').val('foo')

      it "hides the modal", ->
        spy = spyOn(@modal, 'hide').andCallFake(=>)
        jasmine.simulate.click($('input[type=submit]').get(0))
        expect(spy.callCount).toEqual(1)

      describe "as a standard link", ->

        beforeEach ->
          $('#link_external_url').val('http://cnn.com')
          $('#link_target').val('_top')
          $('input[value=external_url]').prop('checked', true)

        it "triggers an action with the proper values", ->
          jasmine.simulate.click($('input[type=submit]').get(0))
          expect(@triggerSpy.callCount).toEqual(1)
          expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
          expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('replaceLink')
          expect(@triggerSpy.argsForCall[0][1]['value']).toEqual({tagName: 'a', attrs: {href: 'http://cnn.com', target: '_top'}, content: 'foo'})
          expect(@triggerSpy.argsForCall[0][1]['node']).toEqual(@existingLink.get(0))
