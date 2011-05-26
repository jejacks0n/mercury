Mercury.uploader = (file, options) ->
  Mercury.uploader.show(file, options)
  return Mercury.uploader

$.extend Mercury.uploader, {

  show: (file, @options = {}) ->
    @file = new Mercury.uploader.File(file)
    if @file.errors
      alert("Error: #{@file.errors}")
      return
    return unless @supported()

    Mercury.trigger('focus:window')
    @initialize()
    @appear()


  initialize: ->
    return if @initialized
    @build()
    @bindEvents()
    @initialized = true


  supported: ->
    xhr = new XMLHttpRequest
    fileReader = window.FileReader

    if window.Uint8Array && window.ArrayBuffer && !XMLHttpRequest.prototype.sendAsBinary
      XMLHttpRequest::sendAsBinary = (datastr) ->
        ui8a = new Uint8Array(datastr.length)
        ui8a[index] = (datastr.charCodeAt(index) & 0xff) for data, index in datastr
        @send(ui8a.buffer)

    return xhr.upload && xhr.sendAsBinary && fileReader


  build: ->
    @element = $('<div>', {class: 'mercury-uploader'})
    @element.append('<div class="mercury-uploader-preview"><b><img/></b></div>')
    @element.append('<div class="mercury-uploader-details"></div>')
    @element.append('<div class="mercury-uploader-progress"><span>Processing...</span><div class="mercury-uploader-indicator"><div><b>0%</b></div></div></div>')

    @overlay = $('<div>', {class: 'mercury-uploader-overlay'})

    @element.appendTo($(@options.appendTo).get(0) ? 'body')
    @overlay.appendTo($(@options.appendTo).get(0) ? 'body')


  bindEvents: ->
    Mercury.bind 'resize', => @position()


  appear: ->
    @fillDisplay()
    @position()

    @overlay.show()
    @overlay.animate {opacity: 1}, 200, 'easeInOutSine', =>
      @element.show()
      @element.animate {opacity: 1}, 200, 'easeInOutSine', =>
        @visible = true
        @loadImage()


  position: ->
    viewportWidth = $(window).width()
    viewportHeight = $(window).height()

    width = @element.outerWidth()
    height = @element.outerHeight()

    @element.css {
      top: (viewportHeight - height) / 2
      left: (viewportWidth - width) / 2
    }


  fillDisplay: ->
    details = ["Name: #{@file.name}", "Size: #{@file.readableSize}", "Type: #{@file.type}"]
    details.push("<span>Unable to upload file because the file is either too large, or isn't a supported format.</span>") if @file.errors
    @element.find('.mercury-uploader-details').html(details.join('<br/>'))


  loadImage: ->
    @file.readAsDataURL (result) =>
      @element.find('.mercury-uploader-preview b').html($('<img>', {src: result}))
      @upload() unless @file.errors


  upload: ->
    xhr = new XMLHttpRequest
    $.each ['onloadstart', 'onprogress', 'onload', 'onabort', 'onerror'], (index, eventName) =>
      xhr.upload[eventName] = (event) => @uploaderEvents[eventName].call(@, event)
    xhr.onload = (event) =>
      try
        response = $.evalJSON(event.target.responseText)
        Mercury.trigger('action', {action: 'insertHTML', value: "<img src=\"#{response.url}\"/>"})
      catch error
        @updateStatus('Unable to process response')

    xhr.open('post', Mercury.config.uploading.url, true)
    xhr.setRequestHeader('Accept', 'application/json, text/javascript, text/html, application/xml, text/xml, */*')
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest')
    #xhr.setRequestHeader('X-CSRF-Token', this.token)

    @file.readAsBinaryString (result) =>
      # build the multipart post string
      multipart = new Mercury.uploader.MultiPartPost(Mercury.config.uploading.inputName, @file, result)

      # update the content size so we can calculate
      @file.updateSize(multipart.delta)
      @total = @file.size
      @loaded = 0

      # set the content type and send
      xhr.setRequestHeader('Content-Type', 'multipart/form-data; boundary=' + multipart.boundary)
      xhr.sendAsBinary(multipart.body)


  updateStatus: (message, loaded) ->
    @element.find('.mercury-uploader-progress span').html(message)
    if loaded
      percent = Math.floor((@loaded + loaded) * 100 / @total) + '%'
      @element.find('.mercury-uploader-indicator div').css({width: percent})
      @element.find('.mercury-uploader-indicator b').html(percent).show()


  hide: (delay = 0) ->
    setTimeout((=>
      @element.animate {opacity: 0}, 200, 'easeInOutSine', =>
        @overlay.animate {opacity: 0}, 200, 'easeInOutSine', =>
          @overlay.hide()
          @element.hide()
          @element.find('.mercury-uploader-preview b').html('')
          @loaded = 0
          @total = 0
          @element.find('.mercury-uploader-indicator div').css({width: 0})
          @element.find('.mercury-uploader-indicator b').html('0%').hide()
          @updateStatus('Processing...',)

          @visible = false
    ), delay * 1000)


  uploaderEvents: {
    onloadstart: -> @updateStatus('Uploading...')

    onprogress: (event) -> @updateStatus('Uploading...', event.loaded, event.total)

    onabort: -> @updateStatus('Aborted')

    onload: ->
      @updateStatus('Successfully uploaded', @file.size)
      @hide(1)

    onerror: (event) ->
      @updateStatus('Error: Unable to upload file')
      @hide(1)
  }
}



class Mercury.uploader.File

  constructor: (@file) ->
    @size = @file.size
    @fullSize = @file.size
    @readableSize = @file.size.toBytes()
    @name = @file.fileName
    @type = @file.type

    # add any errors if we need to
    errors = []
    errors.push('Too large') if @size >= Mercury.config.uploading.maxFileSize
    errors.push('Unsupported format') unless Mercury.config.uploading.allowedMimeTypes.indexOf(@type) > -1
    @errors = errors.join(' / ') if errors.length


  readAsDataURL: (callback = null) ->
    reader = new FileReader()
    reader.readAsDataURL(@file)
    reader.onload = => callback(reader.result)


  readAsBinaryString: (callback = null) ->
    reader = new FileReader()
    reader.readAsBinaryString(@file)
    reader.onload = => callback(reader.result)


  updateSize: (delta) ->
    @fullSize = @size + delta



class Mercury.uploader.MultiPartPost

  constructor: (@inputName, @file, @contents) ->
    @boundary = 'Boundaryx20072377098235644401115438165x'
    @body = ''
    @buildBody()
    @delta = @body.length - @file.size


  buildBody: ->
    boundary = '--' + @boundary
    crlf = '\r\n'
    #for name, value of @formInputs
    #  @body += boundary + crlf + 'Content-Disposition: form-data; name="' + name + '"' + crlf + crlf + unescape(encodeURIComponent(value)) + crlf

    @body += boundary + crlf + 'Content-Disposition: form-data; name="' + @inputName + '"; filename="' + @file.name + '"' + crlf + 'Content-Type: ' + @file.type + crlf + 'Content-Transfer-Encoding: binary' + crlf + crlf + @contents + crlf
    @body += boundary + '--'
