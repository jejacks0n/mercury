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
    delete:     ['Delete Slide']
    togglePlay: ['Play/Pause']

class Mercury.Region.Gallery extends Mercury.Region
  @define 'Mercury.Region.Gallery', 'gallery'
  @include Mercury.Region.Modules.DropIndicator

  @supported: true

  toolbars: ['gallery']
  skipHistoryOn: ['undo', 'redo']

  elements:
    controls: '.mercury-gallery-region-controls'
    slides: '.slides'
    paginator: '.paginator'

  events:
    'click .mercury-gallery-region-controls em': 'removeSlide'
    'click .mercury-gallery-region-controls img': 'gotoSlide'

  build: ->
    @speed ||= 3000
    @index = 1
    @append('<ul class="mercury-gallery-region-controls"></ul>')

    @refresh(true)
    @delay(@speed, => @nextSlide())


  value: (value) ->
    if value == null || typeof(value) == 'undefined'
      el = $('<div>').html(@html())
      el.find('.mercury-gallery-region-controls').remove()
      return el.html()
    super


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
