#
#= require jquery-1.6
#= require jquery-ui-1.8.13.custom.min
#= require jquery-ui-1.8.13.sortable.custom
#= require jquery.easing
#= require jquery.json2
#= require jquery.ujs
#= require jquery.serialize_object
#= require liquidmetal
#= require showdown
#
#= require_self
#= require ./native_extensions
#= require ./page_editor
#= require ./history_buffer
#= require ./table_editor
#= require ./dialog
#= require ./palette
#= require ./select
#= require ./panel
#= require ./modal
#= require ./statusbar
#= require ./toolbar
#= require ./toolbar.button
#= require ./toolbar.button_group
#= require ./toolbar.expander
#= require ./tooltip
#= require ./snippet
#= require ./snippet_toolbar
#= require ./region
#= require ./uploader
#= require_tree ./regions
#= require_tree ./dialogs
#= require_tree ./modals
#

@Mercury = {

  version: '0.1.1'


  # No IE support yet because it doesn't follow the W3C standards for HTML5 contentEditable (aka designMode).
  supported: document.getElementById && document.designMode && !jQuery.browser.konqueror && !jQuery.browser.msie


  # Silent mode disables things like asking about unsaved changes before leaving the page.
  silent: false


  # Turning debug mode on will log events and other various things (using console.log if available).
  debug: false


  # Configuration
  config: {

    # Pasting (in Chrome/Safari)
    #
    # When copying content using webkit, it embeds all the user defined styles (from the css files) into the html style
    # attributes directly.  When pasting this content into HTML5 contentEditable elements it leaves these intact.  This
    # can be a desired feature, or an annoyance, so you can enable it or disable it here.  Keep in mind this will only
    # change the behavior in webkit, as gecko doesn't do this.
    #
    cleanStylesOnPaste: true


    # Image Uploading (in supported regions)
    #
    # If you drag images (while pressing shift) from your desktop into regions that support it, it will be uploaded to
    # the server and inserted into the region.  This configuration allows you to specify if you want to disable/enable
    # this feature, the accepted mime-types, file size restrictions, and other things related to uploading.
    #
    uploading:
      enabled: true
      allowedMimeTypes: ['image/jpeg', 'image/gif', 'image/png']
      maxFileSize: 1235242880 # bytes (5 Mb by default)
      inputName: 'image[image]'
      url: '/images'


    # Toolbars
    #
    # This is where you can customize the toolbars by adding or removing buttons, or changing them and their behaviors.
    # Any top level object put here will create a new toolbar.  Buttons are simply nested inside the toolbars, along
    # with button groups.
    #
    # Buttons can be grouped.  A button group is simply a way to wrap buttons for styling, and can also handle enabling
    # or disabling all the buttons within it by using a context.  The table button group is a good example of this.
    #
    # The primary toolbar is always visible, but any other toolbar should have a name based on what type of region it's
    # for.  The toolbar will be enabled/disabled base on what region currently has focus.  Some toolbars are custom (the
    # snippetable toolbar for instance), and to denote that use _custom: true.  You can then build the toolbar yourself
    # with it's own behavior.
    #
    # It's important to note that each of the button names (keys), in each toolbar object must be unique, regardless of
    # if it's in a button group, or nested, etc.  This is because styling is applied to them by name.
    #
    # Button format: [label, description, {type: action, type: action, etc}] The available button types are:
    #
    # toggle:  toggles on or off when clicked, otherwise behaves like a button
    # modal:   opens a modal window, expects the action to be one of:
    #            a string url
    #            a function that returns a string url
    # panel:   opens a panel dialog, expects the action to be one of:
    #            a string url
    #            a function that returns a string url
    # palette: opens a palette window, expects the action to be one of:
    #            a string url
    #            a function that returns a string url
    # select:  opens a pulldown style window, expects the action to be one of:
    #            a string url
    #            a function that returns a string url
    # context: calls a callback function, expects the action to be:
    #            a function that returns a boolean to highlight the button
    #            note: if a function isn't provided, the key will be passed to the contextHandler, in which case a
    #                  default context will be used (for more info read the Contexts section below)
    # mode:    toggle a given mode in the editor, expects the action to be:
    #            a string, denoting the name of the mode
    #            note: it's assumed that when a specific mode is turned on, all other modes will be turned off, which
    #                  happens automatically, thus putting the editor into a specific "state"
    # regions: allows buttons to be enabled/disabled based on what region type has focus, expects the action to be:
    #            an array of region types (eg. ['editable', 'markupable']
    # preload: allows some dialog views to be loaded whtn the button is created instead of on first open, expects:
    #            a boolean
    #            note: only used for panels, selects, and palettes
    #
    # Separators are any "button" that's not an array, and are expected to be a string.  You can use two different
    # separator styles: line ('-'), and spacer (' ').
    #
    toolbars:
      primary:
        save:                  ['Save', 'Save this page']
        preview:               ['Preview', 'Preview this page', {toggle: true, mode: true}]
        sep1:                  ' '
        undoredo:
          undo:                ['Undo', 'Undo your last action']
          redo:                ['Redo', 'Redo your last action']
          sep:                 ' '
        insertLink:            ['Link', 'Insert Link', {modal: '/mercury/modals/link', regions: ['editable', 'markupable']}]
        insertMedia:           ['Media', 'Insert Media (images and videos)', {modal: '/mercury/modals/media', regions: ['editable', 'markupable']}]
        insertTable:           ['Table', 'Insert Table', {modal: '/mercury/modals/table', regions: ['editable', 'markupable']}]
        insertCharacter:       ['Character', 'Special Characters', {modal: '/mercury/modals/character', regions: ['editable', 'markupable']}]
        objectsPanel:          ['Snippet', 'Snippet Panel', {panel: '/mercury/panels/snippets'}]
        sep2:                  ' '
        historyPanel:          ['History', 'Page Version History', {panel: '/mercury/panels/history'}]
        sep3:                  ' '
        notesPanel:            ['Notes', 'Page Notes', {panel: '/mercury/panels/notes'}]

      editable:
        _regions:              ['editable', 'markupable']
        predefined:
          style:               ['Style', null, {select: '/mercury/selects/style', preload: true}]
          sep1:                ' '
          formatblock:         ['Block Format', null, {select: '/mercury/selects/formatblock', preload: true}]
          sep2:                '-'
        colors:
          _regions:            ['editable']
          backColor:           ['Background Color', null, {palette: '/mercury/palettes/backcolor', context: true, preload: true}]
          sep1:                ' '
          foreColor:           ['Text Color', null, {palette: '/mercury/palettes/forecolor', context: true, preload: true}]
          sep2:                '-'
        decoration:
          bold:                ['Bold', null, {context: true}]
          italic:              ['Italicize', null, {context: true}]
          overline:            ['Overline', null, {context: true, regions: ['editable']}]
          strikethrough:       ['Strikethrough', null, {context: true, regions: ['editable']}]
          underline:           ['Underline', null, {context: true, regions: ['editable']}]
          sep:                 '-'
        script:
          subscript:           ['Subscript', null, {context: true}]
          superscript:         ['Superscript', null, {context: true}]
          sep:                 '-'
        justify:
          _regions:            ['editable']
          justifyLeft:         ['Align Left', null, {context: true}]
          justifyCenter:       ['Center', null, {context: true}]
          justifyRight:        ['Align Right', null, {context: true}]
          justifyFull:         ['Justify Full', null, {context: true}]
          sep:                 '-'
        list:
          insertUnorderedList: ['Unordered List', null, {context: true}]
          insertOrderedList:   ['Numbered List', null, {context: true}]
          sep:                 '-'
        indent:
          outdent:             ['Decrease Indentation', null]
          indent:              ['Increase Indentation', null]
          sep:                 '-'
        table:
          _context:            true
          _regions:            ['editable']
          insertRowBefore:     ['Insert Table Row', 'Insert a table row before the cursor']
          insertRowAfter:      ['Insert Table Row', 'Insert a table row after the cursor']
          deleteRow:           ['Delete Table Row', 'Delete this table row']
          insertColumnBefore:  ['Insert Table Column', 'Insert a table column before the cursor']
          insertColumnAfter:   ['Insert Table Column', 'Insert a table column after the cursor']
          deleteColumn:        ['Delete Table Column', 'Delete this table column']
          sep1:                ' '
          increaseColspan:     ['Increase Cell Columns', 'Increase the cells colspan']
          decreaseColspan:     ['Decrease Cell Columns', 'Decrease the cells colspan and add a new cell']
          increaseRowspan:     ['Increase Cell Rows', 'Increase the cells rowspan']
          decreaseRowspan:     ['Decrease Cell Rows', 'Decrease the cells rowspan and add a new cell']
          sep2:                '-'
        rules:
          horizontalRule:      ['Horizontal Rule', 'Insert a horizontal rule']
          sep1:                '-'
        formatting:
          _regions:            ['editable']
          removeFormatting:    ['Remove Formatting', 'Remove formatting for the selection']
          sep2:                ' '
        editors:
          _regions:            ['editable']
          htmlEditor:          ['Edit HTML', 'Edit the HTML content'] # example behavior below

      snippetable:
        _custom:               true
        actions:
          editSnippet:         ['Edit Snippet Settings', null]
          sep1:                ' '
          removeSnippet:       ['Remove Snippet', null]


    # Behaviors
    #
    # Behaviors are used to change the default behaviors of a given region type when a given button is clicked.  For
    # example, you may prefer to add HR tags using an HR wrapped within a div with a classname (for styling).  You can
    # add your own complex behaviors here.
    #
    # You can see how the behavior matches up directly with the button name.  It's also important to note that the
    # callback functions are executed within the scope of the given region, so you have access to all it's methods.
    # todo: figure out how this impacts different regions.. should they go away, or should they get moved into region types?
    behaviors:
      horizontalRule: (selection) -> selection.replace('<hr/>')

      htmlEditor: ->
        Mercury.modal '/mercury/modals/htmleditor', {
          title: 'HTML Editor',
          fullHeight: true,
          handler: 'htmlEditor'
        }


    # Contexts
    #
    # Contexts are used callback functions used for highlighting and disabling/enabling buttons and buttongroups.  When
    # the cursor enters an element within an html region for instance we want to disable or highlight buttons based on
    # the properties of the given node.  You can see some examples of contexts in:
    #
    # Mercury.Toolbar.Button.contexts
    # and
    # Mercury.Toolbar.ButtonGroup.contexts
    #


    # Styles
    #
    # Mercury tries to stay as much out of your code as possible, but because regions appear within your document we
    # need to include a few styles to indicate regions, as well as the different states of them (eg. focused).  These
    # styles are injected into your document, and as simple as they might be, you may want to change them.  You can do
    # so here.
    #
    injectedStyles: '''
      .mercury-region, .mercury-textarea { min-height: 10px; outline: 1px dotted #09F }
      .mercury-textarea { box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; resize: vertical; }
      .mercury-region:focus, .mercury-region.focus, .mercury-textarea.focus { outline: none; -webkit-box-shadow: 0 0 10px #09F, 0 0 1px #045; box-shadow: 0 0 10px #09F, 0 0 1px #045 }
      .mercury-region:after { content: '.'; display: block; visibility: hidden; clear: both; height: 0; overflow: hidden; }
      .mercury-region table, .mercury-region td { border: 1px dotted red; }
      '''
  }


  # Custom event and logging methods
  bind: (eventName, callback) ->
    jQuery(document).bind("mercury:#{eventName}", callback)


  trigger: (eventName, options) ->
    Mercury.log(eventName, options)
    jQuery(document).trigger("mercury:#{eventName}", options)


  log: ->
    if Mercury.debug && console
      return if arguments[0] == 'hide:toolbar' || arguments[0] == 'show:toolbar'
      try console.debug(arguments) catch e


  # Mercury object namespaces
  Regions: {}
  modalHandlers: {}
  dialogHandlers: {}

}
