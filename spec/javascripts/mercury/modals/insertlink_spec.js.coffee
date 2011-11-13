describe "Mercury.modalHandlers.insertLink", ->

  template 'mercury/modals/insertlink.html'

  beforeEach ->
    Mercury.region = null
    @modal =
      element: $('#test')
      hide: ->
      resize: ->
    window.mercuryInstance = {document: $(document)}

  describe "initializing", ->

    beforeEach ->
      Mercury.modalHandlers.insertLink.call(@modal)

    it "loads all links with a name into the existing bookmarks pulldown", ->
      options = $('#link_existing_bookmark').html()
      expect(options).toContain('link1')
      expect(options).toContain('link2')
      expect(options).toContain('Link Two')


  describe "clicking on a radio button (in a label)", ->

    beforeEach ->
      Mercury.modalHandlers.insertLink.call(@modal)

    it "focuses the next input with a selectable class", ->
      spy = spyOn($.fn, 'focus').andCallFake(=>)
      jasmine.simulate.click($('#checkbox1').get(0))
      expect(spy.callCount).toEqual(1)


  describe "focusing an input", ->

    beforeEach ->
      Mercury.modalHandlers.insertLink.call(@modal)

    it "checks the corresponding checkbox", ->
      $('#link_existing_bookmark').focus()
      expect($('#checkbox2').get(0).checked).toEqual(true)


  describe "changing the link target", ->

    it "shows options for whatever was selected", ->
    it "calls resize", ->


  describe "when editing", ->

    describe "a standard link", ->

      beforeEach ->
        Mercury.region = selection: => {
          commonAncestor: -> $('<a>', {href: 'http://cnn.com', target: '_top'}).html('foo'),
          textContent: -> 'content'
          }
        Mercury.modalHandlers.insertLink.call(@modal)

      it "hides the link text input", ->
        expect($('#link_text_container').css('display')).toEqual('none')

      it "pre-fills the link url input", ->
        expect($('#link_external_url').val()).toEqual('http://cnn.com')

      it "selects the target if one's available", ->
        expect($('#link_target').val()).toEqual('_top')

      it "fills the content", ->
        expect($('#link_text').val()).toEqual('content')

    describe "a javascript popup link", ->

      beforeEach ->
        Mercury.region = selection: => {commonAncestor: -> $('<a>', {href: "javascript:void(window.open('http://cnn.com', 'popup_window', 'width=100,height=42,menubar=no,toolbar=no'))"}).html('foo')}
        Mercury.modalHandlers.insertLink.call(@modal)

      it "hides the link text input", ->
        expect($('#link_text_container').css('display')).toEqual('none')

      it "pre-fills the link url input", ->
        expect($('#link_external_url').val()).toEqual('http://cnn.com')

      it "selects the target", ->
        expect($('#link_target').val()).toEqual('popup')

      it "sets the width and height by parsing them out of the href", ->
        expect($('#link_popup_width').val()).toEqual('100')
        expect($('#link_popup_height').val()).toEqual('42')

    describe "a bookmark link", ->

      beforeEach ->
        Mercury.region = selection: => {commonAncestor: -> $('<a>', {href: '#link2'}).html('foo')}
        Mercury.modalHandlers.insertLink.call(@modal)

      it "hides the link text input", ->
        expect($('#link_text_container').css('display')).toEqual('none')

      it "checks the existing bookmark radio", ->
        expect($('input[value=existing_bookmark]').get(0).checked).toEqual(true)

      it "selects the correct option from the list", ->
        expect($('#link_existing_bookmark').val()).toEqual('link2')

    describe "a bookmark target", ->

      beforeEach ->
        Mercury.region = selection: => {commonAncestor: -> $('<a>', {name: 'link3'}).html('foo')}
        Mercury.modalHandlers.insertLink.call(@modal)

      it "hides the link text input", ->
        expect($('#link_text_container').css('display')).toEqual('none')

      it "checks the new bookmark radio", ->
        expect($('input[value=new_bookmark]').get(0).checked).toEqual(true)

      it "sets the link name input", ->
        expect($('#link_new_bookmark').val()).toEqual('link3')


  describe "submitting", ->

    describe "a new link", ->

      beforeEach ->
        Mercury.modalHandlers.insertLink.call(@modal)
        @triggerSpy = spyOn(Mercury, 'trigger').andCallFake(=>)
        $('#link_text').val('foo')

      it "hides the modal", ->
        spy = spyOn(@modal, 'hide').andCallFake(=>)
        jasmine.simulate.click($('#submit').get(0))
        expect(spy.callCount).toEqual(1)

      describe "as a standard link", ->

        beforeEach ->
          $('#link_external_url').val('http://cnn.com')
          $('#link_target').val('_top')

        it "triggers an action with the proper values", ->
          jasmine.simulate.click($('#submit').get(0))
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
          jasmine.simulate.click($('#submit').get(0))
          expect(@triggerSpy.callCount).toEqual(1)
          expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
          expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertLink')
          expect(@triggerSpy.argsForCall[0][1]['value']).toEqual({tagName: 'a', attrs: {href: "javascript:void(window.open('http://cnn.com', 'popup_window', 'width=100,height=42,menubar=no,toolbar=no'))"}, content: 'foo'})

      describe "as an existing bookmark", ->

        beforeEach ->
          $('#link_existing_bookmark').val('link2')
          $('input[value=existing_bookmark]').prop('checked', true)

        it "triggers an action with the proper values", ->
          jasmine.simulate.click($('#submit').get(0))
          expect(@triggerSpy.callCount).toEqual(1)
          expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
          expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertLink')
          expect(@triggerSpy.argsForCall[0][1]['value']).toEqual({tagName: 'a', attrs: {href: '#link2'}, content: 'foo'})

      describe "as a new bookmark", ->

        beforeEach ->
          $('#link_new_bookmark').val('link3')
          $('input[value=new_bookmark]').prop('checked', true)

        it "triggers an action with the proper values", ->
          jasmine.simulate.click($('#submit').get(0))
          expect(@triggerSpy.callCount).toEqual(1)
          expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
          expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertLink')
          expect(@triggerSpy.argsForCall[0][1]['value']).toEqual({tagName: 'a', attrs: {name: 'link3'}, content: 'foo'})

    describe "editing an existing link", ->

      beforeEach ->
        @existingLink = $('<a>', {name: 'link3'}).html('foo')
        Mercury.region = selection: => {commonAncestor: => @existingLink}
        Mercury.modalHandlers.insertLink.call(@modal)
        @triggerSpy = spyOn(Mercury, 'trigger').andCallFake(=>)
        $('#link_text').val('foo')

      it "hides the modal", ->
        spy = spyOn(@modal, 'hide').andCallFake(=>)
        jasmine.simulate.click($('#submit').get(0))
        expect(spy.callCount).toEqual(1)

      describe "as a standard link", ->

        beforeEach ->
          $('#link_external_url').val('http://cnn.com')
          $('#link_target').val('_top')
          $('input[value=external_url]').prop('checked', true)

        it "triggers an action with the proper values", ->
          jasmine.simulate.click($('#submit').get(0))
          expect(@triggerSpy.callCount).toEqual(1)
          expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
          expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('replaceLink')
          expect(@triggerSpy.argsForCall[0][1]['value']).toEqual({tagName: 'a', attrs: {href: 'http://cnn.com', target: '_top'}, content: 'foo'})
          expect(@triggerSpy.argsForCall[0][1]['node']).toEqual(@existingLink.get(0))
