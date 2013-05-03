Mercury.View.Modules.FormHandler =

  included: ->
    @on('build', @buildFormHandler)


  buildFormHandler: ->
    @delegateEvents('submit': @onFormSubmit)


  validate: ->
    @clearInputErrors()


  addInputError: (input, message) ->
    input.after("""<span class="help-inline error-message">#{message}</span>""").
      closest('.control-group').
      addClass('error')
    @valid = false


  clearInputErrors: ->
    @$('.control-group.error').removeClass('error').find('.error-message').remove()
    @valid = true


  onFormSubmit: (e) ->
    @prevent(e)
    @validate()
    @onSubmit?() if @valid
