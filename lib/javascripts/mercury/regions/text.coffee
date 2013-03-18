###!
The Text region is a simple multiline textarea region. It's up to you to put <br> tags in as line breaks if you want
them when you render the content.
###
class Mercury.TextRegion extends Mercury.Region
  @define 'Mercury.TextRegion', 'text'
  @include Mercury.Region.Modules.FocusableTextarea

  @supported: true

  value: (value = null) ->
    if value == null || typeof(value) == 'undefined'
      return @focusable.val() unless @config('regions:text:stripTags')
      return @sanitizedValue()
    if @config('regions:text:stripTags')
      @focusable.val($('<div>').html((value.val ? value).replace(/<br\/?>/g, '\n').trim()).text())
    else
      @focusable.val(value.val ? value)
    @setSerializedSelection(value.sel) if value.sel


  sanitizedValue: ->
    div = $('<div>').html(@focusable.val().trim().replace(/\n/g, '<span>[!!!br!!!]</span>'))
    div.text().replace(/\[!!!br!!!\]/g, '<br>')
