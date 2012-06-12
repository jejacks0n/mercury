/*!
 * Mercury Editor is a CoffeeScript and jQuery based WYSIWYG editor.  Documentation and other useful information can be
 * found at https://github.com/jejacks0n/mercury
 *
 * Minimum jQuery requirements are 1.7
 *= require_self
 *
 * You can include the Rails jQuery ujs script here to get some nicer behaviors in modals, panels and lightviews when
 * using :remote => true within the contents rendered in them.
 * require jquery_ujs
 *
 * Add any requires for the support libraries that integrate nicely with Mercury Editor.
 * require mercury/support/history
 *
 * Require Mercury Editor itself.
 *= require mercury/mercury
 *
 * Require any localizations you wish to support
 * Example: es.locale, or fr.locale -- regional dialects are in each language file so never en_US for instance.
 * Make sure you enable the localization feature in the configuration.
 * require mercury/locales/swedish_chef.locale
 *
 * Add all requires for plugins that extend or change the behavior of Mercury Editor.
 * require mercury/plugins/save_as_xml/plugin.js
 *
 * Require any files you want to use that either extend, or change the default Mercury behavior.
 * require mercury_overrides
 */
window.Mercury = {

  // # Mercury Configuration
  config: {
    // ## Toolbars
    //
    // This is where you can customize the toolbars by adding or removing buttons, or changing them and their
    // behaviors.  Any top level object put here will create a new toolbar.  Buttons are simply nested inside the
    // toolbars, along with button groups.
    //
    // Some toolbars are custom (the snippets toolbar for instance), and to denote that use _custom: true.  You can then
    // build the toolbar yourself with it's own behavior.
    //
    // Buttons can be grouped, and a button group is simply a way to wrap buttons for styling -- they can also handle
    // enabling or disabling all the buttons within it by using a context.  The table button group is a good example of
    // this.
    //
    // It's important to note that each of the button names (keys), in each toolbar object must be unique, regardless of
    // if it's in a button group, or nested, etc.  This is because styling is applied to them by name, and because their
    // name is used in the event that's fired when you click on them.
    //
    // Button format: `[label, description, {type: action, type: action, etc}]`
    //
    // ### The available button types are:
    //
    // - toggle:    toggles on or off when clicked, otherwise behaves like a button
    // - modal:     opens a modal window, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - lightview: opens a lightview window (like modal, but different UI), expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - panel:     opens a panel dialog, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - palette:   opens a palette window, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - select:    opens a pulldown style window, expects the action to be one of:
    //   1. a string url
    //   2. a function that returns a string url
    // - context:   calls a callback function, expects the action to be:
    //   1. a function that returns a boolean to highlight the button
    //   note: if a function isn't provided, the key will be passed to the contextHandler, in which case a default
    //         context will be used (for more info read the Contexts section below)
    // - mode:      toggle a given mode in the editor, expects the action to be:
    //   1. a string, denoting the name of the mode
    //   note: it's assumed that when a specific mode is turned on, all other modes will be turned off, which happens
    //         automatically, thus putting the editor into a specific "state"
    // - regions:   allows buttons to be enabled/disabled based on what region type has focus, expects:
    //   1. an array of region types (eg. ['full', 'markdown'])
    // - preload:   allows some dialog views to be loaded when the button is created instead of on first open, expects:
    //   1. a boolean true / false
    //   note: this is only used by panels, selects, and palettes
    //
    // Separators are any "button" that's not an array, and are expected to be a string.  You can use two different
    // separator styles: line ('-'), and spacer (' ').
    //
    // ### Adding Contexts
    //
    // Contexts are used callback functions used for highlighting and disabling/enabling buttons and buttongroups.  When
    // the cursor enters an element within an html region for instance we want to disable or highlight buttons based on
    // the properties of the given node.  You can see examples of contexts in, and add your own to:
    // `Mercury.Toolbar.Button.contexts` and `Mercury.Toolbar.ButtonGroup.contexts`
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
        insertLink:            ['Link', 'Insert Link', { modal: '/mercury/modals/link.html', regions: ['full', 'markdown'] }],
        insertMedia:           ['Media', 'Insert Media (images and videos)', { modal: '/mercury/modals/media.html', regions: ['full', 'markdown'] }],
        insertTable:           ['Table', 'Insert Table', { modal: '/mercury/modals/table.html', regions: ['full', 'markdown'] }],
        insertCharacter:       ['Character', 'Special Characters', { modal: '/mercury/modals/character.html', regions: ['full', 'markdown'] }],
        snippetPanel:          ['Snippet', 'Snippet Panel', { panel: '/mercury/panels/snippets.html' }],
        sep2:                  ' ',
        historyPanel:          ['History', 'Page Version History', { panel: '/mercury/panels/history.html' }],
        sep3:                  ' ',
        notesPanel:            ['Notes', 'Page Notes', { panel: '/mercury/panels/notes.html' }]
        },

      editable: {
        _regions:              ['full', 'markdown'],
        predefined:            {
          style:               ['Style', null, { select: '/mercury/selects/style.html', preload: true }],
          sep1:                ' ',
          formatblock:         ['Block Format', null, { select: '/mercury/selects/formatblock.html', preload: true }],
          sep2:                '-'
          },
        colors:                {
          backColor:           ['Background Color', null, { palette: '/mercury/palettes/backcolor.html', context: true, preload: true, regions: ['full'] }],
          sep1:                ' ',
          foreColor:           ['Text Color', null, { palette: '/mercury/palettes/forecolor.html', context: true, preload: true, regions: ['full'] }],
          sep2:                '-'
          },
        decoration:            {
          bold:                ['Bold', null, { context: true }],
          italic:              ['Italicize', null, { context: true }],
          overline:            ['Overline', null, { context: true, regions: ['full'] }],
          strikethrough:       ['Strikethrough', null, { context: true, regions: ['full'] }],
          underline:           ['Underline', null, { context: true, regions: ['full'] }],
          sep:                 '-'
          },
        script:                {
          subscript:           ['Subscript', null, { context: true }],
          superscript:         ['Superscript', null, { context: true }],
          sep: '-'
          },
        justify:               {
          justifyLeft:         ['Align Left', null, { context: true, regions: ['full'] }],
          justifyCenter:       ['Center', null, { context: true, regions: ['full'] }],
          justifyRight:        ['Align Right', null, { context: true, regions: ['full'] }],
          justifyFull:         ['Justify Full', null, { context: true, regions: ['full'] }],
          sep:                 '-'
          },
        list:                  {
          insertUnorderedList: ['Unordered List', null, { context: true }],
          insertOrderedList:   ['Numbered List', null, { context: true }],
          sep:                 '-'
          },
        indent:                {
          outdent:             ['Decrease Indentation'],
          indent:              ['Increase Indentation'],
          sep:                 '-'
          },
        table:                 {
          _context:            true,
          insertRowBefore:     ['Insert Table Row', 'Insert a table row before the cursor', { regions: ['full'] }],
          insertRowAfter:      ['Insert Table Row', 'Insert a table row after the cursor', { regions: ['full'] }],
          deleteRow:           ['Delete Table Row', 'Delete this table row', { regions: ['full'] }],
          insertColumnBefore:  ['Insert Table Column', 'Insert a table column before the cursor', { regions: ['full'] }],
          insertColumnAfter:   ['Insert Table Column', 'Insert a table column after the cursor', { regions: ['full'] }],
          deleteColumn:        ['Delete Table Column', 'Delete this table column', { regions: ['full'] }],
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
          removeFormatting:    ['Remove Formatting', 'Remove formatting for the selection', { regions: ['full'] }],
          sep2:                ' '
          },
        editors:               {
          htmlEditor:          ['Edit HTML', 'Edit the HTML content', { regions: ['full'] }]
          }
        },

      snippets: {
        _custom:               true,
        actions:               {
          editSnippet:         ['Edit Snippet Settings'],
          sep1:                ' ',
          removeSnippet:       ['Remove Snippet']
          }
        }
      },


    // ## Region Options
    //
    // You can customize some aspects of how regions are found, identified, and saved.
    //
    // attribute: Mercury identifies editable regions by a data-mercury attribute.  This attribute has to be added in
    // your HTML in advance, and is the only real code/naming exposed in the implementation of Mercury.  To allow this
    // to be as configurable as possible, you can set the name of this attribute.  If you change this, you should adjust
    // the injected styles as well.
    //
    // identifier: This is used as a unique identifier for any given region (and thus should be unique to the page).
    // By default this is the id attribute but can be changed to a data attribute should you want to use something
    // custom instead.
    //
    // dataAttributes: The dataAttributes is an array of data attributes that will be serialized and returned to the
    // server upon saving.  These attributes, when applied to a Mercury region element, will be automatically serialized
    // and submitted with the AJAX request sent when a page is saved.  These are expected to be HTML5 data attributes,
    // and 'data-' will automatically be prepended to each item in this directive. (ex. ['scope', 'version'])
    //
    // determineType: This function is called after checking the data-type attribute for the correct field type. Use
    // it if you want to dynamically set the type based on inspection of the region.
    regions: {
      attribute: 'data-mercury',
      identifier: 'id',
      dataAttributes: []
      // determineType: function(region){},
      },


    // ## Snippet Options / Preview
    //
    // When a user drags a snippet onto the page they'll be prompted to enter options for the given snippet.  The server
    // is expected to respond with a form.  Once the user submits this form, an Ajax request is sent to the server with
    // the options provided; this preview request is expected to respond with the rendered markup for the snippet.
    //
    // method: The HTTP method used when submitting both the options and the preview.  We use POST by default because a
    // snippet options form may contain large text inputs and we don't want that to be truncated when sent to the
    // server.
    //
    // optionsUrl: The url that the options form will be loaded from.
    //
    // previewUrl: The url that the options will be submitted to, and will return the rendered snippet markup.
    //
    // **Note:** `:name` will be replaced with the snippet name in the urls (eg. /mercury/snippets/example/options.html)
    snippets: {
      method: 'POST',
      optionsUrl: '/mercury/snippets/:name/options.html',
      previewUrl: '/mercury/snippets/:name/preview.html'
      },


    // ## Image Uploading
    //
    // If you drag images from your desktop into regions that support it, it will be uploaded to the server and inserted
    // into the region.  You can disable or enable this feature, the accepted mime-types, file size restrictions, and
    // other things related to uploading.
    //
    // **Note:** Image uploading is only supported in some region types, and some browsers.
    //
    // enabled: You can set this to true, or false if you want to disable the feature entirely.
    //
    // allowedMimeTypes: You can restrict the types of files that can be uploaded by providing a list of allowed mime
    // types.
    //
    // maxFileSize: You can restrict large files by setting the maxFileSize (in bytes).
    //
    // inputName: When uploading, a form is generated and submitted to the server via Ajax.  If your server would prefer
    // a different name for how the image comes through, you can change the inputName.
    //
    // url: The url that the image upload will be submitted to.
    //
    // handler: You can use false to let Mercury handle it for you, or you can provide a handler function that can
    // modify the response from the server.  This can be useful if your server doesn't respond the way Mercury expects.
    // The handler function should take the response from the server and return an object that matches:
    // `{image: {url: '[your provided url]'}`
    uploading: {
      enabled: true,
      allowedMimeTypes: ['image/jpeg', 'image/gif', 'image/png'],
      maxFileSize: 1235242880,
      inputName: 'image[image]',
      url: '/mercury/images',
      handler: false
      },


    // ## Localization / I18n
    //
    // Include the .locale files you want to support when loading Mercury.  The files are always named by the language,
    // and not the regional dialect (eg. en.locale.js) because the regional dialects are nested within the primary
    // locale files.
    //
    // The client locale will be used first, and if no proper locale file is found for their language then the fallback
    // preferredLocale configuration will be used.  If one isn't provided, and the client locale isn't included, the
    // strings will remain untranslated.
    //
    // enabled: Set to false to disable, true to enable.
    //
    // preferredLocale: If a client doesn't support the locales you've included, this is used as a fallback.
    localization: {
      enabled: false,
      preferredLocale: 'swedish_chef-BORK'
      },


    // ## Behaviors
    //
    // Behaviors are used to change the default behaviors of a given region type when a given button is clicked.  For
    // example, you may prefer to add HR tags using an HR wrapped within a div with a classname (for styling).  You
    // can add your own complex behaviors here and they'll be shared across all regions.
    //
    // If you want to add behaviors to specific region types, you can mix them into the actions property of any region
    // type.
    //
    //     Mercury.Regions.Full.actions.htmlEditor = function() {}
    //
    // You can see how the behavior matches up directly with the button names.  It's also important to note that the
    // callback functions are executed within the scope of the given region, so you have access to all it's methods.
    behaviors: {
      //foreColor: function(selection, options) { selection.wrap('<span style="color:' + options.value.toHex() + '">', true) },
      htmlEditor: function() { Mercury.modal('/mercury/modals/htmleditor.html', { title: 'HTML Editor', fullHeight: true, handler: 'htmlEditor' }); }
      },


    // ## Global Behaviors
    //
    // Global behaviors are much like behaviors, but are more "global".  Things like save, exit, etc. can be included
    // here.  They'll only be called once, and execute within the scope of whatever editor is instantiated (eg.
    // PageEditor).
    //
    // An example of changing how saving works:
    //
    //     save: function() {
    //       var data = top.JSON.stringify(this.serialize(), null, '  ');
    //       var content = '<textarea style="width:500px;height:200px" wrap="off">' + data + '</textarea>';
    //       Mercury.modal(null, {title: 'Saving', closeButton: true, content: content})
    //     }
    //
    // This is a nice way to add functionality, when the behaviors aren't region specific.  These can be triggered by a
    // button, or manually with `Mercury.trigger('action', {action: 'barrelRoll'})`
    globalBehaviors: {
      exit: function() { window.location.href = this.iframeSrc() },
      barrelRoll: function() { $('body').css({webkitTransform: 'rotate(360deg)'}) }
      },


    // ## Ajax and CSRF Headers
    //
    // Some server frameworks require that you provide a specific header for Ajax requests.  The values for these CSRF
    // tokens are typically stored in the rendered DOM.  By default, Mercury will look for the Rails specific meta tag,
    // and provide the X-CSRF-Token header on Ajax requests, but you can modify this configuration if the system you're
    // using doesn't follow the same standard.
    csrfSelector: 'meta[name="csrf-token"]',
    csrfHeader: 'X-CSRF-Token',


    // ## Editor URLs
    //
    // When loading a given page, you may want to tweak this regex.  It's to allow the url to differ from the page
    // you're editing, and the url at which you access it.
    editorUrlRegEx: /([http|https]:\/\/.[^\/]*)\/editor\/?(.*)/i,


    // ## Hijacking Links & Forms
    //
    // Mercury will hijack links and forms that don't have a target set, or the target is set to _self and will set it
    // to _parent.  This is because the target must be set properly for Mercury to not get in the way of some
    // functionality, like proper page loads on form submissions etc.  Mercury doesn't do this to links or forms that
    // are within editable regions because it doesn't want to impact the html that's saved.  With that being explained,
    // you can add classes to links or forms that you don't want this behavior added to.  Let's say you have links that
    // open a lightbox style window, and you don't want the targets of these to be set to _parent.  You can add classes
    // to this array, and they will be ignored when the hijacking is applied.
    nonHijackableClasses: [],


    // ## Pasting & Sanitizing
    //
    // When pasting content into Mercury it may sometimes contain HTML tags and attributes.  This markup is used to
    // style the content and makes the pasted content look (and behave) the same as the original content.  This can be a
    // desired feature or an annoyance, so you can enable various sanitizing methods to clean the content when it's
    // pasted.
    //
    // sanitize: Can be any of the following:
    // - false: no sanitizing is done, the content is pasted the exact same as it was copied by the user
    // - 'whitelist': content is cleaned using the settings specified in the tag white list (described below)
    // - 'text': all html is stripped before pasting, leaving only the raw text
    //
    // whitelist: The white list allows you to specify tags and attributes that are allowed when pasting content.  Each
    // item in this object should contain the allowed tag, and an array of attributes that are allowed on that tag.  If
    // the allowed attributes array is empty, all attributes will be removed.  If a tag is not present in this list, it
    // will be removed, but without removing any of the text or tags inside it.
    //
    // **Note:** Content is *always* sanitized if looks like it's from MS Word or similar editors regardless of this
    // configuration.
    pasting: {
      sanitize: 'whitelist',
      whitelist: {
        h1:     [],
        h2:     [],
        h3:     [],
        h4:     [],
        h5:     [],
        h6:     [],
        table:  [],
        thead:  [],
        tbody:  [],
        tfoot:  [],
        tr:     [],
        th:     ['colspan', 'rowspan'],
        td:     ['colspan', 'rowspan'],
        div:    ['class'],
        span:   ['class'],
        ul:     [],
        ol:     [],
        li:     [],
        b:      [],
        strong: [],
        i:      [],
        em:     [],
        u:      [],
        strike: [],
        br:     [],
        p:      [],
        hr:     [],
        a:      ['href', 'target', 'title', 'name'],
        img:    ['src', 'title', 'alt']
        }
      },


    // ## Injected Styles
    //
    // Mercury tries to stay as much out of your code as possible, but because regions appear within your document we
    // need to include a few styles to indicate regions, as well as the different states of them (eg. focused).  These
    // styles are injected into your document, and as simple as they might be, you may want to change them.
    injectedStyles: '' +
      '[data-mercury]       { min-height: 10px; outline: 1px dotted #09F } ' +
      '[data-mercury]:focus { outline: none; -webkit-box-shadow: 0 0 10px #09F, 0 0 1px #045; box-shadow: 0 0 10px #09F, 0 0 1px #045 }' +
      '[data-mercury].focus { outline: none; -webkit-box-shadow: 0 0 10px #09F, 0 0 1px #045; box-shadow: 0 0 10px #09F, 0 0 1px #045 }' +
      '[data-mercury]:after { content: "."; display: block; visibility: hidden; clear: both; height: 0; overflow: hidden; }' +
      '[data-mercury] table { border: 1px dotted red; min-width: 6px; }' +
      '[data-mercury] th    { border: 1px dotted red; min-width: 6px; }' +
      '[data-mercury] td    { border: 1px dotted red; min-width: 6px; }' +
      '[data-mercury] .mercury-textarea       { border: 0; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box; resize: none; }' +
      '[data-mercury] .mercury-textarea:focus { outline: none; -webkit-box-shadow: none; -moz-box-shadow: none; box-shadow: none; }'
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
