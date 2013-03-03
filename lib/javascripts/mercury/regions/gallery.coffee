class Mercury.GalleryRegion extends Mercury.Region

  @supported: true

  @define 'Mercury.GalleryRegion', 'gallery'

  className: 'mercury-gallery-region'

  skipHistoryOn: ['undo', 'redo']

  elements:
    controls: '.mercury-gallery-region-controls'
    indicator: '.mercury-gallery-region-indicator'
    slides: '.slides'
    paginator: '.paginator'

  events:
    'click .mercury-gallery-region-controls em': 'removeSlide'
    'click .mercury-gallery-region-controls img': 'gotoSlide'
    'dragenter': 'onDragEnter'
    'dragleave': 'onDragLeave'
    'drop': 'onDragLeave'

  build: ->
    @speed ||= 3000
    @index = 1
    @append('<ul class="mercury-gallery-region-controls"></ul><div class="mercury-gallery-region-indicator"></div>')

    @refresh(true)
    @delay(@speed, => @nextSlide())


  refresh: (controls = false) ->
    @images = @$('.slide').hide()
    @index = 1 if @index > @images.length
    @$(".slide:nth-child(#{@index})").show()
    @paginator.html(Array(@images.length + 1).join('<span>&bull;</span>'))
    @paginator.find("span:nth-child(#{@index})").addClass('active')
    @refreshControls() if controls


  refreshControls: ->
    @controls.html('')
    @addControlLink($(slide)) for slide in @images
    @controls.show() if @focused


  addControlLink: (slide) ->
    src = slide.find('img').attr('src')
    @controls.append($("""<li><img src="#{src}"/><em>&times;</em></li>""").data(slide: slide))


  nextSlide: ->
    @index += 1
    @refresh()
    @timeout = @delay(@speed, => @nextSlide())


  gotoSlide: (e) ->
    clearTimeout(@timeout)
    @index = $(e.target).closest('li').prevAll('li').length + 1
    @refresh()
    @timeout = @delay(@speed, => @nextSlide())


  appendSlide: (slide) ->
    @slides.append(slide)
    @addControlLink(slide)
    @refresh()
    @pushHistory()
    @trigger('focused')
    @focus()


  removeSlide: (e) ->
    el = $(e.target).closest('li')
    slide = el.data('slide')
    index = slide.prevAll('.slide').length + 1

    slide.remove()
    el.remove()

    if index < @index
      @index -= 1
    else if index == @index
      clearTimeout(@timeout)
      @timeout = @delay(@speed, => @nextSlide())

    @refresh()
    @pushHistory()


  onDropFile: (files) ->
    uploader = new Mercury.Uploader(files, mimeTypes: @config('regions:gallery:mimeTypes'))
    uploader.on('uploaded', => @onUploadFile(arguments...))


  onUploadFile: (file) ->
    return unless file.isImage()
    @appendSlide($("""<div class="slide"><img src="#{file.get('url')}"/></div>"""))


  onFocus: ->
    @controls.show()


  onBlur: ->
    @controls.hide()


  onUndo: ->
    super
    @refresh(true)


  onRedo: ->
    super
    @refresh(true)


  onDragEnter: ->
    clearTimeout(@indicatorTimer)
    @indicator.css(top: @el.outerHeight() / 2, left: @el.outerWidth() / 2, display: 'block')
    @delay(1, => @indicator.css(opacity: 1))


  onDragLeave: ->
    @indicator.css(opacity: 0)
    @indicatorTimer = @delay(500, => @indicator.hide())
