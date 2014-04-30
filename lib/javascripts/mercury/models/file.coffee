#= require mercury/core/extensions/number
#= require mercury/core/model

class Mercury.Model.File extends Mercury.Model

  @define 'Mercury.Model.File'

  @url: -> @config('uploading:saveUrl')

  constructor: (@file, @options = {}) ->
    super
      name : @file.name
      type : @file.type
      size : @file.size
      url  : @file.url || null


  validate: ->
    if @get('size') >= @config('uploading:maxSize')
      @addError('size', @t('Too large (max %s)', @config('uploading:maxSize').toBytes()))
      return
    mimeTypes = @options['mimeTypes'] ? @config('uploading:mimeTypes')
    if mimeTypes && mimeTypes.indexOf(@get('type')) <= -1
      @addError('type', @t('Unsupported format (%s)', @get('type')))


  readAsDataURL: (callback) ->
    return unless window.FileReader
    reader = new FileReader()
    reader.onload = -> callback(reader.result) if callback
    reader.readAsDataURL(@file)


  localSrc: (callback) ->
    url = (URL || webkitURL)
    if method = url && url.createObjectURL
      callback(method(@file))
    else
      @readAsDataURL(callback)


  previewSrc: (callback) ->
    @localSrc(callback)


  readableSize: ->
    @get('size').toBytes()


  isImage: ->
    ['image/jpeg', 'image/gif', 'image/png'].indexOf(@get('type')) > -1


  save: (options = {}) ->
    defaultOptions =
      data        : @toFormData()
      processData : false
      contentType : false
      dataType    : false
      xhr         : ->
        xhr = $.ajaxSettings.xhr()
        for event, handler of options.uploadEvents || {}
          do(event, handler) -> xhr.upload["on#{event}"] = handler
        xhr
    super($.extend(defaultOptions, options))


  toFormData: ->
    return unless window.FormData
    formData = new FormData()
    formData.append(@config('uploading:saveName'), @file, @get('name'))
    formData.append(k, v) for k, v of @options['params'] || {}
    formData


  saveSuccess: ->
    @notify(@t('Unable to process response: %s', 'no url')) unless @get('url')
