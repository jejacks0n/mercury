/*!
 * Mercury Editor is a CoffeeScript and jQuery based WYSIWYG editor.  Documentation and other useful information can be
 * found at https://github.com/jejacks0n/mercury
 *
 * Supported browsers:
 *   - Firefox 4+
 *   - Chrome 10+
 *   - Safari 5+
 *
 * Copyright (c) 2011 Jeremy Jackson
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 * persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 *= require_self
 *
 * Add all requires for the support libraries that integrate nicely with Mercury Editor.
 * require mercury/support/history
 *
 * Require Mercury Editor itself.
 *= require mercury/mercury
 *
 * Add all requires for plugins that extend or change the behavior of Mercury Editor.
 * require mercury/plugins/save_as_xml/plugin.js
 */
window.MercurySetup = {

  // # Mercury Configuration
  config: {
    // ## Hijacking Links & Forms
    //
    // Mercury will hijack links and forms that don't have a target set, or the target is set to _self and will set it
    // to _top.  This is because the target must be set properly for Mercury to not get in the way of some
    // functionality, like proper page loads on form submissions etc.  Mercury doesn't do this to links or forms that
    // are within editable regions because it doesn't want to impact the html that's saved.  With that being explained,
    // you can add classes to links or forms that you don't want this behavior added to.  Let's say you have links that
    // open a lightbox style window, and you don't want the targets of these to be set to _top.  You can add classes to
    // this array, and they will be ignored when the hijacking is applied.
    nonHijackableClasses: [],


    // ## Ajax and CSRF Headers
    //
    // Some server frameworks require that you provide a specific header for Ajax requests.  The values for these CSRF
    // tokens are typically stored in the rendered DOM.  By default, Mercury will look for the Rails specific meta tag,
    // and provide the X-CSRF-Token header on Ajax requests, but you can modify this configuration if the system you're
    // using doesn't follow the same standard.
    csrfSelector: 'meta[name="csrf-token"]',
    csrfHeader: 'X-CSRF-Token',


    // ## Pasting (in Chrome/Safari)
    //
    // When copying content using webkit, it embeds all the user defined styles (from the css files) into the html
    // style attributes directly.  When pasting this content into HTML5 contentEditable elements it leaves these
    // intact.  This can be a desired feature, or an annoyance, so you can enable it or disable it here.  This means
    // that copying something from a webkit based browser and pasting it into something like firefox will also result in
    // these extra style attributes.  Cleaning the styles out impacts performance when pasting, and because of browser
    // restrictions on getting pasted content (which is stupid) we have to fall back to a less performant method off
    // figuring out what was pasted.  This seems to cause issues if you try and paste several things in a row, which
    // seems to happen a lot when people are testing the demo.  Because of this it's disabled by default, but is
    // recommended if you're using webkit.
    // Go signin and vote to change this: http://www.google.com/support/forum/p/Chrome/thread?tid=3399afd053d5a29c&hl=en
    cleanStylesOnPaste: false,


    // ## Snippet Options and Preview
    //
    // When a user drags a snippet onto the page they'll be prompted to enter options for the given snippet.  The server
    // is expected to respond with a form.  Once the user submits this form, an Ajax request is sent to the server with
    // the options provided; this preview request is expected to respond with the rendered markup for the snippet.
    //
    // Name will be replaced with the snippet name (eg. example)
    snippets: {
      method: 'POST',
      optionsUrl: '/mercury/snippets/:name/options.html',
      previewUrl: '/mercury/snippets/:name/preview.html'
      },


    // ## Image Uploading
    //
    // If you drag images (while pressing shift) from your desktop into regions that support it, it will be uploaded
    // to the server and inserted into the region.  This configuration allows you to specify if you want to
    // disable/enable this feature, the accepted mime-types, file size restrictions, and other things related to
    // uploading.  You can optionally provide a handler function that takes the response from the server and returns an
    // object: {image: {url: '[your provided url]'}
    //
    // **Note:** Image uploading is only supported in some region types.
    uploading: {
      enabled: true,
      allowedMimeTypes: ['image/jpeg', 'image/gif', 'image/png'],
      maxFileSize: 1235242880,
      inputName: 'image[image]',
      url: '/images',
      handler: false
      },


    // ## Toolbars
    //
    // This is where you can customize the toolbars by adding or removing buttons, or changing them and their
    // behaviors.  Any top level object put here will create a new toolbar.  Buttons are simply nested inside the
    // toolbars, along with button groups.
    //
    // Some toolbars are custom (the snippetable toolbar for instance), and to denote that use _custom: true.  You can
    // then build the toolbar yourself with it's own behavior.
    //
    // Buttons can be grouped, and a button group is simply a way to wrap buttons for styling -- they can also handle
    // enabling or disabling all the buttons within it by using a context.  The table button group is a good example
    // of this.
    //
    // It's important to note that each of the button names (keys), in each toolbar object must be unique, regardless
    // of if it's in a button group, or nested, etc.  This is because styling is applied to them by name, and because
    // their name is used in the event that's fired when you click on them.
    //
    // Button format: `[label, description, {type: action, type: action, etc}]`
    //
    // ### The available button types are:
    //
    // - toggle:  toggles on or off when clicked, otherwise behaves like a button
    // - modal:   opens a modal window, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - panel:   opens a panel dialog, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - palette: opens a palette window, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - select:  opens a pulldown style window, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - context: calls a callback function, expects the action to be:
    //   1. a function that returns a boolean to highlight the button
    //   note: if a function isn't provided, the key will be passed to the contextHandler, in which case a default
    //         context will be used (for more info read the Contexts section below)
    // - mode:    toggle a given mode in the editor, expects the action to be:
    //   1. a string, denoting the name of the mode
    //   note: it's assumed that when a specific mode is turned on, all other modes will be turned off, which happens
    //         automatically, thus putting the editor into a specific "state"
    // - regions: allows buttons to be enabled/disabled based on what region type has focus, expects the action to be:
    //   1. an array of region types (eg. ['editable', 'markupable'])
    // - preload: allows some dialog views to be loaded when the button is created instead of on first open, expects:
    //   1. a boolean true / false
    //   note: this is only used by panels, selects, and palettes
    //
    // Separators are any "button" that's not an array, and are expected to be a string.  You can use two different
    // separator styles: line ('-'), and spacer (' ').
    toolbars: {
      primary: {
        save:                  ['Save', 'Save this page'],
        preview:               ['Preview', 'Preview this page', { toggle: true, mode: true }],
        sep1:                  ' ',
        undoredo:              {
          undo:                ['Undo', 'Undo your last action'],
          redo:                ['Redo', 'Redo your last action'],
          sep:                 ' '
          },
        insertLink:            ['Link', 'Insert Link', { modal: '/mercury/modals/link.html', regions: ['editable', 'markupable'] }],
        insertMedia:           ['Media', 'Insert Media (images and videos)', { modal: '/mercury/modals/media.html', regions: ['editable', 'markupable'] }],
        insertTable:           ['Table', 'Insert Table', { modal: '/mercury/modals/table.html', regions: ['editable', 'markupable'] }],
        insertCharacter:       ['Character', 'Special Characters', { modal: '/mercury/modals/character.html', regions: ['editable', 'markupable'] }],
        snippetPanel:          ['Snippet', 'Snippet Panel', { panel: '/mercury/panels/snippets.html' }],
        sep2:                  ' ',
        historyPanel:          ['History', 'Page Version History', { panel: '/mercury/panels/history.html' }],
        sep3:                  ' ',
        notesPanel:            ['Notes', 'Page Notes', { panel: '/mercury/panels/notes.html' }]
        },

      editable: {
        _regions:              ['editable', 'markupable'],
        predefined:            {
          style:               ['Style', null, { select: '/mercury/selects/style.html', preload: true }],
          sep1:                ' ',
          formatblock:         ['Block Format', null, { select: '/mercury/selects/formatblock.html', preload: true }],
          sep2:                '-'
          },
        colors:                {
          backColor:           ['Background Color', null, { palette: '/mercury/palettes/backcolor.html', context: true, preload: true, regions: ['editable'] }],
          sep1:                ' ',
          foreColor:           ['Text Color', null, { palette: '/mercury/palettes/forecolor.html', context: true, preload: true, regions: ['editable'] }],
          sep2:                '-'
          },
        decoration:            {
          bold:                ['Bold', null, { context: true }],
          italic:              ['Italicize', null, { context: true }],
          overline:            ['Overline', null, { context: true, regions: ['editable'] }],
          strikethrough:       ['Strikethrough', null, { context: true, regions: ['editable'] }],
          underline:           ['Underline', null, { context: true, regions: ['editable'] }],
          sep:                 '-'
          },
        script:                {
          subscript:           ['Subscript', null, { context: true }],
          superscript:         ['Superscript', null, { context: true }],
          sep: '-'
          },
        justify:               {
          justifyLeft:         ['Align Left', null, { context: true, regions: ['editable'] }],
          justifyCenter:       ['Center', null, { context: true, regions: ['editable'] }],
          justifyRight:        ['Align Right', null, { context: true, regions: ['editable'] }],
          justifyFull:         ['Justify Full', null, { context: true, regions: ['editable'] }],
          sep:                 '-'
          },
        list:                  {
          insertUnorderedList: ['Unordered List', null, { context: true }],
          insertOrderedList:   ['Numbered List', null, { context: true }],
          sep:                 '-'
          },
        indent:                {
          outdent:             ['Decrease Indentation', null],
          indent:              ['Increase Indentation', null],
          sep:                 '-'
          },
        table:                 {
          _context:            true,
          insertRowBefore:     ['Insert Table Row', 'Insert a table row before the cursor', { regions: ['editable'] }],
          insertRowAfter:      ['Insert Table Row', 'Insert a table row after the cursor', { regions: ['editable'] }],
          deleteRow:           ['Delete Table Row', 'Delete this table row', { regions: ['editable'] }],
          insertColumnBefore:  ['Insert Table Column', 'Insert a table column before the cursor', { regions: ['editable'] }],
          insertColumnAfter:   ['Insert Table Column', 'Insert a table column after the cursor', { regions: ['editable'] }],
          deleteColumn:        ['Delete Table Column', 'Delete this table column', { regions: ['editable'] }],
          sep1:                ' ',
          increaseColspan:     ['Increase Cell Columns', 'Increase the cells colspan'],
          decreaseColspan:     ['Decrease Cell Columns', 'Decrease the cells colspan and add a new cell'],
          increaseRowspan:     ['Increase Cell Rows', 'Increase the cells rowspan'],
          decreaseRowspan:     ['Decrease Cell Rows', 'Decrease the cells rowspan and add a new cell'],
          sep2:                '-'
          },
        rules:                 {
          horizontalRule:      ['Horizontal Rule', 'Insert a horizontal rule'],
          sep1:                '-'
          },
        formatting:            {
          removeFormatting:    ['Remove Formatting', 'Remove formatting for the selection', { regions: ['editable'] }],
          sep2:                ' '
          },
        editors:               {
          htmlEditor:          ['Edit HTML', 'Edit the HTML content', { regions: ['editable'] }]
          }
        },

      snippetable: {
        _custom:               true,
        actions:               {
          editSnippet:         ['Edit Snippet Settings', null],
          sep1:                ' ',
          removeSnippet:       ['Remove Snippet', null]
          }
        }
      },


    // ## Behaviors
    //
    // Behaviors are used to change the default behaviors of a given region type when a given button is clicked.  For
    // example, you may prefer to add HR tags using an HR wrapped within a div with a classname (for styling).  You
    // can add your own complex behaviors here.
    //
    // You can see how the behavior matches up directly with the button names.  It's also important to note that the
    // callback functions are executed within the scope of the given region, so you have access to all it's methods.
    behaviors: {
      horizontalRule: function(selection) {
        //selection.replace('<hr/>', true);
        this.execCommand('insertHorizontalRule');
      },
      htmlEditor: function() { Mercury.modal('/mercury/modals/htmleditor.html', { title: 'HTML Editor', fullHeight: true, handler: 'htmlEditor' }) }
      },


    // ## Contexts
    //
    // Contexts are used callback functions used for highlighting and disabling/enabling buttons and buttongroups.
    // When the cursor enters an element within an html region for instance we want to disable or highlight buttons
    // based on the properties of the given node.  You can see some examples of contexts in:
    //
    // Mercury.Toolbar.Button.contexts
    // and
    // Mercury.Toolbar.ButtonGroup.contexts


    // ## Styles
    //
    // Mercury tries to stay as much out of your code as possible, but because regions appear within your document we
    // need to include a few styles to indicate regions, as well as the different states of them (eg. focused).  These
    // styles are injected into your document, and as simple as they might be, you may want to change them.  You can do
    // so here.
    injectedStyles: '' +
      '.mercury-region, .mercury-textarea { min-height: 10px; outline: 1px dotted #09F }' +
      '.mercury-textarea { box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; resize: vertical; }' +
      '.mercury-region:focus, .mercury-region.focus, .mercury-textarea.focus { outline: none; -webkit-box-shadow: 0 0 10px #09F, 0 0 1px #045; box-shadow: 0 0 10px #09F, 0 0 1px #045 }' +
      '.mercury-region:after { content: "."; display: block; visibility: hidden; clear: both; height: 0; overflow: hidden; }' +
      '.mercury-region table, .mercury-region td, .mercury-region th { border: 1px dotted red; }'
  },

  // ## Silent Mode
  //
  // Turning silent mode on will disable asking about unsaved changes before leaving the page.
  silent: false,

  // ## Debug Mode
  //
  // Turning debug mode on will log events and other various things (using console.debug if available).
  debug: false

};

if (!window.Mercury) window.Mercury = window.MercurySetup;
else if (typeof(jQuery) !== 'undefined') jQuery.extend(window.Mercury, window.MercurySetup);