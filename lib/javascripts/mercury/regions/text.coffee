###!
The Text region is a multiline plain text input. This region can be used to collect only text in cases when you don't
want to allow more complex HTML. It's up to you to render <br> tags when displaying the content within the page.

Configuration:
  regions:text:
    autoSize : true                                      # the region will auto-resize to the content within it
    wrapping : true                                      # enables/disables soft line wrapping
###
class Mercury.Region.Text extends Mercury.Region
  @define 'Mercury.Region.Text', 'text'
  @include Mercury.Region.Modules.FocusableTextarea
  @include Mercury.Region.Modules.TextSelection
  @include Mercury.Region.Modules.SelectionValue

  @supported: true

  originalContent: ->
    @html().replace('&gt;', '>').replace('&lt;', '<').trim().replace(/<br\s*\/?>/gi, '\n')
