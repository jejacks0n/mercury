Mercury.View.Modules.FormHandler =

  included: ->
    @on('build', @buildFormHandler)


  buildFormHandler: ->
    @delegateEvents('submit': @onFormSubmit)
    @on('update', @applySerializedModel) if @model


  validate: ->
    @clearInputErrors()


  displayInputErrors: ->
    @addInputError(@$("[name=#{attr}]"), message.join(', ')) for attr, message of @model.errors


  addInputError: (input, message) ->
    input.after("""<span class="help-inline error-message">#{message}</span>""").
      closest('.control-group').
      addClass('error')
    @valid = false


  clearInputErrors: ->
    @$('.control-group.error').removeClass('error').find('.error-message').remove()
    @valid = true


  applySerializedModel: ->
    $form = @$('form').find('input, select, textarea')
    check = (el, checked) -> el.prop('checked', checked)
    check($form.filter(':checked'), false)

    for item in Object.serialize(@model.toJSON())
      $el = $form.filter("[name='#{item.name}']")
      if $el.filter(':checkbox').length
        check($el.filter(':checkbox'), true) if `$el.val() == item.value`
      else if $el.filter(':radio').length
        check($el.filter("[value='#{item.value}']"), true)
      else
        $el.val(item.value)


  serializeModel: ->
    @clearInputErrors()
    @model.set(@serializeForm())
    if @model.isValid()
      @trigger('form:success')
      @hide() if @hideOnValidSubmit
    else
      @displayInputErrors()


  serializeForm: ->
    $form = @$('form')
    arr = $form.serializeArray()
    for item in $form.find('input[type="checkbox"]:not(:checked)')
      arr.push(name: $(item).attr('name'), value: false)
    Object.deserialize(arr)


  onFormSubmit: (e) ->
    @prevent(e)
    @validate()
    @serializeModel() if @model
    @onSubmit?() if @valid
