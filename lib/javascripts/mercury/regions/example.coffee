#= require mercury/core/region

class Mercury.ExampleRegion extends Mercury.Region

  @define 'Mercury.ExampleRegion', 'example',
    uploadFile: 'insertFile'

  constructor: (@el, @options) ->
    super
    @html('')


  togglePreview: ->
    @previewing = !@previewing


  dropFile: (files) ->
    new Mercury.Uploader(files)


  insertFile: (file) ->
    @append($('<img>', src: file.get('url')))
