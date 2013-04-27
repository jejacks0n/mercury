Plugin = Mercury.registerPlugin 'table'
  description: 'Provides interface for inserting and editing tables.'
  version: '1.0.0'

  actions:
    link: 'insert'

  events:
    'mercury:edit:media': 'showDialog'
    'button:click': 'showDialog'

  registerButton: ->
    @button.set(type: 'table')


  showDialog: ->
    @bindTo(new Plugin.Modal())


  bindTo: (view) ->
    view.on('form:submitted', (value) -> console.debug(value))


  insert: ->


class Plugin.Modal extends Mercury.Modal
  template:  'table'
  className: 'mercury-table-dialog'
  title:     'Table Manager'
  width:     600


@JST ||= {}
JST['/mercury/templates/table'] ||= ->
  """
  <form class="form-horizontal">
    <div class="form-inputs">

      <fieldset id="table_display">
        <div class="control-group optional">
          <div class="controls">
            <table border="1" cellspacing="0">
              <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
              <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
              <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>
            </table>
          </div>
        </div>
      </fieldset>

      <fieldset>
        <div class="control-group buttons optional">
          <label class="buttons optional control-label">Rows</label>
          <div class="controls btn-group">
            <button class="btn" data-action="addRowBefore">Add Before</button>
            <button class="btn" data-action="addRowAfter">Add After</button>
            <button class="btn" data-action="removeRow">Remove</button>
          </div>
        </div>
        <div class="control-group buttons optional">
          <label class="buttons optional control-label">Columns</label>
          <div class="controls btn-group">
            <button class="btn" data-action="addColumnBefore">Add Before</button>
            <button class="btn" data-action="addColumnAfter">Add After</button>
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
            <select class="select optional" id="table_alignment" name="table[alignment]">
              <option value="">None</option>
              <option value="right">Right</option>
              <option value="left">Left</option>
            </select>
          </div>
        </div>
        <div class="control-group number optional">
          <label class="number optional control-label" for="table_border">Border</label>
          <div class="controls">
            <input class="span1 number optional" id="table_border" name="table[border]" size="50" type="number" value="1">
          </div>
        </div>
        <div class="control-group number optional">
          <label class="number optional control-label" for="table_spacing">Spacing</label>
          <div class="controls">
            <input class="span1 number optional" id="table_spacing" name="table[spacing]" size="50" type="number" value="0">
          </div>
        </div>
      </fieldset>

    </div>
    <div class="form-actions">
      <input class="btn btn-primary" name="commit" type="submit" value="Insert Table"/>
    </div>
  </form>
  """
