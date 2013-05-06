#= require mercury/core/view
#= require mercury/models/file
#= require mercury/templates/uploader

class Mercury.Uploader extends Mercury.View

  @supported: !!(window.FormData && new XMLHttpRequest().upload)

  @logPrefix: 'Mercury.Uploader:'
  @className: 'mercury-uploader'
  @template: 'uploader'

  @elements:
    status: '.mercury-uploader-progress span'
    details: '.mercury-uploader-details'
    preview: '.mercury-uploader-preview b'
    indicator: '.mercury-uploader-indicator div'
    percent: '.mercury-uploader-indicator b'

  constructor: (files, @options = {}) ->
    return @notify(@t('Is unsupported in this browser')) unless @constructor.supported
    super(@options)

    @loaded = 0
    @total = 0
    @files = []

    return unless @calculate(files || []).length

    @show()
    @delay(500, @upload)


  calculate: (files) ->
    for file in files
      file = new Mercury.Model.File(file, mimeTypes: @mimeTypes)
      unless file.isValid()
        alert(@t('Error uploading %s: %s', file.get('name'), file.errorMessages()))
        continue
      @files.push(file)
      @total += file.get('size')
    @files


  build: ->
    @appendTo(Mercury.interface)


  show: ->
    @update(@t('Processing...'))
    @delay(50, => @css(opacity: 1))


  release: (ms = 0) ->
    @delay ms, ->
      @css(opacity: 0)
      @delay(250, -> super)


  upload: ->
    return @release(500) unless @files.length
    @file = @files.shift()
    @update(@t('Uploading...'))
    @loadDetails()
    if xhr = @file.save(uploadEvents: @uploadEvents())
      xhr.success => @success()
      xhr.error => @error()


  update: (message, loaded = 0) ->
    percent = Math.floor((@loaded + loaded) * 100 / @total) + '%'
    @$status.html(message) if message
    @$indicator.css(width: percent)
    @$percent.html(percent)


  loadDetails: ->
    @$details.html [
      @t('Name: %s', @file.get('name')),
      @t('Type: %s', @file.get('type')),
      @t('Size: %s', @file.readableSize())
    ].join('<br/>')

    return unless @file.isImage()
    @file.readAsDataURL (result) => @$preview.html($('<img>', src: result))


  success: ->
    @trigger('uploaded', @file)
    @loaded += @file.get('size')
    @update(@t('Successfully uploaded...'))
    @upload()


  error: ->
    @update(@t('Error: Unable to upload the file'))
    @delay(3000, @upload)


  uploadEvents: ->

    progress: (e) =>
      @update(@t('Uploading...'), e.loaded)
      @$percent.show()
