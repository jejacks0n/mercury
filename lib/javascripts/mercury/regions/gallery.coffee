###!
The Gallery region is really just an example of how you can build your own more complex regions.

By default it provides the ability to have a simplistic slide show, and allows dropping images from the desktop -- which
will get uploaded (and probably processed by your server) and will then insert the returned images as slides in the
slideshow.

You can use the control panel to see thumbnails of each slide, to jump to a given slide, or to remove them. This example
also takes into account undo/redo support using the keyboard or buttons.
###
class Mercury.Region.Gallery extends Mercury.Region
  @define 'Mercury.Region.Gallery', 'gallery'
  @include Mercury.Region.Modules.DropIndicator
  @include Mercury.Region.Modules.DropItem

  @supported: true

  @elements:
    controls: '.mercury-gallery-region-controls'
    slides: '.slides'
    paginator: '.paginator'

  @events:
    'click .mercury-gallery-region-controls li': 'gotoSlide'

  skipHistoryOn: ['undo', 'redo', 'next', 'prev', 'togglePlay']

  init: ->
    @speed ||= 3000
    @index = 0
    @playing ?= true
    @refresh(true)


  build: ->
    @append('<div class="slides">') unless @$('.slides').length
    @append('<div class="paginator">') unless @$('.paginator').length


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
    @$paginator.html(Array(@images.length + 1).join('<span>&bull;</span>'))
    @$paginator.find("span:nth-child(#{@index})").addClass('active')


  refreshControls: ->
    @$controls.remove()
    @append('<ul class="mercury-gallery-region-controls"></ul>')
    for slide in @images
      src = $(slide).find('img').attr('src')
      @$controls.append($("""<li><img src="#{src}"/></li>"""))
    @$controls.show() if @focused


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
    @$slides.append(slide)
    @refresh(true)
    @pushHistory()
    @trigger('focused')


  removeSlide: ->
    @$(".slide:nth-child(#{@index})").remove()
    @refresh(true)
    @pushHistory()


  onDropFile: (files) ->
    uploader = new Mercury[@config('interface:uploader')](files, mimeTypes: @config('regions:gallery:mimeTypes'))
    uploader.on 'uploaded', (file) =>
      @focus()
      @handleAction('file', file)


  onFocus: ->
    @$controls.show() unless @previewing


  onBlur: ->
    @$controls.hide()


  onUndo: ->
    super
    @refresh(true)


  onRedo: ->
    super
    @refresh(true)


  release: ->
    clearTimeout(@timeout)
    @html(@value())
    super


Mercury.Region.Gallery.addToolbar
  general:
    prev:       ['Previous Slide']
    next:       ['Next Slide']
    remove:     ['Delete Slide']
    togglePlay: ['Play/Pause']


Mercury.Region.Gallery.addAction

  prev:   -> @prevSlide()
  next:   -> @nextSlide()
  remove: -> @removeSlide()

  togglePlay: ->
    @playing = !@playing
    @refresh()

  file: (file) ->
    @handleAction('image', url: file.get('url')) if file.isImage()

  image: (image) ->
    @appendSlide("""<div class="slide"><img src="#{image.get('url')}"/></div>""")


Mercury.Region.Gallery.addContext

  togglePlay: -> @playing
