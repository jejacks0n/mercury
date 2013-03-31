###!
The Gallery region is really just an example of how you can build your own more complex regions.

By default it provides the ability to have a simplistic slide show, and allows dropping images from the desktop -- which
will get uploaded (and probably processed by your server) and will then insert the returned images as slides in the
slideshow.

You can use the control panel to see thumbnails of each slide, to jump to a given slide, or to remove them. This example
also takes into account undo/redo support using the keyboard or buttons.
###
Mercury.configure 'toolbars:gallery',
  general:
    prev:       ['Previous Slide']
    next:       ['Next Slide']
    remove:     ['Delete Slide']
    togglePlay: ['Play/Pause']

class Mercury.Region.Gallery extends Mercury.Region
  @define 'Mercury.Region.Gallery', 'gallery'
  @include Mercury.Region.Modules.DropIndicator

  @supported: true

  skipHistoryOn: ['undo', 'redo', 'next', 'prev', 'togglePlay']

  elements:
    controls: '.mercury-gallery-region-controls'
    slides: '.slides'
    paginator: '.paginator'

  events:
    'click .mercury-gallery-region-controls li': 'gotoSlide'

  constructor: ->
    super
    @speed ||= 3000
    @index = 0
    @playing ?= true
    @refresh(true)


  value: (value) ->
    if value == null || typeof(value) == 'undefined'
      el = $('<div>').html(@html())
      el.find('.mercury-gallery-region-controls').remove()
      el.find('.slide').show()
      el.find('.paginator').empty()
      return el.html()
    super


  refresh: (controls = false) ->
    clearTimeout(@timeout)
    @images = @$('.slide').hide()
    @index = 1 if @index > @images.length
    @index = @images.length if @index < 1
    @$(".slide:nth-child(#{@index})").show()
    @refreshPaginator()
    @refreshControls() if controls
    @timeout = @delay(@speed, => @nextSlide()) if @playing


  refreshPaginator: ->
    @paginator.html(Array(@images.length + 1).join('<span>&bull;</span>'))
    @paginator.find("span:nth-child(#{@index})").addClass('active')


  refreshControls: ->
    @controls.remove()
    @append('<ul class="mercury-gallery-region-controls"></ul>')
    for slide in @images
      src = $(slide).find('img').attr('src')
      @controls.append($("""<li><img src="#{src}"/></li>"""))
    @controls.show() if @focused


  prevSlide: ->
    @index -= 1
    @refresh()


  nextSlide: ->
    @index += 1
    @refresh()


  gotoSlide: (e) ->
    @index = $(e.target).closest('li').prevAll('li').length + 1
    @refresh()


  appendSlide: (slide) ->
    @slides.append(slide)
    @refresh(true)
    @pushHistory()
    @trigger('focused')


  removeSlide: ->
    @$(".slide:nth-child(#{@index})").remove()
    @refresh(true)
    @pushHistory()


  onDropFile: (files) ->
    uploader = new Mercury.Uploader(files, mimeTypes: @config('regions:gallery:mimeTypes'))
    uploader.on 'uploaded', (file) =>
      return unless file.isImage()
      @focus()
      @appendSlide($("""<div class="slide"><img src="#{file.get('url')}"/></div>"""))


  onDropItem: (e, data) ->
    if url = $('<div>').html(data.getData('text/html')).find('img').attr('src')
      e.preventDefault()
      @focus()
      @appendSlide($("""<div class="slide"><img src="#{url}"/></div>"""))


  onFocus: ->
    @controls.show() unless @previewing


  onBlur: ->
    @controls.hide()


  onUndo: ->
    super
    @refresh(true)


  onRedo: ->
    super
    @refresh(true)


Mercury.Region.Gallery.addAction

  prev:       -> @prevSlide()
  next:       -> @nextSlide()
  remove:     -> @removeSlide()
  togglePlay: -> @playing = !@playing; @refresh()

  # todo: needs to be implemented
  # file: (file) ->


Mercury.Region.Gallery.addContext

  togglePlay: -> @playing
