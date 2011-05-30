class Mercury.Regions.Markupable extends Mercury.Region
  type = 'markupable'

  constructor: (@element, @window, @options = {}) ->
    @type = 'markupable'
    super
