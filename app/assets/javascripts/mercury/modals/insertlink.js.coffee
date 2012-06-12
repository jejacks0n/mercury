@Mercury.modalHandlers.insertLink = {

  initialize: ->
    # make the inputs work with the radio buttons
    @element.find('.control-label input').on('click', @onLabelChecked)
    @element.find('.controls .optional, .controls .required').on('focus', @onInputFocused)

    # show/hide the link target options on target change
    @element.find('#link_target').on('change', => @onChangeTarget())

    @initializeForm()

    # build the link on form submission
    @element.find('form').on 'submit', (event) =>
      event.preventDefault()
      @validateForm()
      return unless @valid
      @submitForm()
      @hide()


  initializeForm: ->
    @fillExistingBookmarks()

    # get the selection and initialize its information into the form
    return unless Mercury.region && Mercury.region.selection
    selection = Mercury.region.selection()

    # set the text content
    @element.find('#link_text').val(selection.textContent()) if selection.textContent

    # if we're editing a link prefill the information
    a = selection.commonAncestor(true).closest('a') if selection && selection.commonAncestor
    return false unless a && a.length
    @editing = a

    # don't allow changing the content on edit
    @element.find('#link_text_container').hide()

    # fill in the external url or bookmark select based on what it looks like
    if a.attr('href') && a.attr('href').indexOf('#') == 0
      bookmarkSelect = @element.find('#link_existing_bookmark')
      bookmarkSelect.val(a.attr('href').replace(/[^#]*#/, ''))
      bookmarkSelect.closest('.control-group').find('input[type=radio]').prop('checked', true)
    else
      @element.find('#link_external_url').val(a.attr('href'))

    # if it has a name, assume it's a bookmark target
    if a.attr('name')
      newBookmarkInput = @element.find('#link_new_bookmark')
      newBookmarkInput.val(a.attr('name'))
      newBookmarkInput.closest('.control-group').find('input[type=radio]').prop('checked', true)

    # if it has a target, select it, and try to pull options out
    if a.attr('target')
      @element.find('#link_target').val(a.attr('target'))

    # if it's a popup window
    if a.attr('href') && a.attr('href').indexOf('javascript:void') == 0
      href = a.attr('href')
      @element.find('#link_external_url').val(href.match(/window.open\('([^']+)',/)[1])
      @element.find('#link_target').val('popup')
      @element.find('#link_popup_width').val(href.match(/width=(\d+),/)[1])
      @element.find('#link_popup_height').val(href.match(/height=(\d+),/)[1])
      @element.find('#popup_options').show()


  fillExistingBookmarks: ->
    bookmarkSelect = @element.find('#link_existing_bookmark')
    for tag in jQuery('a[name]', window.mercuryInstance.document)
      bookmarkSelect.append(jQuery('<option>', {value: jQuery(tag).attr('name')}).text(jQuery(tag).text()))


  onLabelChecked: ->
    forInput = jQuery(@).closest('.control-label').attr('for')
    jQuery(@).closest('.control-group').find("##{forInput}").focus()


  onInputFocused: ->
    jQuery(@).closest('.control-group').find('input[type=radio]').prop('checked', true)


  onChangeTarget: ->
    @element.find(".link-target-options").hide()
    @element.find("##{@element.find('#link_target').val()}_options").show()
    @resize(true)


  addInputError: (input, message) ->
    input.after('<span class="help-inline error-message">' + Mercury.I18n(message) + '</span>').closest('.control-group').addClass('error')
    @valid = false


  clearInputErrors: ->
    @element.find('.control-group.error').removeClass('error').find('.error-message').remove()
    @valid = true


  validateForm: ->
    @clearInputErrors()

    type = @element.find('input[name=link_type]:checked').val()

    el = @element.find("#link_#{type}")
    @addInputError(el, "can't be blank") unless el.val()

    unless @editing
      el = @element.find('#link_text')
      @addInputError(el, "can't be blank") unless el.val()


  submitForm: ->
    content = @element.find('#link_text').val()
    target = @element.find('#link_target').val()
    type = @element.find('input[name=link_type]:checked').val()

    switch type
      when 'existing_bookmark' then attrs = {href: "##{@element.find('#link_existing_bookmark').val()}"}
      when 'new_bookmark' then attrs = {name: "#{@element.find('#link_new_bookmark').val()}"}
      else attrs = {href: @element.find("#link_#{type}").val()}

    switch target
      when 'popup'
        args = {
        width: parseInt(@element.find('#link_popup_width').val()) || 500,
        height: parseInt(@element.find('#link_popup_height').val()) || 500,
        menubar: 'no',
        toolbar: 'no'
        }
        attrs['href'] = "javascript:void(window.open('#{attrs['href']}', 'popup_window', '#{jQuery.param(args).replace(/&/g, ',')}'))"
      else
        attrs['target'] = target if target

    value = {tagName: 'a', attrs: attrs, content: content}

    if @editing
      Mercury.trigger('action', {action: 'replaceLink', value: value, node: @editing.get(0)})
    else
      Mercury.trigger('action', {action: 'insertLink', value: value})

}
