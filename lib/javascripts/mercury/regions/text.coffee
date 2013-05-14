###!
The Text region is a simple multiline textarea region. It's up to you to put <br> tags in as line breaks if you want
them when you render the content.
###
class Mercury.Region.Text extends Mercury.Region
  @define 'Mercury.Region.Text', 'text'
  @include Mercury.Region.Modules.FocusableTextarea
  @include Mercury.Region.Modules.TextSelection
  @include Mercury.Region.Modules.SelectionValue

  @supported: true
