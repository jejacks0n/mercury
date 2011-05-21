Mercury.modalHandlers =

  htmleditor: ->
    # fill the text area with the content
    @element.find('textarea').val(Mercury.region.html())

    # replace the contents on form submit
    @element.find('form').submit (event) =>
      event.preventDefault()
      value = @element.find('textarea').val().replace(/\n/g, '')
      Mercury.trigger('action', {action: 'replaceHTML', value: value})
      @hide()


  insertlink: ->
    # make the inputs work with the radio buttons
    @element.find('.selectable').focus ->
      $(@).prev('label').find('input[type=radio]').prop("checked", true)

    # show/hide the link target options on target change
    @element.find('#link_target').change =>
      @element.find(".link-target-options").hide()
      @element.find("##{@element.find('#link_target').val()}_options").show()
      @resize(true)

    # fill the existing bookmark select
    bookmarkSelect = @element.find('#existing_bookmark')
    for link in $('a[name]', Mercury.editor.document)
      bookmarkSelect.append($('<option>', {value: $(link).attr('name')}).text($(link).text()))

    # get the selection and initialize its information into the form
    if Mercury.region && Mercury.region.selection
      selection = Mercury.region.selection()

      # if we're editing a link prefill the information
      container = selection.commonAncestor(true)
      if container.is('a')
        existingLink = container

        # don't allow changing the content on edit
        @element.find('#link_text_container').hide()

        # fill in the external url or bookmark select based on what it looks like
        if container.attr('href') && container.attr('href').indexOf('#') == 0
          bookmarkSelect.val(container.attr('href').replace(/[^#]*#/, ''))
          bookmarkSelect.prev('label').find('input[type=radio]').prop("checked", true)
        else
          @element.find('#external_url').val(container.attr('href'))

        # if it has a name, assume it's a bookmark target
        if container.attr('name')
          newBookmarkInput = @element.find('#new_bookmark')
          newBookmarkInput.val(container.attr('name'))
          newBookmarkInput.prev('label').find('input[type=radio]').prop("checked", true)

        # if it has a target, select it, and try to pull options out
        if container.attr('target')
          @element.find('#link_target').val(container.attr('target'))
          if container.attr('target').indexOf('javascript:void') == 0
            @element.find('#link_target').val('popup')

      # get the text content
      @element.find('#link_text').val(selection.textContent())

    # build the link on form submission
    @element.find('form').submit (event) =>
      event.preventDefault()

      content = @element.find('#link_text').val()
      target = @element.find('#link_target').val()
      type = @element.find('input[name=link_type]:checked').val()

      switch type
        when 'existing_bookmark' then attrs = {href: "##{@element.find('#existing_bookmark').val()}"}
        when 'new_bookmark' then attrs = {name: "##{@element.find('#new_bookmark').val()}"}
        else attrs = {href: @element.find("##{type}").val()}

      switch target
        when 'popup'
          args = {
            width: parseInt(@element.find('#popup_width').val()) || 500,
            height: parseInt(@element.find('#popup_height').val()) || 500,
            menubar: 'no',
            toolbar: 'no'
          }
          attrs['href'] = "javascript:void(window.open('#{attrs['href']}', 'popup_window', '#{$.param(args).replace(/&/g, ',')}'))"
        else attrs['target'] = target if target

      attrs = for name, value of attrs
        "#{name}=\"#{value}\""
      value = "<a #{attrs.join(' ')}>"

      if existingLink
        Mercury.trigger('action', {action: 'replaceLink', value: value, node: existingLink.get(0)})
      else
        Mercury.trigger('action', {action: 'insertLink', value: "#{value}#{content}</a>"})
      Mercury.modal.hide()


  insertmedia: ->
    # make the inputs work with the radio buttons, and options
    @element.find('.selectable').focus (event) =>
      element = $(event.target)
      element.prev('label').find('input[type=radio]').prop("checked", true)

      @element.find(".media-options").hide()
      @element.find("##{element.attr('id')}_options").show()
      @resize(true)

    # build the image or youtube embed on form submission
    @element.find('form').submit (event) =>
      event.preventDefault()

      type = @element.find('input[name=media_type]:checked').val()

      switch type
        when 'image_url'
          attrs = {src: @element.find('#image_url').val()}
          attrs['align'] = @element.find('#image_alignment').val() if @element.find('#image_alignment').val()
          value = $('<img>', attrs)
        when 'youtube_url'
          code = @element.find('#youtube_url').val().replace('http://youtu.be/', '')
          attrs = {
            width: 560,
            height: 349,
            src: "http://www.youtube.com/embed/#{code}?wmode=transparent",
            frameborder: 0,
            allowfullscreen: 'true'
          }
          value = $('<iframe>', attrs)

      Mercury.trigger('action', {action: 'insertHTML', value: value})
      Mercury.modal.hide()


  insertcharacter: ->
    @element.find('.character').click ->
      Mercury.trigger('action', {action: 'insertHTML', value: "&#{$(@).attr('data-entity')};"})
      Mercury.modal.hide()
