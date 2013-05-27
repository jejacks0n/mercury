Plugin = Mercury.registerPlugin 'table'
  description: 'Provides interface for inserting and editing tables.'
  version: '1.0.0'

  actions:
    html: 'insert'

  events:
    'mercury:edit:table': 'onButtonClick'

  registerButton: ->
    @button.set(type: 'table')


  onButtonClick: ->
    @bindTo(new Plugin.Modal())


  bindTo: (view) ->
    view.on('form:submitted', (value) => @triggerAction(value))


  insert: (name, value) ->
    Mercury.trigger('action', name, value)



class Plugin.Modal extends Mercury.Modal
  template:  'table'
  className: 'mercury-table-modal'
  title:     'Table Manager'
  width:     600
  elements:
    table: 'table'
  events:
    'click table': 'onCellClick'
    'click [data-action]': 'onActionClick'

  update: ->
    super
    @editor = new Mercury.TableEditor(@$table, '&nbsp;')


  onCellClick: (e) ->
    @editor.setCell($(e.target))


  onActionClick: (e) ->
    @prevent(e)
    @editor[$(e.target).closest('[data-action]').data('action')]()


  onSubmit: ->
    @trigger('form:submitted', @editor.asHtml('<br/>'))
    @hide()


JST['/mercury/templates/table'] ||= ->
  """
  <form class="form-horizontal">

    <fieldset class="table-control">
      <table>
        <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
        <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
        <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
      </table>
    </fieldset>

    <fieldset>
      <div class="control-group buttons optional">
        <label class="buttons optional control-label">Rows</label>
        <div class="controls btn-group">
          <button class="btn" data-action="addRowBefore">Before</button>
          <button class="btn" data-action="addRowAfter">After</button>
          <button class="btn" data-action="removeRow">Remove</button>
        </div>
      </div>
      <div class="control-group buttons optional">
        <label class="buttons optional control-label">Columns</label>
        <div class="controls btn-group">
          <button class="btn" data-action="addColumnBefore">Before</button>
          <button class="btn" data-action="addColumnAfter">After</button>
          <button class="btn" data-action="removeColumn">Remove</button>
        </div>
      </div>

      <hr/>

      <div class="control-group buttons optional">
        <label class="buttons optional control-label">Row Span</label>
        <div class="controls btn-group">
          <button class="btn" data-action="increaseRowspan">+</button>
          <button class="btn" data-action="decreaseRowspan">-</button>
        </div>
      </div>
      <div class="control-group buttons optional">
        <label class="buttons optional control-label">Column Span</label>
        <div class="controls btn-group">
          <button class="btn" data-action="increaseColspan">+</button>
          <button class="btn" data-action="decreaseColspan">-</button>
        </div>
      </div>
    </fieldset>

    <fieldset>
      <legend>Options</legend>
      <div class="control-group select optional">
        <label class="select optional control-label" for="table_alignment">Alignment</label>
        <div class="controls">
          <select class="select optional" id="table_alignment" name="table[align]">
            <option value="">None</option>
            <option value="right">Right</option>
            <option value="left">Left</option>
          </select>
        </div>
      </div>
    </fieldset>

    <div class="form-actions">
      <input class="btn btn-primary" name="commit" type="submit" value="Insert Table"/>
    </div>
  </form>
  """
