#= require mercury/extensions/number
#= require mercury/core/model

class Mercury.File extends Mercury.Model

  @define 'Mercury.File'

  @url: -> @config('uploading:saveUrl')

  constructor: (@file) ->
    super
      name : @file.name
      type : @file.type
      size : @file.size
      url  : null


  validate: ->
    if @get('size') >= @config('uploading:maxSize')
      @addError('size', @t('Too large'))
      return
    mimeTypes = @config('uploading:mimeTypes')
    if mimeTypes && mimeTypes.indexOf(@get('type')) <= -1
      @addError('type', @t('Unsupported format (%s)', @get('type')))


  readAsDataURL: (callback) ->
    # todo: this could generate a nice placeholder image when we can't read the file
    return unless window.FileReader
    reader = new FileReader()
    reader.onload = -> callback(reader.result) if callback
    reader.readAsDataURL(@file)


  readableSize: ->
    @get('size').toBytes()


  isImage: ->
    ['image/jpeg', 'image/gif', 'image/png'].indexOf(@get('type')) > -1


  save: (options = {}) ->
    defaultOptions =
      data        : @toFormData()
      processData : false
      contentType : false
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
    formData


  saveSuccess: ->
    @notify(@t('Malformed response from server (%s)', 'no url')) unless @get('url')
