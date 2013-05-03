#= require mercury/core/model

class Mercury.Model.Page extends Mercury.Model

  @define 'Mercury.Model.Page'

  save: (options = {}) ->
    super($.extend(@config('saving'), options))
