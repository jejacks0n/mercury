Plugin = Mercury.registerPlugin 'media',
  description: 'Provides interface for inserting and editing media.'
  version: '1.0.0'

  actions:
    image: 'insertImage'
    html: 'insertHtml'

  events:
    'mercury:edit:media': 'onButtonClick'

  registerButton: ->
    @button.set(type: 'media')


  onButtonClick: ->
    @bindTo(new Plugin.Modal())


  bindTo: (view) ->
    view.on('form:submitted', (value) => @triggerAction(value))


  insertImage: (name, value) ->
    return @insertHtml(name, value) unless value.type == 'image'
    Mercury.trigger('action', name, value)


  insertHtml: (name, value) ->
    if value.type == 'image'
      value = """<img src="#{value.src}"/>"""
    else
      value = """<iframe src="#{value.src}" width="#{value.width}" height="#{value.height}" frameborder="0" allowFullScreen></iframe>"""
    Mercury.trigger('action', 'html', value)


class Plugin.Modal extends Mercury.Modal
  template:  'media'
  className: 'mercury-media-modal'
  title:     'Media Manager'
  width:     600
  events:
    'change .control-label input': 'onLabelChecked'
    'focus .controls [name]': 'onInputFocused'

  onLabelChecked: (e) ->
    $el = $(e.target)
    inputId = $el.closest('.control-label').attr('for')
    $el.closest('.control-group').find("##{inputId}").focus()


  onInputFocused: (e) ->
    $el = $(e.target)
    $el.closest('.control-group').find('input[type=radio]').prop('checked', true)
    return if $el.closest('.media-options').length

    @$('.media-options').hide()
    @$("##{$el.attr('id').replace('media_', '')}_options").show()
    @resize(true)


  validate: ->
    super
    type = @$('input[name=media_type]:checked').val()
    $el = @$("#media_#{type}")
    if $el.val()
      switch type
        when 'youtube_url' then @addInputError($el, @t('Is invalid')) unless /^https?:\/\/youtu.be\//.test($el.val())
        when 'vimeo_url' then @addInputError($el, @t('Is invalid')) unless /^https?:\/\/youtu.be\//.test($el.val())
    else
      @addInputError($el, @t("Can't be blank"))
    @resize(false)


  onSubmit: ->
    @validate()
    type = @$('input[name=media_type]:checked').val()
    $el = @$("#media_#{type}")
    url = $el.val()
    switch type
      when 'youtube_url'
        attrs =
          type: 'youtube'
          protocol: if /^https:/.test(url) then 'https' else 'http'
          width: parseInt(@$('#media_youtube_width').val(), 10) || 560
          height: parseInt(@$('#media_youtube_height').val(), 10) || 349
          share: url
          code: url.replace(/^https?:\/\/youtu.be\//, '')
        attrs.src = "#{attrs.protocol}://www.youtube-nocookie.com/embed/#{attrs.code}?rel=0&wmode=transparent"
      when 'vimeo_url'
        attrs =
          type: 'vimeo'
          protocol: if /^https:/.test(url) then 'https' else 'http'
          width: parseInt(@$('#media_vimeo_width').val(), 10) || 400
          height: parseInt(@$('#media_vimeo_height').val(), 10) || 225
          share: url
          code: url.replace(/^https?:\/\/vimeo.com\//, '')
        attrs.src = "#{attrs.protocol}://player.vimeo.com/video/#{attrs.code}?title=1&byline=1&portrait=0&color=ffffff"
      else # image
        attrs =
          type: 'image'
          protocol: if /^https:/.test(url) then 'https' else 'http'
          src: url
          url: url
          align: @$('#media_image_alignment').val()
          float: @$('#media_image_float').val()

    @trigger('form:submitted', attrs)
    @hide()


JST['/mercury/templates/media'] ||= ->
  """
  <form class="form-horizontal">

    <fieldset>
      <legend>Images</legend>
      <div class="control-group url optional">
        <label class="url optional control-label" for="media_image_url">
          <input name="media_type" type="radio" value="image_url" checked="checked" tabindex="-1"/>URL
        </label>
        <div class="controls">
          <input class="string url optional" id="media_image_url" name="media[image_url]" size="50" type="text" tabindex="1">
        </div>
      </div>
    </fieldset>

    <fieldset>
      <legend>Videos</legend>
      <div class="control-group url optional">
        <label class="url optional control-label" for="media_youtube_url">
          <input name="media_type" type="radio" value="youtube_url" tabindex="-1"/>YouTube URL
        </label>
        <div class="controls">
          <input class="string url optional" id="media_youtube_url" name="media[youtube_url]" size="50" type="text" placeholder="http://youtu.be/28tZ-S1LFok" tabindex="1">
        </div>
      </div>
      <div class="control-group url optional">
        <label class="url optional control-label" for="media_vimeo_url">
          <input name="media_type" type="radio" value="vimeo_url" tabindex="-1"/>Vimeo URL
        </label>
        <div class="controls">
          <input class="string url optional" id="media_vimeo_url" name="media[vimeo_url]" size="50" type="text" placeholder="http://vimeo.com/36684976" tabindex="1">
        </div>
      </div>
    </fieldset>

    <fieldset>
      <legend>Options</legend>

      <div class="media-options" id="image_url_options">
        <div class="control-group select optional">
          <label class="select optional control-label" for="media_image_alignment">Alignment</label>
          <div class="controls">
            <select class="select optional" id="media_image_alignment" name="media[image_alignment]" tabindex="1">
              <option value="">None</option>
              <option value="left">Left</option>
              <option value="right">Right</option>
              <option value="top">Top</option>
              <option value="middle">Middle</option>
              <option value="bottom">Bottom</option>
              <option value="absmiddle">Absolute Middle</option>
              <option value="absbottom">Absolute Bottom</option>
            </select>
          </div>
        </div>
        <div class="control-group select optional">
          <label class="select optional control-label" for="media_image_float">Float</label>
          <div class="controls">
            <select class="select optional" id="media_image_float" name="media[image_float]" tabindex="1">
              <option value="">None</option>
              <option value="left">Left</option>
              <option value="right">Right</option>
              <option value="inherit">Inherit</option>
            </select>
          </div>
        </div>
      </div>

      <div class="media-options" id="youtube_url_options" style="display:none">
        <div class="control-group number optional">
          <label class="number optional control-label" for="media_youtube_width">Width</label>
          <div class="controls">
            <input class="number optional" id="media_youtube_width" name="media[youtube_width]" size="50" type="number" value="560" tabindex="1">
          </div>
        </div>
        <div class="control-group number optional">
          <label class="number optional control-label" for="media_youtube_height">Height</label>
          <div class="controls">
            <input class="number optional" id="media_youtube_height" name="media[youtube_height]" size="50" type="number" value="349" tabindex="1">
          </div>
        </div>
      </div>

      <div class="media-options" id="vimeo_url_options" style="display:none">
        <div class="control-group number optional">
          <label class="number optional control-label" for="media_vimeo_width">Width</label>
          <div class="controls">
            <input class="number optional" id="media_vimeo_width" name="media[vimeo_width]" size="50" type="number" value="400" tabindex="1">
          </div>
        </div>
        <div class="control-group number optional">
          <label class="number optional control-label" for="media_vimeo_height">Height</label>
          <div class="controls">
            <input class="number optional" id="media_vimeo_height" name="media[vimeo_height]" size="50" type="number" value="225" tabindex="1">
          </div>
        </div>
      </div>
    </fieldset>

    <div class="form-actions">
      <input class="btn btn-primary" name="commit" type="submit" value="Insert Media" tabindex="2"/>
    </div>
  </form>
  """
