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

  @events:
    'click .mercury-uploader-close': 'cancel'

  constructor: (files, @options = {}) ->
    return @notify(@t('Is unsupported in this browser')) unless @constructor.supported
    super(@options)

    @loaded = 0
    @total = 0
    @calculate files || [], (@files) =>
      if @files.length
        @show()
        @delay(500, @upload)
      else
        @release()


  calculate: (files, callback) ->
    allowedFiles = []
    steps = []

    for file in files
      file = new Mercury.Model.File(file, @options)
      steps.push(deferred = new $.Deferred())
      deferred
        .fail =>
          errors = file.errorMessages() || ''
          alert(@t('Error uploading %s: %s', file.get('name'), errors))
        .done =>
          allowedFiles.push(file)
          @total += file.get('size')
      file.isUploadable(deferred)

    $.when(steps...).always -> callback(allowedFiles)


  build: ->
    @appendTo(Mercury.interface)


  show: ->
    @update(@t('Processing...'))
    @delay(50, => @css(opacity: 1))


  cancel: ->
    @release()
    try @xhr.abort()


  release: (ms = 0) ->
    @delay ms, ->
      @css(opacity: 0)
      @delay(250, -> super)


  upload: ->
    return @release(500) unless @files.length
    @file = @files.shift()
    @update(@t('Uploading...'))
    @loadDetails()
    if @xhr = @file.save(uploadEvents: @uploadEvents())
      @xhr.success => @success()
      @xhr.error => @error()


  update: (message, loaded = 0) ->
    percent = Math.floor((@loaded + loaded) * 100 / @total)
    percent = 100 if percent > 100
    @$status.html(message) if message
    @$indicator.css(width: "#{percent}%")
    @$percent.html("#{percent}%")


  loadDetails: ->
    @$details.html [
      @t('Name: %s', @file.get('name')),
      @t('Type: %s', @file.get('type')),
      @t('Size: %s', @file.readableSize())
    ].join('<br/>')

    @file.previewSrc (result) => @displayPreview(result)


  displayPreview: (src) ->
    @$preview.html($('<img>', src: src))


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
