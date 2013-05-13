#= require spec_helper
#= require mercury/core/region
#= require mercury/regions/modules/snippet_droppable

describe "Mercury.Region.Modules.SnippetDroppable", ->

  Klass = null
  Module = Mercury.Region.Modules.SnippetDroppable
  subject = null

  beforeEach ->
    class Klass extends Mercury.Region
      @include Module
    subject = new Klass('<div id="foo">')
