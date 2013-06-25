Plugin = Mercury.registerPlugin 'link'
  description: 'Provides interface for inserting and editing links.'
  version: '1.0.0'

  actions:
    link: 'insert'

  events:
    'mercury:edit:link': 'onButtonClick'

  registerButton: ->
    @button.set(type: 'link')


  onButtonClick: ->
    @bindTo(new Plugin.Modal())


  bindTo: (view) ->
    view.on('form:submitted', (value) => @triggerAction(value))


  insert: (name, value) ->
    Mercury.trigger('action', 'link', value)


class Plugin.Modal extends Mercury.Modal
  template:  'link'
  className: 'mercury-link-modal'
  title:     'Link Manager'
  width:     600
  elements:
    text: '#link_text'
    target: '#link_target'
  events:
    'change .control-label input': 'onLabelChecked'
    'focus .controls [name]': 'onInputFocused'
    'change #link_target': 'onChangeTarget'

  onLabelChecked: (e) ->
    $el = $(e.target)
    inputId = $el.closest('.control-label').attr('for')
    $el.closest('.control-group').find("##{inputId}").focus()


  onInputFocused: (e) ->
    $el = $(e.target)
    $el.closest('.control-group').find('input[type=radio]').prop('checked', true)


  onChangeTarget: (e) ->
    $el = $(e.target)
    @$('.link-target-options').hide()
    @$("##{$el.val()}_options").show()
    @resize(false)


  validate: ->
    super
    $el = @$("#link_#{@$('input[name=link_type]:checked').val()}")
    @addInputError($el, @t("can't be blank")) unless $el.val()
    @addInputError(@$text, @t("can't be blank")) if @$text.is(':visible') && !@$text.val().trim()
    @resize(false)


  onSubmit: ->
    @validate()
    content = @$text.val()
    target = @$target.val()
    type = @$('input[name=link_type]:checked').val()
    switch type
      when 'existing_bookmark' then attrs = url: "##{@$('#link_existing_bookmark').val()}"
      when 'new_bookmark' then attrs = name: "#{@$('#link_new_bookmark').val()}"
      else attrs = url: @$("#link_#{type}").val()
    switch target
      when 'popup'
        args =
          width: parseInt(@$('#link_popup_width').val(), 10) || 500
          height: parseInt(@$('#link_popup_height').val(), 10) || 500
          menubar: 'no'
          toolbar: 'no'
        attrs['url'] = "javascript:void(window.open('#{attrs['url']}','popup_window','#{Object.toParams(args).replace(/&/g, ',')}'))"
      else
        attrs['target'] = target if target
    attrs['text'] = @content || content

    @trigger('form:submitted', attrs)
    @hide()


JST['/mercury/templates/link'] ||= ->
  """
  <form class="form-horizontal">

    <fieldset class="link_text_container">
      <div class="control-group string required">
        <label class="string required control-label" for="link_text">Link Content</label>
        <div class="controls">
          <input class="string required" id="link_text" name="link[text]" size="50" type="text" tabindex="1">
        </div>
      </div>
    </fieldset>

    <fieldset>
      <legend>Standard Links</legend>
      <div class="control-group url optional">
        <label class="url optional control-label" for="link_external_url">
          <input name="link_type" type="radio" value="external_url" checked="checked" tabindex="-1"/>URL
        </label>
        <div class="controls">
          <input class="string url optional" id="link_external_url" name="link[external_url]" size="50" type="text" tabindex="1">
        </div>
      </div>
    </fieldset>

    <fieldset>
      <legend>Index / Bookmark Links</legend>
      <div class="control-group select optional">
        <label class="select optional control-label" for="link_existing_bookmark">
          <input name="link_type" type="radio" value="existing_bookmark" tabindex="-1"/>Existing Links
        </label>
        <div class="controls">
          <select class="select optional" id="link_existing_bookmark" name="link[existing_bookmark]" tabindex="1"></select>
        </div>
      </div>
      <div class="control-group string optional">
        <label class="string optional control-label" for="link_new_bookmark">
          <input name="link_type" type="radio" value="new_bookmark" tabindex="-1"/>Bookmark
        </label>
        <div class="controls">
          <input class="string optional" id="link_new_bookmark" name="link[new_bookmark]" type="text" tabindex="1">
        </div>
      </div>
    </fieldset>

    <fieldset>
      <legend>Options</legend>
      <div class="control-group select optional">
        <label class="select optional control-label" for="link_target">Link Target</label>
        <div class="controls">
          <select class="select optional" id="link_target" name="link[target]" tabindex="1">
            <option value="">Self (the same window or tab)</option>
            <option value="_blank">Blank (a new window or tab)</option>
            <option value="_top">Top (removes any frames)</option>
            <option value="popup">Popup Window (javascript new window popup)</option>
          </select>
        </div>
      </div>
      <div id="popup_options" class="link-target-options" style="display:none">
        <div class="control-group number optional">
          <label class="number optional control-label" for="link_popup_width">Popup Width</label>
          <div class="controls">
            <input class="number optional" id="link_popup_width" name="link[popup_width]" type="number" value="960" tabindex="1">
          </div>
        </div>
        <div class="control-group number optional">
          <label class="number optional control-label" for="link_popup_height">Popup Height</label>
          <div class="controls">
            <input class="number optional" id="link_popup_height" name="link[popup_height]" type="number" value="800" tabindex="1">
          </div>
        </div>
      </div>
    </fieldset>

    <div class="form-actions">
      <input class="btn btn-primary" name="commit" type="submit" value="Insert Link" tabindex="2">
    </div>
  </form>
  """
