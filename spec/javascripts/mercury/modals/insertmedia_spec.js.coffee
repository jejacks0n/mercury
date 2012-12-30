describe "Mercury.modalHandlers.insertMedia", ->

  beforeEach ->
    fixture.load('mercury/modals/insertmedia.html')
    Mercury.region = null
    spyOn(window, 'setTimeout').andCallFake((callback, timeout) => callback())
    @modal =
      element: $(fixture.el)
      hide: ->
      resize: ->
    @insertMedia = $.extend(@modal, Mercury.modalHandlers.insertMedia)
    window.mercuryInstance = {document: $(document)}

  describe "clicking on a radio button (in a label)", ->

    beforeEach ->
      @insertMedia.initialize()

    it "focuses the next input with a selectable class", ->
      spy = spyOn($.fn, 'focus').andCallFake(=>)
      jasmine.simulate.click($('input[value=image_url]').get(0))
      expect(spy.callCount).toEqual(1)


  describe "focusing an input", ->

    beforeEach ->
      @insertMedia.initialize()

    it "checks the corresponding checkbox", ->
      $('#media_youtube_url').focus()
      expect($('input[value=youtube_url]').get(0).checked).toEqual(true)

    it "hides all the option divs", ->
      $('#media_youtube_url').focus()
      expect($('#image_url_options').css('display')).toEqual('none')
      expect($('#vimeo_url_options').css('display')).toEqual('none')

    it "shows the options for the item that was focused", ->
      $('#media_youtube_url').focus()
      expect($('#youtube_url_options').css('display')).toNotEqual('none')

    it "calls resize", ->
      spy = spyOn(@modal, 'resize').andCallFake(=>)
      $('#media_youtube_url').focus()
      expect(spy.callCount).toEqual(1)


  describe "when editing", ->

    describe "an existing image", ->

      beforeEach ->
        @focusSpy = spyOn($.fn, 'focus').andCallThrough()
        @selection = {is: -> $('<img>', {src: '/foo.gif', align: 'right', style: 'float: left;'})}
        Mercury.region = selection: => @selection
        @insertMedia.initialize()

      it "pre-fills the image url", ->
        expect($('#media_image_url').val()).toEqual('/foo.gif')

      it "focuses the url input", ->
        expect(@focusSpy.callCount).toEqual(2)
        expect($('input[value=image_url]').get(0).checked).toEqual(true)

      it "sets the image alignment option", ->
        expect($('#media_image_alignment').val()).toEqual('right')

      it "sets the image float option", ->
        expect($('#media_image_float').val()).toEqual('left')

    describe "an existing youtube video", ->

      beforeEach ->
        @focusSpy = spyOn($.fn, 'focus').andCallThrough()
        @selection = {is: -> $('<iframe>', {src: 'https://www.youtube.com/embed/foo?wmode=transparent', style: 'width:100px;height:42px'})}
        Mercury.region = selection: => @selection
        @insertMedia.initialize()

      it "pre-fills the url", ->
        expect($('#media_youtube_url').val()).toEqual('https://youtu.be/foo')

      it "focuses the url input", ->
        expect($('input[value=youtube_url]').get(0).checked).toEqual(true)

      it "sets the width option", ->
        expect($('#media_youtube_width').val()).toEqual('100')

      it "sets the height option", ->
        expect($('#media_youtube_height').val()).toEqual('42')

    describe "an existing vimeo video", ->

      beforeEach ->
        @focusSpy = spyOn($.fn, 'focus').andCallThrough()
        @selection = {is: -> $('<iframe>', {src: 'http://player.vimeo.com/video/foo?title=1&byline=1&portrait=0&color=ffffff', style: 'width:100px;height:42px'})}
        Mercury.region = selection: => @selection
        @insertMedia.initialize()

      it "pre-fills the url", ->
        expect($('#media_vimeo_url').val()).toEqual('http://vimeo.com/foo')

      it "focuses the url input", ->
        expect($('input[value=vimeo_url]').get(0).checked).toEqual(true)

      it "sets the width option", ->
        expect($('#media_vimeo_width').val()).toEqual('100')

      it "sets the height option", ->
        expect($('#media_vimeo_height').val()).toEqual('42')


  describe "validating", ->

    beforeEach ->
      @insertMedia.initialize()
      @triggerSpy = spyOn(Mercury, 'trigger').andCallFake(=>)

    describe "an image", ->

      it "displays an error", ->
        @insertMedia.validateForm()
        expect(@insertMedia.valid).toEqual(false)
        expect($('#media_image_url').closest('.control-group').find('.error-message').html()).toEqual("can't be blank")

      it "doesn't submit", ->
        @insertMedia.validateForm()
        expect(@triggerSpy.callCount).toEqual(0)

    describe "a youtube video", ->

      beforeEach ->
        $('input[value=youtube_url]').prop('checked', true)

      it "displays an error", ->
        @insertMedia.validateForm()
        expect(@insertMedia.valid).toEqual(false)
        expect($('#media_youtube_url').closest('.control-group').find('.error-message').html()).toEqual("is invalid")

      it "doesn't submit", ->
        @insertMedia.validateForm()
        expect(@triggerSpy.callCount).toEqual(0)

    describe "a vimeo video", ->
      beforeEach ->
        $('input[value=vimeo_url]').prop('checked', true)

      it "displays an error", ->
        @insertMedia.validateForm()
        expect(@insertMedia.valid).toEqual(false)
        expect($('#media_vimeo_url').closest('.control-group').find('.error-message').html()).toEqual("is invalid")

      it "doesn't submit", ->
        @insertMedia.validateForm()
        expect(@triggerSpy.callCount).toEqual(0)


  describe "submitting", ->

    beforeEach ->
      @insertMedia.initialize()
      @triggerSpy = spyOn(Mercury, 'trigger').andCallFake(=>)

    it "doesn't submit unless it's valid", ->
      spy = spyOn(@modal, 'hide')
      jasmine.simulate.click($('input[type=submit]').get(0))
      expect(spy.callCount).toEqual(0)
      expect(@insertMedia.valid).toEqual(false)

    it "hides the modal", ->
      $('#media_image_url').val('foo.gif')
      spy = spyOn(@modal, 'hide')
      jasmine.simulate.click($('input[type=submit]').get(0))
      expect(spy.callCount).toEqual(1)

    describe "an image", ->

      beforeEach ->
        $('#media_image_url').val('http://domain/foo.gif')
        $('#media_image_alignment').val('right')
        $('#media_image_float').val('left')

      it "triggers an action with the proper values", ->
        jasmine.simulate.click($('input[type=submit]').get(0))
        expect(@triggerSpy.callCount).toEqual(1)
        expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
        expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertImage')
        expect(@triggerSpy.argsForCall[0][1]['value']).toEqual({src: 'http://domain/foo.gif', align: 'right', style: 'float: left;'})

    describe "a youtube video", ->

      beforeEach ->
        $('#media_youtube_url').val('http://youtu.be/foo')
        $('#media_youtube_width').val(100)
        $('#media_youtube_height').val('42')
        $('input[value=youtube_url]').prop('checked', true)

      it "triggers an action with the proper values", ->
        $('#media_youtube_url').val('http://youtu.be/foo')
        jasmine.simulate.click($('input[type=submit]').get(0))
        expect(@triggerSpy.callCount).toEqual(1)
        expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
        expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertHTML')
        value = $('<div>').html(@triggerSpy.argsForCall[0][1]['value']).html()
        expect(value).toContain('100px')
        expect(value).toContain('42px')
        expect(value).toContain('src="http://www.youtube.com/embed/foo?wmode=transparent"')

      it "triggers an action with the proper values using https", ->
        $('#media_youtube_url').val('https://youtu.be/foo')
        jasmine.simulate.click($('input[type=submit]').get(0))
        expect(@triggerSpy.callCount).toEqual(1)
        expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
        expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertHTML')
        value = $('<div>').html(@triggerSpy.argsForCall[0][1]['value']).html()
        expect(value).toContain('100px')
        expect(value).toContain('42px')
        expect(value).toContain('src="https://www.youtube.com/embed/foo?wmode=transparent"')

    describe "a vimeo video", ->

      beforeEach ->
        $('#media_vimeo_width').val(100)
        $('#media_vimeo_height').val('42')
        $('input[value=vimeo_url]').prop('checked', true)

      it "triggers an action with the proper values", ->
        $('#media_vimeo_url').val('http://vimeo.com/foo')
        jasmine.simulate.click($('input[type=submit]').get(0))
        expect(@triggerSpy.callCount).toEqual(1)
        expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
        expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertHTML')
        value = $('<div>').html(@triggerSpy.argsForCall[0][1]['value']).html()
        expect(value).toContain('100px')
        expect(value).toContain('42px')
        expect(value).toContain('http://player.vimeo.com/video/foo?title=1&amp;byline=1&amp;portrait=0&amp;color=ffffff')

      it "triggers an action with the proper values using https", ->
        $('#media_vimeo_url').val('https://vimeo.com/foo')
        jasmine.simulate.click($('input[type=submit]').get(0))
        expect(@triggerSpy.callCount).toEqual(1)
        expect(@triggerSpy.argsForCall[0][0]).toEqual('action')
        expect(@triggerSpy.argsForCall[0][1]['action']).toEqual('insertHTML')
        value = $('<div>').html(@triggerSpy.argsForCall[0][1]['value']).html()
        expect(value).toContain('100px')
        expect(value).toContain('42px')
        expect(value).toContain('https://player.vimeo.com/video/foo?title=1&amp;byline=1&amp;portrait=0&amp;color=ffffff')
