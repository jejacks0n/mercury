class Mercury.GalleryRegion extends Mercury.Region

  @supported: true

  @define 'Mercury.GalleryRegion', 'gallery',
    undo: 'onUndo'
    redo: 'onRedo'

  className: 'mercury-gallery-region'

  focusable: true

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

    @pushStack(@el.html())


  refresh: (controls = false) ->
    @images = @$('.slide').hide()
    @index = 1 if @index > @images.length
    @$(".slide:nth-child(#{@index})").show()
    @paginator.html(Array(@images.length + 1).join('<span>&bull;</span>'))
    @paginator.find("span:nth-child(#{@index})").addClass('active')
    @refreshControls() if controls


  refreshControls: ->
    @controls.html('')
    @addLink($(slide)) for slide in @images
    @controls.show() if @focused


  nextSlide: ->
    @index += 1
    @refresh()
    @timeout = @delay(@speed, => @nextSlide())


  gotoSlide: (e) ->
    clearTimeout(@timeout)
    @index = $(e.target).closest('li').prevAll('li').length + 1
    @refresh()
    @timeout = @delay(@speed, => @nextSlide())


  appendSlide: (file) ->
    return unless file.isImage()
    slide = $("""<div class="slide"><img src="#{file.get('url')}"/></div>""")
    @slides.append(slide)
    @addLink(slide)
    @refresh()
    @pushStack(@el.html())
    @trigger('focus')
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
    @pushStack(@el.html())


  addLink: (slide) ->
    src = slide.find('img').attr('src')
    @controls.append($("""<li><img src="#{src}"/><em>&times;</em></li>""").data(slide: slide))


  onDropFile: (files) ->
    uploader = new Mercury.Uploader(files, mimeTypes: @config('regions:gallery:mimeTypes'))
    uploader.on('uploaded', => @appendSlide(arguments...))


  onFocus: ->
    @controls.show()


  onBlur: ->
    @controls.hide()


  onUndo: ->
    @html(html) if html = @undoStack()
    @refresh(true)



  onRedo: ->
    @html(html) if html = @redoStack()
    @refresh(true)


  onDragEnter: ->
    clearTimeout(@indicatorTimer)
    @indicator.css(top: @el.outerHeight() / 2, left: @el.outerWidth() / 2, display: 'block')
    @delay(1, => @indicator.css(opacity: 1))


  onDragLeave: ->
    @indicator.css(opacity: 0)
    @indicatorTimer = @delay(500, => @indicator.hide())
