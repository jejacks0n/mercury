/*!
 * Mercury Editor is a CoffeeScript and jQuery based WYSIWYG editor.  Documentation and other useful information can be
 * found at https://github.com/jejacks0n/mercury
 *
 * Minimum jQuery requirements are 1.7

 *
 * You can include the Rails jQuery ujs script here to get some nicer behaviors in modals, panels and lightviews when
 * using :remote => true within the contents rendered in them.
 * require jquery_ujs
 *
 * Add any requires for the support libraries that integrate nicely with Mercury Editor.
 * require mercury/support/history
 *
 * Require Mercury Editor itself.

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
/*!
 * jQuery UI 1.8.13
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI
 */

(function(c,j){function k(a,b){var d=a.nodeName.toLowerCase();if("area"===d){b=a.parentNode;d=b.name;if(!a.href||!d||b.nodeName.toLowerCase()!=="map")return false;a=c("img[usemap=#"+d+"]")[0];return!!a&&l(a)}return(/input|select|textarea|button|object/.test(d)?!a.disabled:"a"==d?a.href||b:b)&&l(a)}function l(a){return!c(a).parents().andSelf().filter(function(){return c.curCSS(this,"visibility")==="hidden"||c.expr.filters.hidden(this)}).length}c.ui=c.ui||{};if(!c.ui.version){c.extend(c.ui,{version:"1.8.13",
keyCode:{ALT:18,BACKSPACE:8,CAPS_LOCK:20,COMMA:188,COMMAND:91,COMMAND_LEFT:91,COMMAND_RIGHT:93,CONTROL:17,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,INSERT:45,LEFT:37,MENU:93,NUMPAD_ADD:107,NUMPAD_DECIMAL:110,NUMPAD_DIVIDE:111,NUMPAD_ENTER:108,NUMPAD_MULTIPLY:106,NUMPAD_SUBTRACT:109,PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SHIFT:16,SPACE:32,TAB:9,UP:38,WINDOWS:91}});c.fn.extend({_focus:c.fn.focus,focus:function(a,b){return typeof a==="number"?this.each(function(){var d=this;setTimeout(function(){c(d).focus();
b&&b.call(d)},a)}):this._focus.apply(this,arguments)},scrollParent:function(){var a;a=c.browser.msie&&/(static|relative)/.test(this.css("position"))||/absolute/.test(this.css("position"))?this.parents().filter(function(){return/(relative|absolute|fixed)/.test(c.curCSS(this,"position",1))&&/(auto|scroll)/.test(c.curCSS(this,"overflow",1)+c.curCSS(this,"overflow-y",1)+c.curCSS(this,"overflow-x",1))}).eq(0):this.parents().filter(function(){return/(auto|scroll)/.test(c.curCSS(this,"overflow",1)+c.curCSS(this,
"overflow-y",1)+c.curCSS(this,"overflow-x",1))}).eq(0);return/fixed/.test(this.css("position"))||!a.length?c(document):a},zIndex:function(a){if(a!==j)return this.css("zIndex",a);if(this.length){a=c(this[0]);for(var b;a.length&&a[0]!==document;){b=a.css("position");if(b==="absolute"||b==="relative"||b==="fixed"){b=parseInt(a.css("zIndex"),10);if(!isNaN(b)&&b!==0)return b}a=a.parent()}}return 0},disableSelection:function(){return this.bind((c.support.selectstart?"selectstart":"mousedown")+".ui-disableSelection",
function(a){a.preventDefault()})},enableSelection:function(){return this.unbind(".ui-disableSelection")}});c.each(["Width","Height"],function(a,b){function d(f,g,m,n){c.each(e,function(){g-=parseFloat(c.curCSS(f,"padding"+this,true))||0;if(m)g-=parseFloat(c.curCSS(f,"border"+this+"Width",true))||0;if(n)g-=parseFloat(c.curCSS(f,"margin"+this,true))||0});return g}var e=b==="Width"?["Left","Right"]:["Top","Bottom"],h=b.toLowerCase(),i={innerWidth:c.fn.innerWidth,innerHeight:c.fn.innerHeight,outerWidth:c.fn.outerWidth,
outerHeight:c.fn.outerHeight};c.fn["inner"+b]=function(f){if(f===j)return i["inner"+b].call(this);return this.each(function(){c(this).css(h,d(this,f)+"px")})};c.fn["outer"+b]=function(f,g){if(typeof f!=="number")return i["outer"+b].call(this,f);return this.each(function(){c(this).css(h,d(this,f,true,g)+"px")})}});c.extend(c.expr[":"],{data:function(a,b,d){return!!c.data(a,d[3])},focusable:function(a){return k(a,!isNaN(c.attr(a,"tabindex")))},tabbable:function(a){var b=c.attr(a,"tabindex"),d=isNaN(b);
return(d||b>=0)&&k(a,!d)}});c(function(){var a=document.body,b=a.appendChild(b=document.createElement("div"));c.extend(b.style,{minHeight:"100px",height:"auto",padding:0,borderWidth:0});c.support.minHeight=b.offsetHeight===100;c.support.selectstart="onselectstart"in b;a.removeChild(b).style.display="none"});c.extend(c.ui,{plugin:{add:function(a,b,d){a=c.ui[a].prototype;for(var e in d){a.plugins[e]=a.plugins[e]||[];a.plugins[e].push([b,d[e]])}},call:function(a,b,d){if((b=a.plugins[b])&&a.element[0].parentNode)for(var e=
0;e<b.length;e++)a.options[b[e][0]]&&b[e][1].apply(a.element,d)}},contains:function(a,b){return document.compareDocumentPosition?a.compareDocumentPosition(b)&16:a!==b&&a.contains(b)},hasScroll:function(a,b){if(c(a).css("overflow")==="hidden")return false;b=b&&b==="left"?"scrollLeft":"scrollTop";var d=false;if(a[b]>0)return true;a[b]=1;d=a[b]>0;a[b]=0;return d},isOverAxis:function(a,b,d){return a>b&&a<b+d},isOver:function(a,b,d,e,h,i){return c.ui.isOverAxis(a,d,h)&&c.ui.isOverAxis(b,e,i)}})}})(jQuery);
;/*!
 * jQuery UI Widget 1.8.13
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Widget
 */
(function(b,j){if(b.cleanData){var k=b.cleanData;b.cleanData=function(a){for(var c=0,d;(d=a[c])!=null;c++)b(d).triggerHandler("remove");k(a)}}else{var l=b.fn.remove;b.fn.remove=function(a,c){return this.each(function(){if(!c)if(!a||b.filter(a,[this]).length)b("*",this).add([this]).each(function(){b(this).triggerHandler("remove")});return l.call(b(this),a,c)})}}b.widget=function(a,c,d){var e=a.split(".")[0],f;a=a.split(".")[1];f=e+"-"+a;if(!d){d=c;c=b.Widget}b.expr[":"][f]=function(h){return!!b.data(h,
a)};b[e]=b[e]||{};b[e][a]=function(h,g){arguments.length&&this._createWidget(h,g)};c=new c;c.options=b.extend(true,{},c.options);b[e][a].prototype=b.extend(true,c,{namespace:e,widgetName:a,widgetEventPrefix:b[e][a].prototype.widgetEventPrefix||a,widgetBaseClass:f},d);b.widget.bridge(a,b[e][a])};b.widget.bridge=function(a,c){b.fn[a]=function(d){var e=typeof d==="string",f=Array.prototype.slice.call(arguments,1),h=this;d=!e&&f.length?b.extend.apply(null,[true,d].concat(f)):d;if(e&&d.charAt(0)==="_")return h;
e?this.each(function(){var g=b.data(this,a),i=g&&b.isFunction(g[d])?g[d].apply(g,f):g;if(i!==g&&i!==j){h=i;return false}}):this.each(function(){var g=b.data(this,a);g?g.option(d||{})._init():b.data(this,a,new c(d,this))});return h}};b.Widget=function(a,c){arguments.length&&this._createWidget(a,c)};b.Widget.prototype={widgetName:"widget",widgetEventPrefix:"",options:{disabled:false},_createWidget:function(a,c){b.data(c,this.widgetName,this);this.element=b(c);this.options=b.extend(true,{},this.options,
this._getCreateOptions(),a);var d=this;this.element.bind("remove."+this.widgetName,function(){d.destroy()});this._create();this._trigger("create");this._init()},_getCreateOptions:function(){return b.metadata&&b.metadata.get(this.element[0])[this.widgetName]},_create:function(){},_init:function(){},destroy:function(){this.element.unbind("."+this.widgetName).removeData(this.widgetName);this.widget().unbind("."+this.widgetName).removeAttr("aria-disabled").removeClass(this.widgetBaseClass+"-disabled ui-state-disabled")},
widget:function(){return this.element},option:function(a,c){var d=a;if(arguments.length===0)return b.extend({},this.options);if(typeof a==="string"){if(c===j)return this.options[a];d={};d[a]=c}this._setOptions(d);return this},_setOptions:function(a){var c=this;b.each(a,function(d,e){c._setOption(d,e)});return this},_setOption:function(a,c){this.options[a]=c;if(a==="disabled")this.widget()[c?"addClass":"removeClass"](this.widgetBaseClass+"-disabled ui-state-disabled").attr("aria-disabled",c);return this},
enable:function(){return this._setOption("disabled",false)},disable:function(){return this._setOption("disabled",true)},_trigger:function(a,c,d){var e=this.options[a];c=b.Event(c);c.type=(a===this.widgetEventPrefix?a:this.widgetEventPrefix+a).toLowerCase();d=d||{};if(c.originalEvent){a=b.event.props.length;for(var f;a;){f=b.event.props[--a];c[f]=c.originalEvent[f]}}this.element.trigger(c,d);return!(b.isFunction(e)&&e.call(this.element[0],c,d)===false||c.isDefaultPrevented())}}})(jQuery);
;

/*!
 * jQuery UI Mouse 1.8.13
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Mouse
 *
 * Depends:
 *	jquery.ui.widget.js
 */
(function( $, undefined ) {

var mouseHandled = false;
$(document).mousedown(function(e) {
	mouseHandled = false;
});

$.widget("ui.mouse", {
	options: {
		cancel: ':input,option',
		distance: 1,
		delay: 0
	},
	_mouseInit: function() {
		var self = this;

		this.element
			.bind('mousedown.'+this.widgetName, function(event) {
				return self._mouseDown(event);
			})
			.bind('click.'+this.widgetName, function(event) {
				if (true === $.data(event.target, self.widgetName + '.preventClickEvent')) {
				    $.removeData(event.target, self.widgetName + '.preventClickEvent');
					event.stopImmediatePropagation();
					return false;
				}
			});

		this.started = false;
	},

	// TODO: make sure destroying one instance of mouse doesn't mess with
	// other instances of mouse
	_mouseDestroy: function() {
		this.element.unbind('.'+this.widgetName);
	},

	_mouseDown: function(event) {
		// don't let more than one widget handle mouseStart
    $(this.document || document).mousedown(function(e) {
      mouseHandled = false;
    });
		if(mouseHandled) {return};

		// we may have missed mouseup (out of window)
		(this._mouseStarted && this._mouseUp(event));

		this._mouseDownEvent = event;

		var self = this,
			btnIsLeft = (event.which == 1),
			elIsCancel = (typeof this.options.cancel == "string" ? $(event.target).parents().add(event.target).filter(this.options.cancel).length : false);
		if (!btnIsLeft || elIsCancel || !this._mouseCapture(event)) {
			return true;
		}

		this.mouseDelayMet = !this.options.delay;
		if (!this.mouseDelayMet) {
			this._mouseDelayTimer = setTimeout(function() {
				self.mouseDelayMet = true;
			}, this.options.delay);
		}

		if (this._mouseDistanceMet(event) && this._mouseDelayMet(event)) {
			this._mouseStarted = (this._mouseStart(event) !== false);
			if (!this._mouseStarted) {
				event.preventDefault();
				return true;
			}
		}

		// Click event may never have fired (Gecko & Opera)
		if (true === $.data(event.target, this.widgetName + '.preventClickEvent')) {
			$.removeData(event.target, this.widgetName + '.preventClickEvent');
		}

		// these delegates are required to keep context
		this._mouseMoveDelegate = function(event) {
			return self._mouseMove(event);
		};
		this._mouseUpDelegate = function(event) {
			return self._mouseUp(event);
		};
		$(this.document || document)
			.bind('mousemove.'+this.widgetName, this._mouseMoveDelegate)
			.bind('mouseup.'+this.widgetName, this._mouseUpDelegate);

		event.preventDefault();

		mouseHandled = true;
		return true;
	},

	_mouseMove: function(event) {
		// IE mouseup check - mouseup happened when mouse was out of window
		if ($.browser.msie && !((this.document || document).documentMode >= 9) && !event.button) {
			return this._mouseUp(event);
		}

		if (this._mouseStarted) {
			this._mouseDrag(event);
			return event.preventDefault();
		}

		if (this._mouseDistanceMet(event) && this._mouseDelayMet(event)) {
			this._mouseStarted =
				(this._mouseStart(this._mouseDownEvent, event) !== false);
			(this._mouseStarted ? this._mouseDrag(event) : this._mouseUp(event));
		}

		return !this._mouseStarted;
	},

	_mouseUp: function(event) {
		$(this.document || document)
			.unbind('mousemove.'+this.widgetName, this._mouseMoveDelegate)
			.unbind('mouseup.'+this.widgetName, this._mouseUpDelegate);

		if (this._mouseStarted) {
			this._mouseStarted = false;

			if (event.target == this._mouseDownEvent.target) {
			    $.data(event.target, this.widgetName + '.preventClickEvent', true);
			}

			this._mouseStop(event);
		}

		return false;
	},

	_mouseDistanceMet: function(event) {
		return (Math.max(
				Math.abs(this._mouseDownEvent.pageX - event.pageX),
				Math.abs(this._mouseDownEvent.pageY - event.pageY)
			) >= this.options.distance
		);
	},

	_mouseDelayMet: function(event) {
		return this.mouseDelayMet;
	},

	// These are placeholder methods, to be overriden by extending plugin
	_mouseStart: function(event) {},
	_mouseDrag: function(event) {},
	_mouseStop: function(event) {},
	_mouseCapture: function(event) { return true; }
});

})(jQuery);

/*
 * jQuery UI Draggable 1.8.13
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Draggables
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.mouse.js
 *	jquery.ui.widget.js
 */
(function(d){d.widget("ui.draggable",d.ui.mouse,{widgetEventPrefix:"drag",options:{addClasses:true,appendTo:"parent",axis:false,connectToSortable:false,containment:false,cursor:"auto",cursorAt:false,grid:false,handle:false,helper:"original",iframeFix:false,opacity:false,refreshPositions:false,revert:false,revertDuration:500,scope:"default",scroll:true,scrollSensitivity:20,scrollSpeed:20,snap:false,snapMode:"both",snapTolerance:20,stack:false,zIndex:false},_create:function(){if(this.options.helper==
"original"&&!/^(?:r|a|f)/.test(this.element.css("position")))this.element[0].style.position="relative";this.options.addClasses&&this.element.addClass("ui-draggable");this.options.disabled&&this.element.addClass("ui-draggable-disabled");this._mouseInit()},destroy:function(){if(this.element.data("draggable")){this.element.removeData("draggable").unbind(".draggable").removeClass("ui-draggable ui-draggable-dragging ui-draggable-disabled");this._mouseDestroy();return this}},_mouseCapture:function(a){var b=
this.options;if(this.helper||b.disabled||d(a.target).is(".ui-resizable-handle"))return false;this.handle=this._getHandle(a);if(!this.handle)return false;d(b.iframeFix===true?"iframe":b.iframeFix).each(function(){d('<div class="ui-draggable-iframeFix" style="background: #fff;"></div>').css({width:this.offsetWidth+"px",height:this.offsetHeight+"px",position:"absolute",opacity:"0.001",zIndex:1E3}).css(d(this).offset()).appendTo("body")});return true},_mouseStart:function(a){var b=this.options;this.helper=
this._createHelper(a);this._cacheHelperProportions();if(d.ui.ddmanager)d.ui.ddmanager.current=this;this._cacheMargins();this.cssPosition=this.helper.css("position");this.scrollParent=this.helper.scrollParent();this.offset=this.positionAbs=this.element.offset();this.offset={top:this.offset.top-this.margins.top,left:this.offset.left-this.margins.left};d.extend(this.offset,{click:{left:a.pageX-this.offset.left,top:a.pageY-this.offset.top},parent:this._getParentOffset(),relative:this._getRelativeOffset()});
this.originalPosition=this.position=this._generatePosition(a);this.originalPageX=a.pageX;this.originalPageY=a.pageY;b.cursorAt&&this._adjustOffsetFromHelper(b.cursorAt);b.containment&&this._setContainment();if(this._trigger("start",a)===false){this._clear();return false}this._cacheHelperProportions();d.ui.ddmanager&&!b.dropBehaviour&&d.ui.ddmanager.prepareOffsets(this,a);this.helper.addClass("ui-draggable-dragging");this._mouseDrag(a,true);return true},_mouseDrag:function(a,b){this.position=this._generatePosition(a);
this.positionAbs=this._convertPositionTo("absolute");if(!b){b=this._uiHash();if(this._trigger("drag",a,b)===false){this._mouseUp({});return false}this.position=b.position}if(!this.options.axis||this.options.axis!="y")this.helper[0].style.left=this.position.left+"px";if(!this.options.axis||this.options.axis!="x")this.helper[0].style.top=this.position.top+"px";d.ui.ddmanager&&d.ui.ddmanager.drag(this,a);return false},_mouseStop:function(a){var b=false;if(d.ui.ddmanager&&!this.options.dropBehaviour)b=
d.ui.ddmanager.drop(this,a);if(this.dropped){b=this.dropped;this.dropped=false}if((!this.element[0]||!this.element[0].parentNode)&&this.options.helper=="original")return false;if(this.options.revert=="invalid"&&!b||this.options.revert=="valid"&&b||this.options.revert===true||d.isFunction(this.options.revert)&&this.options.revert.call(this.element,b)){var c=this;d(this.helper).animate(this.originalPosition,parseInt(this.options.revertDuration,10),function(){c._trigger("stop",a)!==false&&c._clear()})}else this._trigger("stop",
a)!==false&&this._clear();return false},_mouseUp:function(a){this.options.iframeFix===true&&d("div.ui-draggable-iframeFix").each(function(){this.parentNode.removeChild(this)});return d.ui.mouse.prototype._mouseUp.call(this,a)},cancel:function(){this.helper.is(".ui-draggable-dragging")?this._mouseUp({}):this._clear();return this},_getHandle:function(a){var b=!this.options.handle||!d(this.options.handle,this.element).length?true:false;d(this.options.handle,this.element).find("*").andSelf().each(function(){if(this==
a.target)b=true});return b},_createHelper:function(a){var b=this.options;a=d.isFunction(b.helper)?d(b.helper.apply(this.element[0],[a])):b.helper=="clone"?this.element.clone().removeAttr("id"):this.element;a.parents("body").length||a.appendTo(b.appendTo=="parent"?this.element[0].parentNode:b.appendTo);a[0]!=this.element[0]&&!/(fixed|absolute)/.test(a.css("position"))&&a.css("position","absolute");return a},_adjustOffsetFromHelper:function(a){if(typeof a=="string")a=a.split(" ");if(d.isArray(a))a=
{left:+a[0],top:+a[1]||0};if("left"in a)this.offset.click.left=a.left+this.margins.left;if("right"in a)this.offset.click.left=this.helperProportions.width-a.right+this.margins.left;if("top"in a)this.offset.click.top=a.top+this.margins.top;if("bottom"in a)this.offset.click.top=this.helperProportions.height-a.bottom+this.margins.top},_getParentOffset:function(){this.offsetParent=this.helper.offsetParent();var a=this.offsetParent.offset();if(this.cssPosition=="absolute"&&this.scrollParent[0]!=document&&
d.ui.contains(this.scrollParent[0],this.offsetParent[0])){a.left+=this.scrollParent.scrollLeft();a.top+=this.scrollParent.scrollTop()}if(this.offsetParent[0]==document.body||this.offsetParent[0].tagName&&this.offsetParent[0].tagName.toLowerCase()=="html"&&d.browser.msie)a={top:0,left:0};return{top:a.top+(parseInt(this.offsetParent.css("borderTopWidth"),10)||0),left:a.left+(parseInt(this.offsetParent.css("borderLeftWidth"),10)||0)}},_getRelativeOffset:function(){if(this.cssPosition=="relative"){var a=
this.element.position();return{top:a.top-(parseInt(this.helper.css("top"),10)||0)+this.scrollParent.scrollTop(),left:a.left-(parseInt(this.helper.css("left"),10)||0)+this.scrollParent.scrollLeft()}}else return{top:0,left:0}},_cacheMargins:function(){this.margins={left:parseInt(this.element.css("marginLeft"),10)||0,top:parseInt(this.element.css("marginTop"),10)||0,right:parseInt(this.element.css("marginRight"),10)||0,bottom:parseInt(this.element.css("marginBottom"),10)||0}},_cacheHelperProportions:function(){this.helperProportions=
{width:this.helper.outerWidth(),height:this.helper.outerHeight()}},_setContainment:function(){var a=this.options;if(a.containment=="parent")a.containment=this.helper[0].parentNode;if(a.containment=="document"||a.containment=="window")this.containment=[(a.containment=="document"?0:d(window).scrollLeft())-this.offset.relative.left-this.offset.parent.left,(a.containment=="document"?0:d(window).scrollTop())-this.offset.relative.top-this.offset.parent.top,(a.containment=="document"?0:d(window).scrollLeft())+
d(a.containment=="document"?document:window).width()-this.helperProportions.width-this.margins.left,(a.containment=="document"?0:d(window).scrollTop())+(d(a.containment=="document"?document:window).height()||document.body.parentNode.scrollHeight)-this.helperProportions.height-this.margins.top];if(!/^(document|window|parent)$/.test(a.containment)&&a.containment.constructor!=Array){a=d(a.containment);var b=a[0];if(b){a.offset();var c=d(b).css("overflow")!="hidden";this.containment=[(parseInt(d(b).css("borderLeftWidth"),
10)||0)+(parseInt(d(b).css("paddingLeft"),10)||0),(parseInt(d(b).css("borderTopWidth"),10)||0)+(parseInt(d(b).css("paddingTop"),10)||0),(c?Math.max(b.scrollWidth,b.offsetWidth):b.offsetWidth)-(parseInt(d(b).css("borderLeftWidth"),10)||0)-(parseInt(d(b).css("paddingRight"),10)||0)-this.helperProportions.width-this.margins.left-this.margins.right,(c?Math.max(b.scrollHeight,b.offsetHeight):b.offsetHeight)-(parseInt(d(b).css("borderTopWidth"),10)||0)-(parseInt(d(b).css("paddingBottom"),10)||0)-this.helperProportions.height-
this.margins.top-this.margins.bottom];this.relative_container=a}}else if(a.containment.constructor==Array)this.containment=a.containment},_convertPositionTo:function(a,b){if(!b)b=this.position;a=a=="absolute"?1:-1;var c=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,f=/(html|body)/i.test(c[0].tagName);return{top:b.top+this.offset.relative.top*a+this.offset.parent.top*a-(d.browser.safari&&
d.browser.version<526&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollTop():f?0:c.scrollTop())*a),left:b.left+this.offset.relative.left*a+this.offset.parent.left*a-(d.browser.safari&&d.browser.version<526&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():f?0:c.scrollLeft())*a)}},_generatePosition:function(a){var b=this.options,c=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],
this.offsetParent[0]))?this.offsetParent:this.scrollParent,f=/(html|body)/i.test(c[0].tagName),e=a.pageX,h=a.pageY;if(this.originalPosition){var g;if(this.containment){if(this.relative_container){g=this.relative_container.offset();g=[this.containment[0]+g.left,this.containment[1]+g.top,this.containment[2]+g.left,this.containment[3]+g.top]}else g=this.containment;if(a.pageX-this.offset.click.left<g[0])e=g[0]+this.offset.click.left;if(a.pageY-this.offset.click.top<g[1])h=g[1]+this.offset.click.top;
if(a.pageX-this.offset.click.left>g[2])e=g[2]+this.offset.click.left;if(a.pageY-this.offset.click.top>g[3])h=g[3]+this.offset.click.top}if(b.grid){h=this.originalPageY+Math.round((h-this.originalPageY)/b.grid[1])*b.grid[1];h=g?!(h-this.offset.click.top<g[1]||h-this.offset.click.top>g[3])?h:!(h-this.offset.click.top<g[1])?h-b.grid[1]:h+b.grid[1]:h;e=this.originalPageX+Math.round((e-this.originalPageX)/b.grid[0])*b.grid[0];e=g?!(e-this.offset.click.left<g[0]||e-this.offset.click.left>g[2])?e:!(e-this.offset.click.left<
g[0])?e-b.grid[0]:e+b.grid[0]:e}}return{top:h-this.offset.click.top-this.offset.relative.top-this.offset.parent.top+(d.browser.safari&&d.browser.version<526&&this.cssPosition=="fixed"?0:this.cssPosition=="fixed"?-this.scrollParent.scrollTop():f?0:c.scrollTop()),left:e-this.offset.click.left-this.offset.relative.left-this.offset.parent.left+(d.browser.safari&&d.browser.version<526&&this.cssPosition=="fixed"?0:this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():f?0:c.scrollLeft())}},_clear:function(){this.helper.removeClass("ui-draggable-dragging");
this.helper[0]!=this.element[0]&&!this.cancelHelperRemoval&&this.helper.remove();this.helper=null;this.cancelHelperRemoval=false},_trigger:function(a,b,c){c=c||this._uiHash();d.ui.plugin.call(this,a,[b,c]);if(a=="drag")this.positionAbs=this._convertPositionTo("absolute");return d.Widget.prototype._trigger.call(this,a,b,c)},plugins:{},_uiHash:function(){return{helper:this.helper,position:this.position,originalPosition:this.originalPosition,offset:this.positionAbs}}});d.extend(d.ui.draggable,{version:"1.8.13"});
d.ui.plugin.add("draggable","connectToSortable",{start:function(a,b){var c=d(this).data("draggable"),f=c.options,e=d.extend({},b,{item:c.element});c.sortables=[];d(f.connectToSortable).each(function(){var h=d.data(this,"sortable");if(h&&!h.options.disabled){c.sortables.push({instance:h,shouldRevert:h.options.revert});h.refreshPositions();h._trigger("activate",a,e)}})},stop:function(a,b){var c=d(this).data("draggable"),f=d.extend({},b,{item:c.element});d.each(c.sortables,function(){if(this.instance.isOver){this.instance.isOver=
0;c.cancelHelperRemoval=true;this.instance.cancelHelperRemoval=false;if(this.shouldRevert)this.instance.options.revert=true;this.instance._mouseStop(a);this.instance.options.helper=this.instance.options._helper;c.options.helper=="original"&&this.instance.currentItem.css({top:"auto",left:"auto"})}else{this.instance.cancelHelperRemoval=false;this.instance._trigger("deactivate",a,f)}})},drag:function(a,b){var c=d(this).data("draggable"),f=this;d.each(c.sortables,function(){this.instance.positionAbs=
c.positionAbs;this.instance.helperProportions=c.helperProportions;this.instance.offset.click=c.offset.click;if(this.instance._intersectsWith(this.instance.containerCache)){if(!this.instance.isOver){this.instance.isOver=1;this.instance.currentItem=d(f).clone().removeAttr("id").appendTo(this.instance.element).data("sortable-item",true);this.instance.options._helper=this.instance.options.helper;this.instance.options.helper=function(){return b.helper[0]};a.target=this.instance.currentItem[0];this.instance._mouseCapture(a,
true);this.instance._mouseStart(a,true,true);this.instance.offset.click.top=c.offset.click.top;this.instance.offset.click.left=c.offset.click.left;this.instance.offset.parent.left-=c.offset.parent.left-this.instance.offset.parent.left;this.instance.offset.parent.top-=c.offset.parent.top-this.instance.offset.parent.top;c._trigger("toSortable",a);c.dropped=this.instance.element;c.currentItem=c.element;this.instance.fromOutside=c}this.instance.currentItem&&this.instance._mouseDrag(a)}else if(this.instance.isOver){this.instance.isOver=
0;this.instance.cancelHelperRemoval=true;this.instance.options.revert=false;this.instance._trigger("out",a,this.instance._uiHash(this.instance));this.instance._mouseStop(a,true);this.instance.options.helper=this.instance.options._helper;this.instance.currentItem.remove();this.instance.placeholder&&this.instance.placeholder.remove();c._trigger("fromSortable",a);c.dropped=false}})}});d.ui.plugin.add("draggable","cursor",{start:function(){var a=d("body"),b=d(this).data("draggable").options;if(a.css("cursor"))b._cursor=
a.css("cursor");a.css("cursor",b.cursor)},stop:function(){var a=d(this).data("draggable").options;a._cursor&&d("body").css("cursor",a._cursor)}});d.ui.plugin.add("draggable","opacity",{start:function(a,b){a=d(b.helper);b=d(this).data("draggable").options;if(a.css("opacity"))b._opacity=a.css("opacity");a.css("opacity",b.opacity)},stop:function(a,b){a=d(this).data("draggable").options;a._opacity&&d(b.helper).css("opacity",a._opacity)}});d.ui.plugin.add("draggable","scroll",{start:function(){var a=d(this).data("draggable");
if(a.scrollParent[0]!=document&&a.scrollParent[0].tagName!="HTML")a.overflowOffset=a.scrollParent.offset()},drag:function(a){var b=d(this).data("draggable"),c=b.options,f=false;if(b.scrollParent[0]!=document&&b.scrollParent[0].tagName!="HTML"){if(!c.axis||c.axis!="x")if(b.overflowOffset.top+b.scrollParent[0].offsetHeight-a.pageY<c.scrollSensitivity)b.scrollParent[0].scrollTop=f=b.scrollParent[0].scrollTop+c.scrollSpeed;else if(a.pageY-b.overflowOffset.top<c.scrollSensitivity)b.scrollParent[0].scrollTop=
f=b.scrollParent[0].scrollTop-c.scrollSpeed;if(!c.axis||c.axis!="y")if(b.overflowOffset.left+b.scrollParent[0].offsetWidth-a.pageX<c.scrollSensitivity)b.scrollParent[0].scrollLeft=f=b.scrollParent[0].scrollLeft+c.scrollSpeed;else if(a.pageX-b.overflowOffset.left<c.scrollSensitivity)b.scrollParent[0].scrollLeft=f=b.scrollParent[0].scrollLeft-c.scrollSpeed}else{if(!c.axis||c.axis!="x")if(a.pageY-d(document).scrollTop()<c.scrollSensitivity)f=d(document).scrollTop(d(document).scrollTop()-c.scrollSpeed);
else if(d(window).height()-(a.pageY-d(document).scrollTop())<c.scrollSensitivity)f=d(document).scrollTop(d(document).scrollTop()+c.scrollSpeed);if(!c.axis||c.axis!="y")if(a.pageX-d(document).scrollLeft()<c.scrollSensitivity)f=d(document).scrollLeft(d(document).scrollLeft()-c.scrollSpeed);else if(d(window).width()-(a.pageX-d(document).scrollLeft())<c.scrollSensitivity)f=d(document).scrollLeft(d(document).scrollLeft()+c.scrollSpeed)}f!==false&&d.ui.ddmanager&&!c.dropBehaviour&&d.ui.ddmanager.prepareOffsets(b,
a)}});d.ui.plugin.add("draggable","snap",{start:function(){var a=d(this).data("draggable"),b=a.options;a.snapElements=[];d(b.snap.constructor!=String?b.snap.items||":data(draggable)":b.snap).each(function(){var c=d(this),f=c.offset();this!=a.element[0]&&a.snapElements.push({item:this,width:c.outerWidth(),height:c.outerHeight(),top:f.top,left:f.left})})},drag:function(a,b){for(var c=d(this).data("draggable"),f=c.options,e=f.snapTolerance,h=b.offset.left,g=h+c.helperProportions.width,n=b.offset.top,
o=n+c.helperProportions.height,i=c.snapElements.length-1;i>=0;i--){var j=c.snapElements[i].left,l=j+c.snapElements[i].width,k=c.snapElements[i].top,m=k+c.snapElements[i].height;if(j-e<h&&h<l+e&&k-e<n&&n<m+e||j-e<h&&h<l+e&&k-e<o&&o<m+e||j-e<g&&g<l+e&&k-e<n&&n<m+e||j-e<g&&g<l+e&&k-e<o&&o<m+e){if(f.snapMode!="inner"){var p=Math.abs(k-o)<=e,q=Math.abs(m-n)<=e,r=Math.abs(j-g)<=e,s=Math.abs(l-h)<=e;if(p)b.position.top=c._convertPositionTo("relative",{top:k-c.helperProportions.height,left:0}).top-c.margins.top;
if(q)b.position.top=c._convertPositionTo("relative",{top:m,left:0}).top-c.margins.top;if(r)b.position.left=c._convertPositionTo("relative",{top:0,left:j-c.helperProportions.width}).left-c.margins.left;if(s)b.position.left=c._convertPositionTo("relative",{top:0,left:l}).left-c.margins.left}var t=p||q||r||s;if(f.snapMode!="outer"){p=Math.abs(k-n)<=e;q=Math.abs(m-o)<=e;r=Math.abs(j-h)<=e;s=Math.abs(l-g)<=e;if(p)b.position.top=c._convertPositionTo("relative",{top:k,left:0}).top-c.margins.top;if(q)b.position.top=
c._convertPositionTo("relative",{top:m-c.helperProportions.height,left:0}).top-c.margins.top;if(r)b.position.left=c._convertPositionTo("relative",{top:0,left:j}).left-c.margins.left;if(s)b.position.left=c._convertPositionTo("relative",{top:0,left:l-c.helperProportions.width}).left-c.margins.left}if(!c.snapElements[i].snapping&&(p||q||r||s||t))c.options.snap.snap&&c.options.snap.snap.call(c.element,a,d.extend(c._uiHash(),{snapItem:c.snapElements[i].item}));c.snapElements[i].snapping=p||q||r||s||t}else{c.snapElements[i].snapping&&
c.options.snap.release&&c.options.snap.release.call(c.element,a,d.extend(c._uiHash(),{snapItem:c.snapElements[i].item}));c.snapElements[i].snapping=false}}}});d.ui.plugin.add("draggable","stack",{start:function(){var a=d(this).data("draggable").options;a=d.makeArray(d(a.stack)).sort(function(c,f){return(parseInt(d(c).css("zIndex"),10)||0)-(parseInt(d(f).css("zIndex"),10)||0)});if(a.length){var b=parseInt(a[0].style.zIndex)||0;d(a).each(function(c){this.style.zIndex=b+c});this[0].style.zIndex=b+a.length}}});
d.ui.plugin.add("draggable","zIndex",{start:function(a,b){a=d(b.helper);b=d(this).data("draggable").options;if(a.css("zIndex"))b._zIndex=a.css("zIndex");a.css("zIndex",b.zIndex)},stop:function(a,b){a=d(this).data("draggable").options;a._zIndex&&d(b.helper).css("zIndex",a._zIndex)}})})(jQuery);
;

/*
 * jQuery UI Sortable 1.8.13
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Sortables
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.mouse.js
 *	jquery.ui.widget.js
 */
(function( $, undefined ) {

$.widget("ui.sortable", $.ui.mouse, {
	widgetEventPrefix: "sort",
	options: {
		appendTo: "parent",
		axis: false,
		connectWith: false,
		containment: false,
		cursor: 'auto',
		cursorAt: false,
		dropOnEmpty: true,
		forcePlaceholderSize: false,
		forceHelperSize: false,
		grid: false,
		handle: false,
		helper: "original",
		items: '> *',
		opacity: false,
		placeholder: false,
		revert: false,
		scroll: true,
		scrollSensitivity: 20,
		scrollSpeed: 20,
		scope: "default",
		tolerance: "intersect",
		zIndex: 1000
	},
	_create: function() {

		var o = this.options;
    this.document = o.document;

		this.containerCache = {};
		this.element.addClass("ui-sortable");

		//Get the items
		this.refresh();

		//Let's determine if the items are being displayed horizontally
		this.floating = this.items.length ? o.axis === 'x' || (/left|right/).test(this.items[0].item.css('float')) || (/inline|table-cell/).test(this.items[0].item.css('display')) : false;

		//Let's determine the parent's offset
		this.offset = this.element.offset();

		//Initialize mouse events for interaction
		this._mouseInit();

	},

	destroy: function() {
		this.element
			.removeClass("ui-sortable ui-sortable-disabled")
			.removeData("sortable")
			.unbind(".sortable");
		this._mouseDestroy();

		for ( var i = this.items.length - 1; i >= 0; i-- )
			this.items[i].item.removeData("sortable-item");

		return this;
	},

	_setOption: function(key, value){
		if ( key === "disabled" ) {
			this.options[ key ] = value;

			this.widget()
				[ value ? "addClass" : "removeClass"]( "ui-sortable-disabled" );
		} else {
			// Don't call widget base _setOption for disable as it adds ui-state-disabled class
			$.Widget.prototype._setOption.apply(this, arguments);
		}
	},

	_mouseCapture: function(event, overrideHandle) {

		if (this.reverting) {
			return false;
		}

		if(this.options.disabled || this.options.type == 'static') return false;

		//We have to refresh the items data once first
		this._refreshItems(event);

		//Find out if the clicked node (or one of its parents) is a actual item in this.items
		var currentItem = null, self = this, nodes = $(event.target).parents().each(function() {
			if($.data(this, 'sortable-item') == self) {
				currentItem = $(this);
				return false;
			}
		});
		if($.data(event.target, 'sortable-item') == self) currentItem = $(event.target);

		if(!currentItem) return false;
		if(this.options.handle && !overrideHandle) {
			var validHandle = false;

			$(this.options.handle, currentItem).find("*").andSelf().each(function() { if(this == event.target) validHandle = true; });
			if(!validHandle) return false;
		}

		this.currentItem = currentItem;
		this._removeCurrentsFromItems();
		return true;

	},

	_mouseStart: function(event, overrideHandle, noActivation) {
		var o = this.options, self = this;
		this.currentContainer = this;

		//We only need to call refreshPositions, because the refreshItems call has been moved to mouseCapture
		this.refreshPositions();

		//Create and append the visible helper
		this.helper = this._createHelper(event);

		//Cache the helper size
		this._cacheHelperProportions();

		/*
		 * - Position generation -
		 * This block generates everything position related - it's the core of draggables.
		 */

		//Cache the margins of the original element
		this._cacheMargins();

		//Get the next scrolling parent
		this.scrollParent = this.helper.scrollParent();

		//The element's absolute position on the page minus margins
		this.offset = this.currentItem.offset();
		this.offset = {
			top: this.offset.top - this.margins.top,
			left: this.offset.left - this.margins.left
		};

		// Only after we got the offset, we can change the helper's position to absolute
		// TODO: Still need to figure out a way to make relative sorting possible
		this.helper.css("position", "absolute");
		this.cssPosition = this.helper.css("position");

		$.extend(this.offset, {
			click: { //Where the click happened, relative to the element
				left: event.pageX - this.offset.left,
				top: event.pageY - this.offset.top
			},
			parent: this._getParentOffset(),
			relative: this._getRelativeOffset() //This is a relative to absolute position minus the actual position calculation - only used for relative positioned helper
		});

		//Generate the original position
		this.originalPosition = this._generatePosition(event);
		this.originalPageX = event.pageX;
		this.originalPageY = event.pageY;

		//Adjust the mouse offset relative to the helper if 'cursorAt' is supplied
		(o.cursorAt && this._adjustOffsetFromHelper(o.cursorAt));

		//Cache the former DOM position
		this.domPosition = { prev: this.currentItem.prev()[0], parent: this.currentItem.parent()[0] };

		//If the helper is not the original, hide the original so it's not playing any role during the drag, won't cause anything bad this way
		if(this.helper[0] != this.currentItem[0]) {
			this.currentItem.hide();
		}

		//Create the placeholder
		this._createPlaceholder();

		//Set a containment if given in the options
		if(o.containment)
			this._setContainment();

		if(o.cursor) { // cursor option
			if ($('body').css("cursor")) this._storedCursor = $('body').css("cursor");
			$('body').css("cursor", o.cursor);
		}

		if(o.opacity) { // opacity option
			if (this.helper.css("opacity")) this._storedOpacity = this.helper.css("opacity");
			this.helper.css("opacity", o.opacity);
		}

		if(o.zIndex) { // zIndex option
			if (this.helper.css("zIndex")) this._storedZIndex = this.helper.css("zIndex");
			this.helper.css("zIndex", o.zIndex);
		}

		//Prepare scrolling
		if(this.scrollParent[0] != (this.document || document) && this.scrollParent[0].tagName != 'HTML')
			this.overflowOffset = this.scrollParent.offset();

		//Call callbacks
		this._trigger("start", event, this._uiHash());

		//Recache the helper size
		if(!this._preserveHelperProportions)
			this._cacheHelperProportions();


		//Post 'activate' events to possible containers
		if(!noActivation) {
			 for (var i = this.containers.length - 1; i >= 0; i--) { this.containers[i]._trigger("activate", event, self._uiHash(this)); }
		}

		//Prepare possible droppables
		if($.ui.ddmanager)
			$.ui.ddmanager.current = this;

		if ($.ui.ddmanager && !o.dropBehaviour)
			$.ui.ddmanager.prepareOffsets(this, event);

		this.dragging = true;

		this.helper.addClass("ui-sortable-helper");
		this._mouseDrag(event); //Execute the drag once - this causes the helper not to be visible before getting its correct position
		return true;

	},

	_mouseDrag: function(event) {

		//Compute the helpers position
		this.position = this._generatePosition(event);
		this.positionAbs = this._convertPositionTo("absolute");

		if (!this.lastPositionAbs) {
			this.lastPositionAbs = this.positionAbs;
		}

		//Do scrolling
		if(this.options.scroll) {
			var o = this.options, scrolled = false;
			if(this.scrollParent[0] != (this.document || document) && this.scrollParent[0].tagName != 'HTML') {

				if((this.overflowOffset.top + this.scrollParent[0].offsetHeight) - event.pageY < o.scrollSensitivity)
					this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop + o.scrollSpeed;
				else if(event.pageY - this.overflowOffset.top < o.scrollSensitivity)
					this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop - o.scrollSpeed;

				if((this.overflowOffset.left + this.scrollParent[0].offsetWidth) - event.pageX < o.scrollSensitivity)
					this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft + o.scrollSpeed;
				else if(event.pageX - this.overflowOffset.left < o.scrollSensitivity)
					this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft - o.scrollSpeed;

			} else {

				if(event.pageY - $((this.document || document)).scrollTop() < o.scrollSensitivity)
					scrolled = $((this.document || document)).scrollTop($((this.document || document)).scrollTop() - o.scrollSpeed);
				else if($(window).height() - (event.pageY - $((this.document || document)).scrollTop()) < o.scrollSensitivity)
					scrolled = $((this.document || document)).scrollTop($((this.document || document)).scrollTop() + o.scrollSpeed);

				if(event.pageX - $((this.document || document)).scrollLeft() < o.scrollSensitivity)
					scrolled = $((this.document || document)).scrollLeft($((this.document || document)).scrollLeft() - o.scrollSpeed);
				else if($(window).width() - (event.pageX - $((this.document || document)).scrollLeft()) < o.scrollSensitivity)
					scrolled = $((this.document || document)).scrollLeft($((this.document || document)).scrollLeft() + o.scrollSpeed);

			}

			if(scrolled !== false && $.ui.ddmanager && !o.dropBehaviour)
				$.ui.ddmanager.prepareOffsets(this, event);
		}

		//Regenerate the absolute position used for position checks
		this.positionAbs = this._convertPositionTo("absolute");

		//Set the helper position
		if(!this.options.axis || this.options.axis != "y") this.helper[0].style.left = this.position.left+'px';
		if(!this.options.axis || this.options.axis != "x") this.helper[0].style.top = this.position.top+'px';

		//Rearrange
		for (var i = this.items.length - 1; i >= 0; i--) {

			//Cache variables and intersection, continue if no intersection
			var item = this.items[i], itemElement = item.item[0], intersection = this._intersectsWithPointer(item);
			if (!intersection) continue;

			if(itemElement != this.currentItem[0] //cannot intersect with itself
				&&	this.placeholder[intersection == 1 ? "next" : "prev"]()[0] != itemElement //no useless actions that have been done before
				&&	!$.ui.contains(this.placeholder[0], itemElement) //no action if the item moved is the parent of the item checked
				&& (this.options.type == 'semi-dynamic' ? !$.ui.contains(this.element[0], itemElement) : true)
				//&& itemElement.parentNode == this.placeholder[0].parentNode // only rearrange items within the same container
			) {

				this.direction = intersection == 1 ? "down" : "up";

				if (this.options.tolerance == "pointer" || this._intersectsWithSides(item)) {
					this._rearrange(event, item);
				} else {
					break;
				}

				this._trigger("change", event, this._uiHash());
				break;
			}
		}

		//Post events to containers
		this._contactContainers(event);

		//Interconnect with droppables
		if($.ui.ddmanager) $.ui.ddmanager.drag(this, event);

		//Call callbacks
		this._trigger('sort', event, this._uiHash());

		this.lastPositionAbs = this.positionAbs;
		return false;

	},

	_mouseStop: function(event, noPropagation) {

		if(!event) return;

		//If we are using droppables, inform the manager about the drop
		if ($.ui.ddmanager && !this.options.dropBehaviour)
			$.ui.ddmanager.drop(this, event);

		if(this.options.revert) {
			var self = this;
			var cur = self.placeholder.offset();

			self.reverting = true;

			$(this.helper).animate({
				left: cur.left - this.offset.parent.left - self.margins.left + (this.offsetParent[0] == (this.document || document).body ? 0 : this.offsetParent[0].scrollLeft),
				top: cur.top - this.offset.parent.top - self.margins.top + (this.offsetParent[0] == (this.document || document).body ? 0 : this.offsetParent[0].scrollTop)
			}, parseInt(this.options.revert, 10) || 500, function() {
				self._clear(event);
			});
		} else {
			this._clear(event, noPropagation);
		}

		return false;

	},

	cancel: function() {

		var self = this;

		if(this.dragging) {

			this._mouseUp({ target: null });

			if(this.options.helper == "original")
				this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper");
			else
				this.currentItem.show();

			//Post deactivating events to containers
			for (var i = this.containers.length - 1; i >= 0; i--){
				this.containers[i]._trigger("deactivate", null, self._uiHash(this));
				if(this.containers[i].containerCache.over) {
					this.containers[i]._trigger("out", null, self._uiHash(this));
					this.containers[i].containerCache.over = 0;
				}
			}

		}

		if (this.placeholder) {
			//$(this.placeholder[0]).remove(); would have been the jQuery way - unfortunately, it unbinds ALL events from the original node!
			if(this.placeholder[0].parentNode) this.placeholder[0].parentNode.removeChild(this.placeholder[0]);
			if(this.options.helper != "original" && this.helper && this.helper[0].parentNode) this.helper.remove();

			$.extend(this, {
				helper: null,
				dragging: false,
				reverting: false,
				_noFinalSort: null
			});

			if(this.domPosition.prev) {
				$(this.domPosition.prev).after(this.currentItem);
			} else {
				$(this.domPosition.parent).prepend(this.currentItem);
			}
		}

		return this;

	},

	serialize: function(o) {

		var items = this._getItemsAsjQuery(o && o.connected);
		var str = []; o = o || {};

		$(items).each(function() {
			var res = ($(o.item || this).attr(o.attribute || 'id') || '').match(o.expression || (/(.+)[-=_](.+)/));
			if(res) str.push((o.key || res[1]+'[]')+'='+(o.key && o.expression ? res[1] : res[2]));
		});

		if(!str.length && o.key) {
			str.push(o.key + '=');
		}

		return str.join('&');

	},

	toArray: function(o) {

		var items = this._getItemsAsjQuery(o && o.connected);
		var ret = []; o = o || {};

		items.each(function() { ret.push($(o.item || this).attr(o.attribute || 'id') || ''); });
		return ret;

	},

	/* Be careful with the following core functions */
	_intersectsWith: function(item) {

		var x1 = this.positionAbs.left,
			x2 = x1 + this.helperProportions.width,
			y1 = this.positionAbs.top,
			y2 = y1 + this.helperProportions.height;

		var l = item.left,
			r = l + item.width,
			t = item.top,
			b = t + item.height;

		var dyClick = this.offset.click.top,
			dxClick = this.offset.click.left;

		var isOverElement = (y1 + dyClick) > t && (y1 + dyClick) < b && (x1 + dxClick) > l && (x1 + dxClick) < r;

		if(	   this.options.tolerance == "pointer"
			|| this.options.forcePointerForContainers
			|| (this.options.tolerance != "pointer" && this.helperProportions[this.floating ? 'width' : 'height'] > item[this.floating ? 'width' : 'height'])
		) {
			return isOverElement;
		} else {

			return (l < x1 + (this.helperProportions.width / 2) // Right Half
				&& x2 - (this.helperProportions.width / 2) < r // Left Half
				&& t < y1 + (this.helperProportions.height / 2) // Bottom Half
				&& y2 - (this.helperProportions.height / 2) < b ); // Top Half

		}
	},

	_intersectsWithPointer: function(item) {

		var isOverElementHeight = $.ui.isOverAxis(this.positionAbs.top + this.offset.click.top, item.top, item.height),
			isOverElementWidth = $.ui.isOverAxis(this.positionAbs.left + this.offset.click.left, item.left, item.width),
			isOverElement = isOverElementHeight && isOverElementWidth,
			verticalDirection = this._getDragVerticalDirection(),
			horizontalDirection = this._getDragHorizontalDirection();

		if (!isOverElement)
			return false;

		return this.floating ?
			( ((horizontalDirection && horizontalDirection == "right") || verticalDirection == "down") ? 2 : 1 )
			: ( verticalDirection && (verticalDirection == "down" ? 2 : 1) );

	},

	_intersectsWithSides: function(item) {

		var isOverBottomHalf = $.ui.isOverAxis(this.positionAbs.top + this.offset.click.top, item.top + (item.height/2), item.height),
			isOverRightHalf = $.ui.isOverAxis(this.positionAbs.left + this.offset.click.left, item.left + (item.width/2), item.width),
			verticalDirection = this._getDragVerticalDirection(),
			horizontalDirection = this._getDragHorizontalDirection();

		if (this.floating && horizontalDirection) {
			return ((horizontalDirection == "right" && isOverRightHalf) || (horizontalDirection == "left" && !isOverRightHalf));
		} else {
			return verticalDirection && ((verticalDirection == "down" && isOverBottomHalf) || (verticalDirection == "up" && !isOverBottomHalf));
		}

	},

	_getDragVerticalDirection: function() {
		var delta = this.positionAbs.top - this.lastPositionAbs.top;
		return delta != 0 && (delta > 0 ? "down" : "up");
	},

	_getDragHorizontalDirection: function() {
		var delta = this.positionAbs.left - this.lastPositionAbs.left;
		return delta != 0 && (delta > 0 ? "right" : "left");
	},

	refresh: function(event) {
		this._refreshItems(event);
		this.refreshPositions();
		return this;
	},

	_connectWith: function() {
		var options = this.options;
		return options.connectWith.constructor == String
			? [options.connectWith]
			: options.connectWith;
	},

	_getItemsAsjQuery: function(connected) {

		var self = this;
		var items = [];
		var queries = [];
		var connectWith = this._connectWith();

		if(connectWith && connected) {
			for (var i = connectWith.length - 1; i >= 0; i--){
				var cur = $(connectWith[i]);
				for (var j = cur.length - 1; j >= 0; j--){
					var inst = $.data(cur[j], 'sortable');
					if(inst && inst != this && !inst.options.disabled) {
						queries.push([$.isFunction(inst.options.items) ? inst.options.items.call(inst.element) : $(inst.options.items, inst.element).not(".ui-sortable-helper").not('.ui-sortable-placeholder'), inst]);
					}
				};
			};
		}

		queries.push([$.isFunction(this.options.items) ? this.options.items.call(this.element, null, { options: this.options, item: this.currentItem }) : $(this.options.items, this.element).not(".ui-sortable-helper").not('.ui-sortable-placeholder'), this]);

		for (var i = queries.length - 1; i >= 0; i--){
			queries[i][0].each(function() {
				items.push(this);
			});
		};

		return $(items);

	},

	_removeCurrentsFromItems: function() {

		var list = this.currentItem.find(":data(sortable-item)");

		for (var i=0; i < this.items.length; i++) {

			for (var j=0; j < list.length; j++) {
				if(list[j] == this.items[i].item[0])
					this.items.splice(i,1);
			};

		};

	},

	_refreshItems: function(event) {

		this.items = [];
		this.containers = [this];
		var items = this.items;
		var self = this;
		var queries = [[$.isFunction(this.options.items) ? this.options.items.call(this.element[0], event, { item: this.currentItem }) : $(this.options.items, this.element), this]];
		var connectWith = this._connectWith();

		if(connectWith) {
			for (var i = connectWith.length - 1; i >= 0; i--){
				var cur = $(connectWith[i]);
				for (var j = cur.length - 1; j >= 0; j--){
					var inst = $.data(cur[j], 'sortable');
					if(inst && inst != this && !inst.options.disabled) {
						queries.push([$.isFunction(inst.options.items) ? inst.options.items.call(inst.element[0], event, { item: this.currentItem }) : $(inst.options.items, inst.element), inst]);
						this.containers.push(inst);
					}
				};
			};
		}

		for (var i = queries.length - 1; i >= 0; i--) {
			var targetData = queries[i][1];
			var _queries = queries[i][0];

			for (var j=0, queriesLength = _queries.length; j < queriesLength; j++) {
				var item = $(_queries[j]);

				item.data('sortable-item', targetData); // Data for target checking (mouse manager)

				items.push({
					item: item,
					instance: targetData,
					width: 0, height: 0,
					left: 0, top: 0
				});
			};
		};

	},

	refreshPositions: function(fast) {

		//This has to be redone because due to the item being moved out/into the offsetParent, the offsetParent's position will change
		if(this.offsetParent && this.helper) {
			this.offset.parent = this._getParentOffset();
		}

		for (var i = this.items.length - 1; i >= 0; i--){
			var item = this.items[i];

			//We ignore calculating positions of all connected containers when we're not over them
			if(item.instance != this.currentContainer && this.currentContainer && item.item[0] != this.currentItem[0])
				continue;

			var t = this.options.toleranceElement ? $(this.options.toleranceElement, item.item) : item.item;

			if (!fast) {
				item.width = t.outerWidth();
				item.height = t.outerHeight();
			}

			var p = t.offset();
			item.left = p.left;
			item.top = p.top;
		};

		if(this.options.custom && this.options.custom.refreshContainers) {
			this.options.custom.refreshContainers.call(this);
		} else {
			for (var i = this.containers.length - 1; i >= 0; i--){
				var p = this.containers[i].element.offset();
				this.containers[i].containerCache.left = p.left;
				this.containers[i].containerCache.top = p.top;
				this.containers[i].containerCache.width	= this.containers[i].element.outerWidth();
				this.containers[i].containerCache.height = this.containers[i].element.outerHeight();
			};
		}

		return this;
	},

	_createPlaceholder: function(that) {

		var self = that || this, o = self.options;

		if(!o.placeholder || o.placeholder.constructor == String) {
			var className = o.placeholder;
			o.placeholder = {
				element: function() {

					var el = $((this.document || document).createElement(self.currentItem[0].nodeName))
						.addClass(className || self.currentItem[0].className+" ui-sortable-placeholder")
						.removeClass("ui-sortable-helper")[0];

					if(!className)
						el.style.visibility = "hidden";

					return el;
				},
				update: function(container, p) {

					// 1. If a className is set as 'placeholder option, we don't force sizes - the class is responsible for that
					// 2. The option 'forcePlaceholderSize can be enabled to force it even if a class name is specified
					if(className && !o.forcePlaceholderSize) return;

					//If the element doesn't have a actual height by itself (without styles coming from a stylesheet), it receives the inline height from the dragged item
					if(!p.height()) { p.height(self.currentItem.innerHeight() - parseInt(self.currentItem.css('paddingTop')||0, 10) - parseInt(self.currentItem.css('paddingBottom')||0, 10)); };
					if(!p.width()) { p.width(self.currentItem.innerWidth() - parseInt(self.currentItem.css('paddingLeft')||0, 10) - parseInt(self.currentItem.css('paddingRight')||0, 10)); };
				}
			};
		}

		//Create the placeholder
		self.placeholder = $(o.placeholder.element.call(self.element, self.currentItem));

		//Append it after the actual current item
		self.currentItem.after(self.placeholder);

		//Update the size of the placeholder (TODO: Logic to fuzzy, see line 316/317)
		o.placeholder.update(self, self.placeholder);

	},

	_contactContainers: function(event) {

		// get innermost container that intersects with item
		var innermostContainer = null, innermostIndex = null;


		for (var i = this.containers.length - 1; i >= 0; i--){

			// never consider a container that's located within the item itself
			if($.ui.contains(this.currentItem[0], this.containers[i].element[0]))
				continue;

			if(this._intersectsWith(this.containers[i].containerCache)) {

				// if we've already found a container and it's more "inner" than this, then continue
				if(innermostContainer && $.ui.contains(this.containers[i].element[0], innermostContainer.element[0]))
					continue;

				innermostContainer = this.containers[i];
				innermostIndex = i;

			} else {
				// container doesn't intersect. trigger "out" event if necessary
				if(this.containers[i].containerCache.over) {
					this.containers[i]._trigger("out", event, this._uiHash(this));
					this.containers[i].containerCache.over = 0;
				}
			}

		}

		// if no intersecting containers found, return
		if(!innermostContainer) return;

		// move the item into the container if it's not there already
		if(this.containers.length === 1) {
			this.containers[innermostIndex]._trigger("over", event, this._uiHash(this));
			this.containers[innermostIndex].containerCache.over = 1;
		} else if(this.currentContainer != this.containers[innermostIndex]) {

			//When entering a new container, we will find the item with the least distance and append our item near it
			var dist = 10000; var itemWithLeastDistance = null; var base = this.positionAbs[this.containers[innermostIndex].floating ? 'left' : 'top'];
			for (var j = this.items.length - 1; j >= 0; j--) {
				if(!$.ui.contains(this.containers[innermostIndex].element[0], this.items[j].item[0])) continue;
				var cur = this.items[j][this.containers[innermostIndex].floating ? 'left' : 'top'];
				if(Math.abs(cur - base) < dist) {
					dist = Math.abs(cur - base); itemWithLeastDistance = this.items[j];
				}
			}

			if(!itemWithLeastDistance && !this.options.dropOnEmpty) //Check if dropOnEmpty is enabled
				return;

			this.currentContainer = this.containers[innermostIndex];
			itemWithLeastDistance ? this._rearrange(event, itemWithLeastDistance, null, true) : this._rearrange(event, null, this.containers[innermostIndex].element, true);
			this._trigger("change", event, this._uiHash());
			this.containers[innermostIndex]._trigger("change", event, this._uiHash(this));

			//Update the placeholder
			this.options.placeholder.update(this.currentContainer, this.placeholder);

			this.containers[innermostIndex]._trigger("over", event, this._uiHash(this));
			this.containers[innermostIndex].containerCache.over = 1;
		}


	},

	_createHelper: function(event) {

		var o = this.options;
		var helper = $.isFunction(o.helper) ? $(o.helper.apply(this.element[0], [event, this.currentItem])) : (o.helper == 'clone' ? this.currentItem.clone() : this.currentItem);

		if(!helper.parents('body').length) //Add the helper to the DOM if that didn't happen already
			$(o.appendTo != 'parent' ? o.appendTo : this.currentItem[0].parentNode)[0].appendChild(helper[0]);

		if(helper[0] == this.currentItem[0])
			this._storedCSS = { width: this.currentItem[0].style.width, height: this.currentItem[0].style.height, position: this.currentItem.css("position"), top: this.currentItem.css("top"), left: this.currentItem.css("left") };

		if(helper[0].style.width == '' || o.forceHelperSize) helper.width(this.currentItem.width());
		if(helper[0].style.height == '' || o.forceHelperSize) helper.height(this.currentItem.height());

		return helper;

	},

	_adjustOffsetFromHelper: function(obj) {
		if (typeof obj == 'string') {
			obj = obj.split(' ');
		}
		if ($.isArray(obj)) {
			obj = {left: +obj[0], top: +obj[1] || 0};
		}
		if ('left' in obj) {
			this.offset.click.left = obj.left + this.margins.left;
		}
		if ('right' in obj) {
			this.offset.click.left = this.helperProportions.width - obj.right + this.margins.left;
		}
		if ('top' in obj) {
			this.offset.click.top = obj.top + this.margins.top;
		}
		if ('bottom' in obj) {
			this.offset.click.top = this.helperProportions.height - obj.bottom + this.margins.top;
		}
	},

	_getParentOffset: function() {


		//Get the offsetParent and cache its position
		this.offsetParent = this.helper.offsetParent();
		var po = this.offsetParent.offset();

		// This is a special case where we need to modify a offset calculated on start, since the following happened:
		// 1. The position of the helper is absolute, so it's position is calculated based on the next positioned parent
		// 2. The actual offset parent is a child of the scroll parent, and the scroll parent isn't the document, which means that
		//    the scroll is included in the initial calculation of the offset of the parent, and never recalculated upon drag
		if(this.cssPosition == 'absolute' && this.scrollParent[0] != (this.document || document) && $.ui.contains(this.scrollParent[0], this.offsetParent[0])) {
			po.left += this.scrollParent.scrollLeft();
			po.top += this.scrollParent.scrollTop();
		}

		if((this.offsetParent[0] == (this.document || document).body) //This needs to be actually done for all browsers, since pageX/pageY includes this information
		|| (this.offsetParent[0].tagName && this.offsetParent[0].tagName.toLowerCase() == 'html' && $.browser.msie)) //Ugly IE fix
			po = { top: 0, left: 0 };

		return {
			top: po.top + (parseInt(this.offsetParent.css("borderTopWidth"),10) || 0),
			left: po.left + (parseInt(this.offsetParent.css("borderLeftWidth"),10) || 0)
		};

	},

	_getRelativeOffset: function() {

		if(this.cssPosition == "relative") {
			var p = this.currentItem.position();
			return {
				top: p.top - (parseInt(this.helper.css("top"),10) || 0) + this.scrollParent.scrollTop(),
				left: p.left - (parseInt(this.helper.css("left"),10) || 0) + this.scrollParent.scrollLeft()
			};
		} else {
			return { top: 0, left: 0 };
		}

	},

	_cacheMargins: function() {
		this.margins = {
			left: (parseInt(this.currentItem.css("marginLeft"),10) || 0),
			top: (parseInt(this.currentItem.css("marginTop"),10) || 0)
		};
	},

	_cacheHelperProportions: function() {
		this.helperProportions = {
			width: this.helper.outerWidth(),
			height: this.helper.outerHeight()
		};
	},

	_setContainment: function() {

		var o = this.options;
		if(o.containment == 'parent') o.containment = this.helper[0].parentNode;
		if(o.containment == 'document' || o.containment == 'window') this.containment = [
			0 - this.offset.relative.left - this.offset.parent.left,
			0 - this.offset.relative.top - this.offset.parent.top,
			$(o.containment == 'document' ? (this.document || document) : window).width() - this.helperProportions.width - this.margins.left,
			($(o.containment == 'document' ? (this.document || document) : window).height() || (this.document || document).body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top
		];

		if(!(/^(document|window|parent)$/).test(o.containment)) {
			var ce = $(o.containment)[0];
			var co = $(o.containment).offset();
			var over = ($(ce).css("overflow") != 'hidden');

			this.containment = [
				co.left + (parseInt($(ce).css("borderLeftWidth"),10) || 0) + (parseInt($(ce).css("paddingLeft"),10) || 0) - this.margins.left,
				co.top + (parseInt($(ce).css("borderTopWidth"),10) || 0) + (parseInt($(ce).css("paddingTop"),10) || 0) - this.margins.top,
				co.left+(over ? Math.max(ce.scrollWidth,ce.offsetWidth) : ce.offsetWidth) - (parseInt($(ce).css("borderLeftWidth"),10) || 0) - (parseInt($(ce).css("paddingRight"),10) || 0) - this.helperProportions.width - this.margins.left,
				co.top+(over ? Math.max(ce.scrollHeight,ce.offsetHeight) : ce.offsetHeight) - (parseInt($(ce).css("borderTopWidth"),10) || 0) - (parseInt($(ce).css("paddingBottom"),10) || 0) - this.helperProportions.height - this.margins.top
			];
		}

	},

	_convertPositionTo: function(d, pos) {

		if(!pos) pos = this.position;
		var mod = d == "absolute" ? 1 : -1;
		var o = this.options, scroll = this.cssPosition == 'absolute' && !(this.scrollParent[0] != (this.document || document) && $.ui.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent, scrollIsRootNode = (/(html|body)/i).test(scroll[0].tagName);

		return {
			top: (
				pos.top																	// The absolute mouse position
				+ this.offset.relative.top * mod										// Only for relative positioned nodes: Relative offset from element to offset parent
				+ this.offset.parent.top * mod											// The offsetParent's offset without borders (offset + border)
				- ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollTop() : ( scrollIsRootNode ? 0 : scroll.scrollTop() ) ) * mod)
			),
			left: (
				pos.left																// The absolute mouse position
				+ this.offset.relative.left * mod										// Only for relative positioned nodes: Relative offset from element to offset parent
				+ this.offset.parent.left * mod											// The offsetParent's offset without borders (offset + border)
				- ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollLeft() : scrollIsRootNode ? 0 : scroll.scrollLeft() ) * mod)
			)
		};

	},

	_generatePosition: function(event) {

		var o = this.options, scroll = this.cssPosition == 'absolute' && !(this.scrollParent[0] != (this.document || document) && $.ui.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent, scrollIsRootNode = (/(html|body)/i).test(scroll[0].tagName);

		// This is another very weird special case that only happens for relative elements:
		// 1. If the css position is relative
		// 2. and the scroll parent is the document or similar to the offset parent
		// we have to refresh the relative offset during the scroll so there are no jumps
		if(this.cssPosition == 'relative' && !(this.scrollParent[0] != (this.document || document) && this.scrollParent[0] != this.offsetParent[0])) {
			this.offset.relative = this._getRelativeOffset();
		}

		var pageX = event.pageX;
		var pageY = event.pageY;

		/*
		 * - Position constraining -
		 * Constrain the position to a mix of grid, containment.
		 */

		if(this.originalPosition) { //If we are not dragging yet, we won't check for options

			if(this.containment) {
				if(event.pageX - this.offset.click.left < this.containment[0]) pageX = this.containment[0] + this.offset.click.left;
				if(event.pageY - this.offset.click.top < this.containment[1]) pageY = this.containment[1] + this.offset.click.top;
				if(event.pageX - this.offset.click.left > this.containment[2]) pageX = this.containment[2] + this.offset.click.left;
				if(event.pageY - this.offset.click.top > this.containment[3]) pageY = this.containment[3] + this.offset.click.top;
			}

			if(o.grid) {
				var top = this.originalPageY + Math.round((pageY - this.originalPageY) / o.grid[1]) * o.grid[1];
				pageY = this.containment ? (!(top - this.offset.click.top < this.containment[1] || top - this.offset.click.top > this.containment[3]) ? top : (!(top - this.offset.click.top < this.containment[1]) ? top - o.grid[1] : top + o.grid[1])) : top;

				var left = this.originalPageX + Math.round((pageX - this.originalPageX) / o.grid[0]) * o.grid[0];
				pageX = this.containment ? (!(left - this.offset.click.left < this.containment[0] || left - this.offset.click.left > this.containment[2]) ? left : (!(left - this.offset.click.left < this.containment[0]) ? left - o.grid[0] : left + o.grid[0])) : left;
			}

		}

		return {
			top: (
				pageY																// The absolute mouse position
				- this.offset.click.top													// Click offset (relative to the element)
				- this.offset.relative.top												// Only for relative positioned nodes: Relative offset from element to offset parent
				- this.offset.parent.top												// The offsetParent's offset without borders (offset + border)
				+ ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollTop() : ( scrollIsRootNode ? 0 : scroll.scrollTop() ) ))
			),
			left: (
				pageX																// The absolute mouse position
				- this.offset.click.left												// Click offset (relative to the element)
				- this.offset.relative.left												// Only for relative positioned nodes: Relative offset from element to offset parent
				- this.offset.parent.left												// The offsetParent's offset without borders (offset + border)
				+ ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollLeft() : scrollIsRootNode ? 0 : scroll.scrollLeft() ))
			)
		};

	},

	_rearrange: function(event, i, a, hardRefresh) {

		a ? a[0].appendChild(this.placeholder[0]) : i.item[0].parentNode.insertBefore(this.placeholder[0], (this.direction == 'down' ? i.item[0] : i.item[0].nextSibling));

		//Various things done here to improve the performance:
		// 1. we create a setTimeout, that calls refreshPositions
		// 2. on the instance, we have a counter variable, that get's higher after every append
		// 3. on the local scope, we copy the counter variable, and check in the timeout, if it's still the same
		// 4. this lets only the last addition to the timeout stack through
		this.counter = this.counter ? ++this.counter : 1;
		var self = this, counter = this.counter;

		window.setTimeout(function() {
			if(counter == self.counter) self.refreshPositions(!hardRefresh); //Precompute after each DOM insertion, NOT on mousemove
		},0);

	},

	_clear: function(event, noPropagation) {

		this.reverting = false;
		// We delay all events that have to be triggered to after the point where the placeholder has been removed and
		// everything else normalized again
		var delayedTriggers = [], self = this;

		// We first have to update the dom position of the actual currentItem
		// Note: don't do it if the current item is already removed (by a user), or it gets reappended (see #4088)
		if(!this._noFinalSort && this.currentItem[0].parentNode) this.placeholder.before(this.currentItem);
		this._noFinalSort = null;

		if(this.helper[0] == this.currentItem[0]) {
			for(var i in this._storedCSS) {
				if(this._storedCSS[i] == 'auto' || this._storedCSS[i] == 'static') this._storedCSS[i] = '';
			}
			this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper");
		} else {
			this.currentItem.show();
		}

		if(this.fromOutside && !noPropagation) delayedTriggers.push(function(event) { this._trigger("receive", event, this._uiHash(this.fromOutside)); });
		if((this.fromOutside || this.domPosition.prev != this.currentItem.prev().not(".ui-sortable-helper")[0] || this.domPosition.parent != this.currentItem.parent()[0]) && !noPropagation) delayedTriggers.push(function(event) { this._trigger("update", event, this._uiHash()); }); //Trigger update callback if the DOM position has changed
		if(!$.ui.contains(this.element[0], this.currentItem[0])) { //Node was moved out of the current element
			if(!noPropagation) delayedTriggers.push(function(event) { this._trigger("remove", event, this._uiHash()); });
			for (var i = this.containers.length - 1; i >= 0; i--){
				if($.ui.contains(this.containers[i].element[0], this.currentItem[0]) && !noPropagation) {
					delayedTriggers.push((function(c) { return function(event) { c._trigger("receive", event, this._uiHash(this)); };  }).call(this, this.containers[i]));
					delayedTriggers.push((function(c) { return function(event) { c._trigger("update", event, this._uiHash(this));  }; }).call(this, this.containers[i]));
				}
			};
		};

		//Post events to containers
		for (var i = this.containers.length - 1; i >= 0; i--){
			if(!noPropagation) delayedTriggers.push((function(c) { return function(event) { c._trigger("deactivate", event, this._uiHash(this)); };  }).call(this, this.containers[i]));
			if(this.containers[i].containerCache.over) {
				delayedTriggers.push((function(c) { return function(event) { c._trigger("out", event, this._uiHash(this)); };  }).call(this, this.containers[i]));
				this.containers[i].containerCache.over = 0;
			}
		}

		//Do what was originally in plugins
		if(this._storedCursor) $('body').css("cursor", this._storedCursor); //Reset cursor
		if(this._storedOpacity) this.helper.css("opacity", this._storedOpacity); //Reset opacity
		if(this._storedZIndex) this.helper.css("zIndex", this._storedZIndex == 'auto' ? '' : this._storedZIndex); //Reset z-index

		this.dragging = false;
		if(this.cancelHelperRemoval) {
			if(!noPropagation) {
				this._trigger("beforeStop", event, this._uiHash());
				for (var i=0; i < delayedTriggers.length; i++) { delayedTriggers[i].call(this, event); }; //Trigger all delayed events
				this._trigger("stop", event, this._uiHash());
			}
			return false;
		}

		if(!noPropagation) this._trigger("beforeStop", event, this._uiHash());

		//$(this.placeholder[0]).remove(); would have been the jQuery way - unfortunately, it unbinds ALL events from the original node!
		this.placeholder[0].parentNode.removeChild(this.placeholder[0]);

		if(this.helper[0] != this.currentItem[0]) this.helper.remove(); this.helper = null;

		if(!noPropagation) {
			for (var i=0; i < delayedTriggers.length; i++) { delayedTriggers[i].call(this, event); }; //Trigger all delayed events
			this._trigger("stop", event, this._uiHash());
		}

		this.fromOutside = false;
		return true;

	},

	_trigger: function() {
		if ($.Widget.prototype._trigger.apply(this, arguments) === false) {
			this.cancel();
		}
	},

	_uiHash: function(inst) {
		var self = inst || this;
		return {
			helper: self.helper,
			placeholder: self.placeholder || $([]),
			position: self.position,
			originalPosition: self.originalPosition,
			offset: self.positionAbs,
			item: self.currentItem,
			sender: inst ? inst.element : null
		};
	}

});

$.extend($.ui.sortable, {
	version: "1.8.13"
});

})(jQuery);
/*
 * jQuery serializeObject Plugin: https://github.com/fojas/jQuery-serializeObject
 *
 */

!function($){
  $.serializeObject = function(obj){
    var o={},lookup=o,a = obj;
    $.each(a,function(){
      var named = this.name.replace(/\[([^\]]+)?\]/g,',$1').split(','),
          cap = named.length - 1,
          i = 0;
      for(;i<cap;i++) {
        // move down the tree - create objects or array if necessary
        if(lookup.push){ // this is an array, add values instead of setting them
          // push an object if this is an empty array or we are about to overwrite a value
          if( !lookup[lookup.length -1] // this is an empty array
              || lookup[lookup.length -1].constructor !== Object //current value is not a hash
              || lookup[lookup.length -1][named[i+1]] !== undefined //current item is already set
              ){
            lookup.push({});
          }
          lookup = lookup[lookup.length -1];
        } else {
          lookup = lookup[named[i]] = lookup[named[i]] || (named[i+1]==""?[]:{});
        }
      }
      if(lookup.push){
        lookup.push(this.value);
      }else{
        lookup[named[cap]]=this.value;
      }
      lookup = o;
    });
    return o;
  };

  $.deserializeObject = function deserializeObject(json,arr,prefix){
    var i,j,thisPrefix,objType;
    arr = arr || [];
    if(Object.prototype.toString.call(json) ==='[object Object]'){
      for(i in json){
        thisPrefix = prefix ? [prefix,'[',i,']'].join('') : i;
        if(json.hasOwnProperty(i)){
          objType = Object.prototype.toString.call(json[i])
          if(objType === '[object Array]'){
            for(j = 0,jsonLen = json[i].length;j<jsonLen;j++){
              deserializeObject(json[i][j],arr,thisPrefix+'[]');
            }
          }else if(objType === '[object Object]'){
            deserializeObject(json[i],arr,thisPrefix);
          }else {
            arr.push({
              name : thisPrefix,
              value : json[i]
            });
          }
        }
      }
    } else {
      arr.push({
        name : prefix,
        value : json
      });
    }
    return arr;
  }

  var check = function(){
    // older versions of jQuery do not have prop
    var propExists = !!$.fn.prop;
    return function(obj,checked){
      if(propExists) obj.prop('checked',checked);
      else obj.attr('checked', (checked ? 'checked' : null ));
    };
  }();

  $.applySerializedArray = function(form,obj){
    var $form = $(form).find('input,select,textarea'), el;
    check($form.filter(':checked'),false)
    for(var i = obj.length;i--;){
      el = $form.filter("[name='"+obj[i].name+"']");
      if(el.filter(':checkbox').length){
        if(el.val() == obj[i].value) check(el.filter(':checkbox'),true);
      }else if(el.filter(':radio').length){
        check(el.filter("[value='"+obj[i].value+"']"),true)
      } else {
        el.val(obj[i].value);
      }
    }
  };

  $.applySerializedObject = function(form, obj){
    $.applySerializedArray(form,$.deserializeObject(obj));
  };

  $.fn.serializeObject = $.fn.serializeObject || function(){
    return $.serializeObject(this.serializeArray());
  };

  $.fn.applySerializedObject = function(obj){
    $.applySerializedObject(this,obj);
    return this;
  };

  $.fn.applySerializedArray = function(obj){
    $.applySerializedArray(this,obj);
    return this;
  };

}(jQuery);
/*
 * jQuery Easing v1.3 - http://gsgd.co.uk/sandbox/jquery/easing/
 *
 * Uses the built in easing capabilities added In jQuery 1.1 to offer multiple easing options
 *
 * TERMS OF USE - jQuery Easing
 *
 * Open source under the BSD License.
 *
 * Copyright © 2008 George McGinley Smith
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
 * following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following
 * disclaimer.  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials provided with the distribution.
 *
 * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
jQuery.extend(jQuery.easing, {
  easeInSine: function (x, t, b, c, d) {
    return -c * Math.cos(t / d * (Math.PI / 2)) + c + b
  },
  easeOutSine: function (x, t, b, c, d) {
    return c * Math.sin(t / d * (Math.PI / 2)) + b
  },
  easeInOutSine: function (x, t, b, c, d) {
    return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b
  }
});

/*
 * jQuery JSON Plugin version: 2.1 (2009-08-14)
 *
 * This document is licensed as free software under the terms of the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Brantley Harris wrote this plugin. It is based somewhat on the JSON.org  website's http://www.json.org/json2.js,
 * which proclaims: "NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.", a sentiment that I uphold.
 *
 * It is also influenced heavily by MochiKit's serializeJSON, which is  copyrighted 2005 by Bob Ippolito.
 */
(function($) {
  $.toJSON = function(o) {
    if (typeof(JSON) == 'object' && JSON.stringify) return JSON.stringify(o);

    var type = typeof(o);

    if (o === null) return "null";
    if (type == "undefined") return undefined;
    if (type == "number" || type == "boolean") return o + "";
    if (type == "string") return $.quoteString(o);

    if (type == 'object') {
      if (typeof(o.toJSON) == "function") return $.toJSON(o.toJSON());

      if (o.constructor === Date) {
        var year = o.getUTCFullYear();

        var month = o.getUTCMonth() + 1;
        if (month < 10) month = '0' + month;

        var day = o.getUTCDate();
        if (day < 10) day = '0' + day;

        var hours = o.getUTCHours();
        if (hours < 10) hours = '0' + hours;

        var minutes = o.getUTCMinutes();
        if (minutes < 10) minutes = '0' + minutes;

        var seconds = o.getUTCSeconds();
        if (seconds < 10) seconds = '0' + seconds;

        var milli = o.getUTCMilliseconds();
        if (milli < 100) milli = '0' + milli;
        if (milli < 10) milli = '0' + milli;

        return '"' + year + '-' + month + '-' + day + 'T' + hours + ':' + minutes + ':' + seconds + '.' + milli + 'Z"';
      }

      if (o.constructor === Array) {
        var ret = [];
        for (var i = 0; i < o.length; i++) ret.push($.toJSON(o[i]) || "null");
        return "[" + ret.join(",") + "]";
      }

      var pairs = [];
      for (var k in o) {
        var name;
        type = typeof(k);

        if (type == "number") name = '"' + k + '"';
        else if (type == "string") name = $.quoteString(k);
        else continue;  //skip non-string or number keys

        if (typeof o[k] == "function") continue;  //skip pairs where the value is a function.
        var val = $.toJSON(o[k]);
        pairs.push(name + ":" + val);
      }

      return "{" + pairs.join(", ") + "}";
    }
  };

  $.quoteString = function(string) {
    if (string.match(_escapeable)) {
      return '"' + string.replace(_escapeable, function (a) {
        var c = _meta[a];
        if (typeof c === 'string') return c;
        c = a.charCodeAt();
        return '\\u00' + Math.floor(c / 16).toString(16) + (c % 16).toString(16);
      }) + '"';
    }
    return '"' + string + '"';
  };

  var _escapeable = /["\\\x00-\x1f\x7f-\x9f]/g;
  var _meta = {'\b': '\\b', '\t': '\\t', '\n': '\\n', '\f': '\\f', '\r': '\\r', '"' : '\\"', '\\': '\\\\'};
})(jQuery);

/*
 * jQuery Localizer Plugin
 *
 * Copyright (c) 2011 Sagi Mann (with a basic reworking by Jeremy Jackson)
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms are permitted provided that the above copyright notice and this
 * paragraph are duplicated in all such forms and that any documentation, advertising materials, and other materials
 * related to such distribution and use acknowledge that the software was developed by the <organization>.  The name of
 * the University may not be used to endorse or promote products derived from this software without specific prior
 * written permission.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 */
(function($) {
  $.fn.localize = function(locale) {
    this.find('*').contents().each(function() {
      var translated = false;
      var source = '';
      if (typeof(this.data) == 'string') {
        source = $.trim(this.data);
        if (source && (translated = (locale.sub[source] || locale.top[source]))) {
          this.data = translated;
        }
      }

      if (this.nodeName == 'IMG' && this.attributes['src']) {
        source = this.attributes['src'].nodeValue;
        if (source && (translated = (locale.sub[source] || locale.top[source]))) {
          $(this).attr('src', translated);
        }
      }

      if (this.nodeName == "A" && this.attributes['href']) {
        source = $.trim(this.attributes['href'].nodeValue);
        if (source && (translated = (locale.sub[source] || locale.top[source]))) {
          $(this).attr('href', translated);
        }
      }

      if (this.nodeName == "INPUT" && this.attributes['type']) {
        if (this.attributes['value'] && ['submit', 'reset', 'button'].indexOf(this.attributes['type'].nodeValue.toLowerCase()) > -1) {
          source = $.trim(this.attributes['value'].nodeValue);
          if (source && (translated = (locale.sub[source] || locale.top[source]))) {
            $(this).attr('value', translated);
          }
        }
      }

      return this;
    });
  };
})(jQuery);
/*
 HTML Clean for jQuery
 Anthony Johnston
 http://www.antix.co.uk

 version 1.2.3

 $Revision: 51 $

 requires jQuery http://jquery.com

 Use and distibution http://www.opensource.org/licenses/bsd-license.php

 2010-04-02 allowedTags/removeTags added (white/black list) thanks to David Wartian (Dwartian)
 2010-06-30 replaceStyles added for replacement of bold, italic, super and sub styles on a tag
 2010-07-01 notRenderedTags added, where tags are to be removed but their contents are kept
 */

(function ($) {
  $.fn.htmlClean = function (options) {
    // iterate and html clean each matched element
    return this.each(function () {
      if (this.value) {
        this.value = $.htmlClean(this.value, options);
      } else {
        this.innerHTML = $.htmlClean(this.innerHTML, options);
      }
    });
  };

  // clean the passed html
  $.htmlClean = function (html, options) {
    options = $.extend({}, $.htmlClean.defaults, options);

    var tagsRE = /<(\/)?(\w+:)?([\w]+)([^>]*)>/gi;
    var attrsRE = /(\w+)=(".*?"|'.*?'|[^\s>]*)/gi;

    var tagMatch;
    var root = new Element();
    var stack = [root];
    var container = root;

    if (options.bodyOnly) {
      // check for body tag
      if (tagMatch = /<body[^>]*>((\n|.)*)<\/body>/i.exec(html)) {
        html = tagMatch[1];
      }
    }
    html = html.concat("<xxx>"); // ensure last element/text is found
    var lastIndex;

    while (tagMatch = tagsRE.exec(html)) {
      var tag = new Tag(tagMatch[3], tagMatch[1], tagMatch[4], options);

      // add the text
      var text = html.substring(lastIndex, tagMatch.index);
      if (text.length > 0) {
        var child = container.children[container.children.length - 1];
        if (container.children.length > 0 && isText(child = container.children[container.children.length - 1])) {
          // merge text
          container.children[container.children.length - 1] = child.concat(text);
        } else {
          container.children.push(text);
        }
      }
      lastIndex = tagsRE.lastIndex;

      if (tag.isClosing) {
        // find matching container
        if (pop(stack, [tag.name])) {
          stack.pop();
          container = stack[stack.length - 1];
        }
      } else {
        // create a new element
        var element = new Element(tag);

        // add attributes
        var attrMatch;
        while (attrMatch = attrsRE.exec(tag.rawAttributes)) {
          // check style attribute and do replacements
          if (attrMatch[1].toLowerCase() == "style" && options.replaceStyles) {

            var renderParent = !tag.isInline;
            for (var i = 0; i < options.replaceStyles.length; i++) {
              if (options.replaceStyles[i][0].test(attrMatch[2])) {

                if (!renderParent) {
                  tag.render = false;
                  renderParent = true;
                }
                container.children.push(element); // assumes not replaced
                stack.push(element);
                container = element; // assumes replacement is a container
                // create new tag and element
                tag = new Tag(options.replaceStyles[i][1], "", "", options);
                element = new Element(tag);
              }
            }
          }

          if (tag.allowedAttributes != null
            && (tag.allowedAttributes.length == 0
            || $.inArray(attrMatch[1], tag.allowedAttributes) > -1)) {
            element.attributes.push(new Attribute(attrMatch[1], attrMatch[2]));
          }
        }

        // add required empty ones
        $.each(tag.requiredAttributes, function () {
          var name = this.toString();
          if (!element.hasAttribute(name)) element.attributes.push(new Attribute(name, ""));
        });

        // check for replacements
        for (var repIndex = 0; repIndex < options.replace.length; repIndex++) {
          for (var tagIndex = 0; tagIndex < options.replace[repIndex][0].length; tagIndex++) {
            var byName = typeof (options.replace[repIndex][0][tagIndex]) == "string";
            if ((byName && options.replace[repIndex][0][tagIndex] == tag.name)
              || (!byName && options.replace[repIndex][0][tagIndex].test(tagMatch))) {
              // don't render this tag
              tag.render = false;
              container.children.push(element);
              stack.push(element);
              container = element;

              // render new tag, keep attributes
              tag = new Tag(options.replace[repIndex][1], tagMatch[1], tagMatch[4], options);
              element = new Element(tag);
              element.attributes = container.attributes;

              repIndex = options.replace.length; // break out of both loops
              break;
            }
          }
        }

        // check container rules
        var add = true;
        if (!container.isRoot) {
          if (container.tag.isInline && !tag.isInline) {
            add = false;
          } else if (container.tag.disallowNest && tag.disallowNest
            && !tag.requiredParent) {
            add = false;
          } else if (tag.requiredParent) {
            if (add = pop(stack, tag.requiredParent)) {
              container = stack[stack.length - 1];
            }
          }
        }

        if (add) {
          container.children.push(element);

          if (tag.toProtect) {
            // skip to closing tag
            var tagMatch2 = null;
            while (tagMatch2 = tagsRE.exec(html)) {
              var tag2 = new Tag(tagMatch2[3], tagMatch2[1], tagMatch2[4], options);
              if (tag2.isClosing && tag2.name == tag.name) {
                element.children.push(RegExp.leftContext.substring(lastIndex));
                lastIndex = tagsRE.lastIndex;
                break;
              }
            }
          } else {
            // set as current container element
            if (!tag.isSelfClosing && !tag.isNonClosing) {
              stack.push(element);
              container = element;
            }
          }
        }
      }
    }

    // render doc
    return render(root, options).join("");
  };

  // defaults
  $.htmlClean.defaults = {
    // only clean the body tagbody
    bodyOnly: true,
    // only allow tags in this array, (white list), contents still rendered
    allowedTags: [],
    // remove tags in this array, (black list), contents still rendered
    removeTags: ["basefont", "center", "dir", "font", "frame", "frameset", "iframe", "isindex", "menu", "noframes", "s", "strike", "u"],
    // array of attribute names to remove on all elements in addition to those not in tagAttributes e.g ["width", "height"]
    removeAttrs: [],
    // array of [className], [optional array of allowed on elements] e.g. [["class"], ["anotherClass", ["p", "dl"]]]
    allowedClasses: [],
    // tags not rendered, contents remain
    notRenderedTags: [],
    // format the result
    format: false,
    // format indent to start on
    formatIndent: 0,
    // tags to replace, and what to replace with, tag name or regex to match the tag and attributes
    replace: [
      [
        ["b", "big"],
        "strong"
      ],
      [
        ["i"],
        "em"
      ]
    ],
    // styles to replace with tags, multiple style matches supported, inline tags are replaced by the first match blocks are retained
    replaceStyles: [
      [/font-weight:\s*bold/i, "strong"],
      [/font-style:\s*italic/i, "em"],
      [/vertical-align:\s*super/i, "sup"],
      [/vertical-align:\s*sub/i, "sub"]
    ]
  };

  function applyFormat(element, options, output, indent) {
    if (!element.tag.isInline && output.length > 0) {
      output.push("\n");
      for (var i = 0; i < indent; i++) output.push("\t");
    }
  }

  function render(element, options) {
    var output = [],
        empty = element.attributes.length == 0,
        indent = 0,
        outputChildren = null;

    // don't render if not in allowedTags or in removeTags
    var renderTag
      = element.tag.render
      && (options.allowedTags.length == 0 || $.inArray(element.tag.name, options.allowedTags) > -1)
      && (options.removeTags.length == 0 || $.inArray(element.tag.name, options.removeTags) == -1);

    if (!element.isRoot && renderTag) {
      // render opening tag
      output.push("<");
      output.push(element.tag.name);
      $.each(element.attributes, function () {
        if ($.inArray(this.name, options.removeAttrs) == -1) {
          var m = new RegExp(/^(['"]?)(.*?)['"]?$/).exec(this.value);
          var value = m[2];
          var valueQuote = m[1] || "'";

          // check for classes allowed
          if (this.name == "class") {
            value =
              $.grep(value.split(" "), function (c) {
                return $.grep(options.allowedClasses,
                  function (a) {
                    return a[0] == c && (a.length == 1 || $.inArray(element.tag.name, a[1]) > -1);
                  }).length > 0;
              })
                .join(" ");
            valueQuote = "'";
          }

          if (value != null && (value.length > 0 || $.inArray(this.name, element.tag.requiredAttributes) > -1)) {
            output.push(" ");
            output.push(this.name);
            output.push("=");
            output.push(valueQuote);
            output.push(value);
            output.push(valueQuote);
          }
        }
      });
    }

    if (element.tag.isSelfClosing) {
      // self closing
      if (renderTag) output.push(" />");
      empty = false;
    } else if (element.tag.isNonClosing) {
      empty = false;
    } else {
      if (!element.isRoot && renderTag) {
        // close
        output.push(">");
      }

      indent = options.formatIndent++;

      // render children
      if (element.tag.toProtect) {
        outputChildren = $.htmlClean.trim(element.children.join("")).replace(/<br>/ig, "\n");
        output.push(outputChildren);
        empty = outputChildren.length == 0;
        options.formatIndent--;
      } else {
        outputChildren = [];
        for (var i = 0; i < element.children.length; i++) {
          var child = element.children[i];
          var text = $.htmlClean.trim(textClean(isText(child) ? child : child.childrenToString()));
          if (isInline(child)) {
            if (i > 0 && text.length > 0
              && (startsWithWhitespace(child) || endsWithWhitespace(element.children[i - 1]))) {
              outputChildren.push(" ");
            }
          }
          if (isText(child)) {
            if (text.length > 0) {
              outputChildren.push(text);
            }
          } else {
            // don't allow a break to be the last child
            if (i != element.children.length - 1 || child.tag.name != "br") {
              if (options.format) applyFormat(child, options, outputChildren, indent);
              outputChildren = outputChildren.concat(render(child, options));
            }
          }
        }
        options.formatIndent--;

        if (outputChildren.length > 0) {
          if (options.format && outputChildren[0] != "\n") applyFormat(element, options, output, indent);
          output = output.concat(outputChildren);
          empty = false;
        }
      }

      if (!element.isRoot && renderTag) {
        // render the closing tag
        if (options.format) applyFormat(element, options, output, indent - 1);
        output.push("</");
        output.push(element.tag.name);
        output.push(">");
      }
    }

    // check for empty tags
    if (!element.tag.allowEmpty && empty) {
      return [];
    }

    return output;
  }

  // find a matching tag, and pop to it, if not do nothing
  function pop(stack, tagNameArray, index) {
    index = index || 1;
    if ($.inArray(stack[stack.length - index].tag.name, tagNameArray) > -1) {
      return true;
    } else if (stack.length - (index + 1) > 0
      && pop(stack, tagNameArray, index + 1)) {
      stack.pop();
      return true;
    }
    return false;
  }

  // Element Object
  function Element(tag) {
    if (tag) {
      this.tag = tag;
      this.isRoot = false;
    } else {
      this.tag = new Tag("root");
      this.isRoot = true;
    }
    this.attributes = [];
    this.children = [];

    this.hasAttribute = function (name) {
      for (var i = 0; i < this.attributes.length; i++) {
        if (this.attributes[i].name == name) return true;
      }
      return false;
    };

    this.childrenToString = function () {
      return this.children.join("");
    };

    return this;
  }

  // Attribute Object
  function Attribute(name, value) {
    this.name = name;
    this.value = value;

    return this;
  }

  // Tag object
  function Tag(name, close, rawAttributes, options) {
    this.name = name.toLowerCase();

    this.isSelfClosing = $.inArray(this.name, tagSelfClosing) > -1;
    this.isNonClosing = $.inArray(this.name, tagNonClosing) > -1;
    this.isClosing = (close != undefined && close.length > 0);

    this.isInline = $.inArray(this.name, tagInline) > -1;
    this.disallowNest = $.inArray(this.name, tagDisallowNest) > -1;
    this.requiredParent = tagRequiredParent[$.inArray(this.name, tagRequiredParent) + 1];
    this.allowEmpty = $.inArray(this.name, tagAllowEmpty) > -1;

    this.toProtect = $.inArray(this.name, tagProtect) > -1;

    this.rawAttributes = rawAttributes;
    this.allowedAttributes = tagAttributes[$.inArray(this.name, tagAttributes) + 1];
    this.requiredAttributes = tagAttributesRequired[$.inArray(this.name, tagAttributesRequired) + 1];

    this.render = options && $.inArray(this.name, options.notRenderedTags) == -1;

    return this;
  }

  function startsWithWhitespace(item) {
    while (isElement(item) && item.children.length > 0) {
      item = item.children[0]
    }
    return isText(item) && item.length > 0 && $.htmlClean.isWhitespace(item.charAt(0));
  }

  function endsWithWhitespace(item) {
    while (isElement(item) && item.children.length > 0) {
      item = item.children[item.children.length - 1]
    }
    return isText(item) && item.length > 0 && $.htmlClean.isWhitespace(item.charAt(item.length - 1));
  }

  function isText(item) {
    return item.constructor == String;
  }

  function isInline(item) {
    return isText(item) || item.tag.isInline;
  }

  function isElement(item) {
    return item.constructor == Element;
  }

  function textClean(text) {
    return text.replace(/&nbsp;|\n/g, " ").replace(/\s\s+/g, " ");
  }

  // trim off white space, doesn't use regex
  $.htmlClean.trim = function (text) {
    return $.htmlClean.trimStart($.htmlClean.trimEnd(text));
  };
  $.htmlClean.trimStart = function (text) {
    return text.substring($.htmlClean.trimStartIndex(text));
  };
  $.htmlClean.trimStartIndex = function (text) {
    for (var start = 0; start < text.length - 1 && $.htmlClean.isWhitespace(text.charAt(start)); start++);
    return start;
  };
  $.htmlClean.trimEnd = function (text) {
    return text.substring(0, $.htmlClean.trimEndIndex(text));
  };
  $.htmlClean.trimEndIndex = function (text) {
    for (var end = text.length - 1; end >= 0 && $.htmlClean.isWhitespace(text.charAt(end)); end--);
    return end + 1;
  };
  // checks a char is white space or not
  $.htmlClean.isWhitespace = function (c) {
    return $.inArray(c, whitespace) != -1;
  };

  // tags which are inline
  var tagInline = [
    "a", "abbr", "acronym", "address", "b", "big", "br", "button",
    "caption", "cite", "code", "del", "em", "font",
    "hr", "i", "input", "img", "ins", "label", "legend", "map", "q",
    "samp", "select", "small", "span", "strong", "sub", "sup",
    "tt", "var"];
  var tagDisallowNest = ["h1", "h2", "h3", "h4", "h5", "h6", "p", "th", "td"];
  var tagAllowEmpty = ["th", "td"];
  var tagRequiredParent = [
    null,
    "li", ["ul", "ol"],
    "dt", ["dl"],
    "dd", ["dl"],
    "td", ["tr"],
    "th", ["tr"],
    "tr", ["table", "thead", "tbody", "tfoot"],
    "thead", ["table"],
    "tbody", ["table"],
    "tfoot", ["table"]
  ];
  var tagProtect = ["script", "style", "pre", "code"];
  // tags which self close e.g. <br />
  var tagSelfClosing = ["br", "hr", "img", "link", "meta"];
  // tags which do not close
  var tagNonClosing = ["!doctype", "?xml"];
  // attributes allowed on tags
  var tagAttributes = [
    ["class"], // default, for all tags not mentioned
    "?xml", [],
    "!doctype", [],
    "a", ["accesskey", "class", "href", "name", "title", "rel", "rev", "type", "tabindex"],
    "abbr", ["class", "title"],
    "acronym", ["class", "title"],
    "blockquote", ["cite", "class"],
    "button", ["class", "disabled", "name", "type", "value"],
    "del", ["cite", "class", "datetime"],
    "form", ["accept", "action", "class", "enctype", "method", "name"],
    "input", ["accept", "accesskey", "alt", "checked", "class", "disabled", "ismap", "maxlength", "name", "size", "readonly", "src", "tabindex", "type", "usemap", "value"],
    "img", ["alt", "class", "height", "src", "width"],
    "ins", ["cite", "class", "datetime"],
    "label", ["accesskey", "class", "for"],
    "legend", ["accesskey", "class"],
    "link", ["href", "rel", "type"],
    "meta", ["content", "http-equiv", "name", "scheme"],
    "map", ["name"],
    "optgroup", ["class", "disabled", "label"],
    "option", ["class", "disabled", "label", "selected", "value"],
    "q", ["class", "cite"],
    "td", ["colspan", "rowspan"],
    "th", ["colspan", "rowspan"],
    "script", ["src", "type"],
    "select", ["class", "disabled", "multiple", "name", "size", "tabindex"],
    "style", ["type"],
    "table", ["class", "summary"],
    "textarea", ["accesskey", "class", "cols", "disabled", "name", "readonly", "rows", "tabindex"]
  ];
  var tagAttributesRequired = [[], "img", ["alt"]];
  // white space chars
  var whitespace = [" ", " ", "\t", "\n", "\r", "\f"];

})(jQuery);
/*
 * LiquidMetal, version: 0.1 (2009-02-05)
 *
 * A mimetic poly-alloy of Quicksilver's scoring algorithm, essentially
 * LiquidMetal.
 *
 * For usage and examples, visit:
 * http://github.com/rmm5t/liquidmetal
 *
 * Licensed under the MIT:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright (c) 2009, Ryan McGeary (ryanonjavascript -[at]- mcgeary [*dot*] org)
 */

var LiquidMetal = function() {
  var SCORE_NO_MATCH = 0.0;
  var SCORE_MATCH = 1.0;
  var SCORE_TRAILING = 0.8;
  var SCORE_TRAILING_BUT_STARTED = 0.9;
  var SCORE_BUFFER = 0.85;

  return {
    score: function(string, abbreviation) {
      // Short circuits
      if (abbreviation.length == 0) return SCORE_TRAILING;
      if (abbreviation.length > string.length) return SCORE_NO_MATCH;

      var scores = this.buildScoreArray(string, abbreviation);

      var sum = 0.0;
      for (var i =0; i < scores.length; i++) {
        sum += scores[i];
      }

      return (sum / scores.length);
    },

    buildScoreArray: function(string, abbreviation) {
      var scores = new Array(string.length);
      var lower = string.toLowerCase();
      var chars = abbreviation.toLowerCase().split("");

      var lastIndex = -1;
      var started = false;
      for (var i =0; i < chars.length; i++) {
        var c = chars[i];
        var index = lower.indexOf(c, lastIndex+1);
        if (index < 0) return fillArray(scores, SCORE_NO_MATCH);
        if (index == 0) started = true;

        if (isNewWord(string, index)) {
          scores[index-1] = 1;
          fillArray(scores, SCORE_BUFFER, lastIndex+1, index-1);
        }
        else if (isUpperCase(string, index)) {
          fillArray(scores, SCORE_BUFFER, lastIndex+1, index);
        }
        else {
          fillArray(scores, SCORE_NO_MATCH, lastIndex+1, index);
        }

        scores[index] = SCORE_MATCH;
        lastIndex = index;
      }

      var trailingScore = started ? SCORE_TRAILING_BUT_STARTED : SCORE_TRAILING;
      fillArray(scores, trailingScore, lastIndex+1);
      return scores;
    }
  };

  function isUpperCase(string, index) {
    var c = string.charAt(index);
    return ("A" <= c && c <= "Z");
  }

   function isNewWord(string, index) {
    var c = string.charAt(index-1);
    return (c == " " || c == "\t");
  }

  function fillArray(array, value, from, to) {
    from = Math.max(from || 0, 0);
    to = Math.min(to || array.length, array.length);
    for (var i = from; i < to; i++) { array[i] = value; }
    return array;
  }
}();
//
// showdown.js -- A javascript port of Markdown.
//
// Copyright (c) 2007 John Fraser.
//
// Original Markdown Copyright (c) 2004-2005 John Gruber
//   <http://daringfireball.net/projects/markdown/>
//
// Redistributable under a BSD-style open source license.
// See license.txt for more information.
//
// The full source distribution is at:
//
//				A A L
//				T C A
//				T K B
//
//   <http://www.attacklab.net/>
//

//
// Wherever possible, Showdown is a straight, line-by-line port
// of the Perl version of Markdown.
//
// This is not a normal parser design; it's basically just a
// series of string substitutions.  It's hard to read and
// maintain this way,  but keeping Showdown close to the original
// design makes it easier to port new features.
//
// More importantly, Showdown behaves like markdown.pl in most
// edge cases.  So web applications can do client-side preview
// in Javascript, and then build identical HTML on the server.
//
// This port needs the new RegExp functionality of ECMA 262,
// 3rd Edition (i.e. Javascript 1.5).  Most modern web browsers
// should do fine.  Even with the new regular expression features,
// We do a lot of work to emulate Perl's regex functionality.
// The tricky changes in this file mostly have the "attacklab:"
// label.  Major or self-explanatory changes don't.
//
// Smart diff tools like Araxis Merge will be able to match up
// this file with markdown.pl in a useful way.  A little tweaking
// helps: in a copy of markdown.pl, replace "#" with "//" and
// replace "$text" with "text".  Be sure to ignore whitespace
// and line endings.
//


//
// Showdown usage:
//
//   var text = "Markdown *rocks*.";
//
//   var converter = new Showdown.converter();
//   var html = converter.makeHtml(text);
//
//   alert(html);
//
// Note: move the sample code to the bottom of this
// file before uncommenting it.
//


// **************************************************
// GitHub Flavored Markdown modifications by Tekkub
// http://github.github.com/github-flavored-markdown/
//
// Modifications are tagged with "GFM"
// **************************************************

//
// Showdown namespace
//
var Showdown = {};

//
// converter
//
// Wraps all "globals" so that the only thing
// exposed is makeHtml().
//
Showdown.converter = function() {

  // Global hashes, used by various utility routines
  var g_urls;
  var g_titles;
  var g_html_blocks;

  // Used to track when we're inside an ordered or unordered list
  // (see _ProcessListItems() for details):
  var g_list_level = 0;

  // Main function. The order in which other subs are called here is
  // essential. Link and image substitutions need to happen before
  // _EscapeSpecialCharsWithinTagAttributes(), so that any *'s or _'s in the <a>
  // and <img> tags get encoded.
  this.makeHtml = function(text) {

    // Clear the global hashes. If we don't clear these, you get conflicts
    // from other articles when generating a page which contains more than
    // one article (e.g. an index page that shows the N most recent
    // articles):
    g_urls = new Array();
    g_titles = new Array();
    g_html_blocks = new Array();

    // attacklab: Replace ~ with ~T
    // This lets us use tilde as an escape char to avoid md5 hashes
    // The choice of character is arbitray; anything that isn't
    // magic in Markdown will work.
    text = text.replace(/~/g, "~T");

    // attacklab: Replace $ with ~D
    // RegExp interprets $ as a special character
    // when it's in a replacement string
    text = text.replace(/\$/g, "~D");

    // Standardize line endings
    text = text.replace(/\r\n/g, "\n"); // DOS to Unix
    text = text.replace(/\r/g, "\n"); // Mac to Unix

    // Make sure text begins and ends with a couple of newlines:
    text = "\n\n" + text + "\n\n";

    // Convert all tabs to spaces.
    text = _Detab(text);

    // Strip any lines consisting only of spaces and tabs.
    // This makes subsequent regexen easier to write, because we can
    // match consecutive blank lines with /\n+/ instead of something
    // contorted like /[ \t]*\n+/ .
    text = text.replace(/^[ \t]+$/mg, "");

    // Turn block-level HTML blocks into hash entries
    text = _HashHTMLBlocks(text);

    // Strip link definitions, store in hashes.
    text = _StripLinkDefinitions(text);

    text = _RunBlockGamut(text);

    text = _UnescapeSpecialChars(text);

    // attacklab: Restore dollar signs
    text = text.replace(/~D/g, "$$");

    // attacklab: Restore tildes
    text = text.replace(/~T/g, "~");

    // ** GFM **  Auto-link URLs and emails
    text = text.replace(/https?\:\/\/[^"\s\<\>]*[^.,;'">\:\s\<\>\)\]\!]/g, function(wholeMatch, matchIndex) {
      var left = text.slice(0, matchIndex), right = text.slice(matchIndex);
      if (left.match(/<[^>]+$/) && right.match(/^[^>]*>/)) {
        return wholeMatch
      }
      var href = wholeMatch.replace(/^http:\/\/github.com\//, "https://github.com/");
      return "<a href='" + href + "'>" + wholeMatch + "</a>";
    });
    text = text.replace(/[a-z0-9_\-+=.]+@[a-z0-9\-]+(\.[a-z0-9-]+)+/ig, function(wholeMatch) {
      return "<a href='mailto:" + wholeMatch + "'>" + wholeMatch + "</a>";
    });

    // ** GFM ** Auto-link sha1 if GitHub.nameWithOwner is defined
    text = text.replace(/[a-f0-9]{40}/ig, function(wholeMatch, matchIndex) {
      if (typeof(GitHub) == "undefined" || typeof(GitHub.nameWithOwner) == "undefined") {
        return wholeMatch;
      }
      var left = text.slice(0, matchIndex), right = text.slice(matchIndex);
      if (left.match(/@$/) || (left.match(/<[^>]+$/) && right.match(/^[^>]*>/))) {
        return wholeMatch;
      }
      return "<a href='http://github.com/" + GitHub.nameWithOwner + "/commit/" + wholeMatch + "'>" + wholeMatch.substring(0, 7) + "</a>";
    });

    // ** GFM ** Auto-link user@sha1 if GitHub.nameWithOwner is defined
    text = text.replace(/([a-z0-9_\-+=.]+)@([a-f0-9]{40})/ig, function(wholeMatch, username, sha, matchIndex) {
      if (typeof(GitHub) == "undefined" || typeof(GitHub.nameWithOwner) == "undefined") {
        return wholeMatch;
      }
      GitHub.repoName = GitHub.repoName || _GetRepoName();
      var left = text.slice(0, matchIndex), right = text.slice(matchIndex);
      if (left.match(/\/$/) || (left.match(/<[^>]+$/) && right.match(/^[^>]*>/))) {
        return wholeMatch;
      }
      return "<a href='http://github.com/" + username + "/" + GitHub.repoName + "/commit/" + sha + "'>" + username + "@" + sha.substring(0, 7) + "</a>";
    });

    // ** GFM ** Auto-link user/repo@sha1
    text = text.replace(/([a-z0-9_\-+=.]+\/[a-z0-9_\-+=.]+)@([a-f0-9]{40})/ig, function(wholeMatch, repo, sha) {
      return "<a href='http://github.com/" + repo + "/commit/" + sha + "'>" + repo + "@" + sha.substring(0, 7) + "</a>";
    });

    // ** GFM ** Auto-link #issue if GitHub.nameWithOwner is defined
    text = text.replace(/#([0-9]+)/ig, function(wholeMatch, issue, matchIndex) {
      if (typeof(GitHub) == "undefined" || typeof(GitHub.nameWithOwner) == "undefined") {
        return wholeMatch;
      }
      var left = text.slice(0, matchIndex), right = text.slice(matchIndex);
      if (left == "" || left.match(/[a-z0-9_\-+=.]$/) || (left.match(/<[^>]+$/) && right.match(/^[^>]*>/))) {
        return wholeMatch;
      }
      return "<a href='http://github.com/" + GitHub.nameWithOwner + "/issues/#issue/" + issue + "'>" + wholeMatch + "</a>";
    });

    // ** GFM ** Auto-link user#issue if GitHub.nameWithOwner is defined
    text = text.replace(/([a-z0-9_\-+=.]+)#([0-9]+)/ig, function(wholeMatch, username, issue, matchIndex) {
      if (typeof(GitHub) == "undefined" || typeof(GitHub.nameWithOwner) == "undefined") {
        return wholeMatch;
      }
      GitHub.repoName = GitHub.repoName || _GetRepoName();
      var left = text.slice(0, matchIndex), right = text.slice(matchIndex);
      if (left.match(/\/$/) || (left.match(/<[^>]+$/) && right.match(/^[^>]*>/))) {
        return wholeMatch;
      }
      return "<a href='http://github.com/" + username + "/" + GitHub.repoName + "/issues/#issue/" + issue + "'>" + wholeMatch + "</a>";
    });

    // ** GFM ** Auto-link user/repo#issue
    text = text.replace(/([a-z0-9_\-+=.]+\/[a-z0-9_\-+=.]+)#([0-9]+)/ig, function(wholeMatch, repo, issue) {
      return "<a href='http://github.com/" + repo + "/issues/#issue/" + issue + "'>" + wholeMatch + "</a>";
    });

    return text;
  };


  var _GetRepoName = function() {
    return GitHub.nameWithOwner.match(/^.+\/(.+)$/)[1]
  };

  //
  // Strips link definitions from text, stores the URLs and titles in
  // hash references.
  //
  var _StripLinkDefinitions = function(text) {

    // Link defs are in the form: ^[id]: url "optional title"

    /*
     var text = text.replace(/
     ^[ ]{0,3}\[(.+)\]:  // id = $1  attacklab: g_tab_width - 1
     [ \t]*
     \n?				// maybe *one* newline
     [ \t]*
     <?(\S+?)>?			// url = $2
     [ \t]*
     \n?				// maybe one newline
     [ \t]*
     (?:
     (\n*)				// any lines skipped = $3 attacklab: lookbehind removed
     ["(]
     (.+?)				// title = $4
     [")]
     [ \t]*
     )?					// title is optional
     (?:\n+|$)
     /gm,
     function(){...});
     */
    var text = text.replace(/^[ ]{0,3}\[(.+)\]:[ \t]*\n?[ \t]*<?(\S+?)>?[ \t]*\n?[ \t]*(?:(\n*)["(](.+?)[")][ \t]*)?(?:\n+|\Z)/gm, function (wholeMatch, m1, m2, m3, m4) {
      m1 = m1.toLowerCase();
      g_urls[m1] = _EncodeAmpsAndAngles(m2);  // Link IDs are case-insensitive
      if (m3) {
        // Oops, found blank lines, so it's not a title.
        // Put back the parenthetical statement we stole.
        return m3 + m4;
      } else if (m4) {
        g_titles[m1] = m4.replace(/"/g, "&quot;");
      }

      // Completely remove the definition from the text
      return "";
    });

    return text;
  };


  var _HashHTMLBlocks = function(text) {
    // attacklab: Double up blank lines to reduce lookaround
    text = text.replace(/\n/g, "\n\n");

    // Hashify HTML blocks:
    // We only want to do this for block-level HTML tags, such as headers,
    // lists, and tables. That's because we still want to wrap <p>s around
    // "paragraphs" that are wrapped in non-block-level tags, such as anchors,
    // phrase emphasis, and spans. The list of tags we're looking for is
    // hard-coded:
    var block_tags_a = "p|div|h[1-6]|blockquote|pre|table|dl|ol|ul|script|noscript|form|fieldset|iframe|math|ins|del";
    var block_tags_b = "p|div|h[1-6]|blockquote|pre|table|dl|ol|ul|script|noscript|form|fieldset|iframe|math";

    // First, look for nested blocks, e.g.:
    //   <div>
    //     <div>
    //     tags for inner block must be indented.
    //     </div>
    //   </div>
    //
    // The outermost tags must start at the left margin for this to match, and
    // the inner nested divs must be indented.
    // We need to do this before the next, more liberal match, because the next
    // match will start at the first `<div>` and stop at the first `</div>`.

    // attacklab: This regex can be expensive when it fails.
    /*
     var text = text.replace(/
     (						// save in $1
     ^					// start of line  (with /m)
     <($block_tags_a)	// start tag = $2
     \b					// word break
     // attacklab: hack around khtml/pcre bug...
     [^\r]*?\n			// any number of lines, minimally matching
     </\2>				// the matching end tag
     [ \t]*				// trailing spaces/tabs
     (?=\n+)				// followed by a newline
     )						// attacklab: there are sentinel newlines at end of document
     /gm,function(){...}};
     */
    text = text.replace(/^(<(p|div|h[1-6]|blockquote|pre|table|dl|ol|ul|script|noscript|form|fieldset|iframe|math|ins|del)\b[^\r]*?\n<\/\2>[ \t]*(?=\n+))/gm, hashElement);

    //
    // Now match more liberally, simply from `\n<tag>` to `</tag>\n`
    //

    /*
     var text = text.replace(/
     (						// save in $1
     ^					// start of line  (with /m)
     <($block_tags_b)	// start tag = $2
     \b					// word break
     // attacklab: hack around khtml/pcre bug...
     [^\r]*?				// any number of lines, minimally matching
     .*</\2>				// the matching end tag
     [ \t]*				// trailing spaces/tabs
     (?=\n+)				// followed by a newline
     )						// attacklab: there are sentinel newlines at end of document
     /gm,function(){...}};
     */
    text = text.replace(/^(<(p|div|h[1-6]|blockquote|pre|table|dl|ol|ul|script|noscript|form|fieldset|iframe|math)\b[^\r]*?.*<\/\2>[ \t]*(?=\n+)\n)/gm, hashElement);

    // Special case just for <hr />. It was easier to make a special case than
    // to make the other regex more complicated.

    /*
     text = text.replace(/
     (						// save in $1
     \n\n				// Starting after a blank line
     [ ]{0,3}
     (<(hr)				// start tag = $2
     \b					// word break
     ([^<>])*?			//
     \/?>)				// the matching end tag
     [ \t]*
     (?=\n{2,})			// followed by a blank line
     )
     /g,hashElement);
     */
    text = text.replace(/(\n[ ]{0,3}(<(hr)\b([^<>])*?\/?>)[ \t]*(?=\n{2,}))/g, hashElement);

    // Special case for standalone HTML comments:

    /*
     text = text.replace(/
     (						// save in $1
     \n\n				// Starting after a blank line
     [ ]{0,3}			// attacklab: g_tab_width - 1
     <!
     (--[^\r]*?--\s*)+
     >
     [ \t]*
     (?=\n{2,})			// followed by a blank line
     )
     /g,hashElement);
     */
    text = text.replace(/(\n\n[ ]{0,3}<!(--[^\r]*?--\s*)+>[ \t]*(?=\n{2,}))/g, hashElement);

    // PHP and ASP-style processor instructions (<?...?> and <%...%>)

    /*
     text = text.replace(/
     (?:
     \n\n				// Starting after a blank line
     )
     (						// save in $1
     [ ]{0,3}			// attacklab: g_tab_width - 1
     (?:
     <([?%])			// $2
     [^\r]*?
     \2>
     )
     [ \t]*
     (?=\n{2,})			// followed by a blank line
     )
     /g,hashElement);
     */
    text = text.replace(/(?:\n\n)([ ]{0,3}(?:<([?%])[^\r]*?\2>)[ \t]*(?=\n{2,}))/g, hashElement);

    // attacklab: Undo double lines (see comment at top of this function)
    text = text.replace(/\n\n/g, "\n");
    return text;
  };

  var hashElement = function(wholeMatch, m1) {
    var blockText = m1;

    // Undo double lines
    blockText = blockText.replace(/\n\n/g, "\n");
    blockText = blockText.replace(/^\n/, "");

    // strip trailing blank lines
    blockText = blockText.replace(/\n+$/g, "");

    // Replace the element text with a marker ("~KxK" where x is its key)
    blockText = "\n\n~K" + (g_html_blocks.push(blockText) - 1) + "K\n\n";

    return blockText;
  };

  //
  // These are all the transformations that form block-level
  // tags like paragraphs, headers, and list items.
  //
  var _RunBlockGamut = function(text) {
    text = _DoHeaders(text);

    // Do Horizontal Rules:
    var key = hashBlock("<hr />");
    text = text.replace(/^[ ]{0,2}([ ]?\*[ ]?){3,}[ \t]*$/gm, key);
    text = text.replace(/^[ ]{0,2}([ ]?\-[ ]?){3,}[ \t]*$/gm, key);
    text = text.replace(/^[ ]{0,2}([ ]?\_[ ]?){3,}[ \t]*$/gm, key);

    text = _DoLists(text);
    text = _DoCodeBlocks(text);
    text = _DoBlockQuotes(text);

    // We already ran _HashHTMLBlocks() before, in Markdown(), but that
    // was to escape raw HTML in the original Markdown source. This time,
    // we're escaping the markup we've just created, so that we don't wrap
    // <p> tags around block-level tags.
    text = _HashHTMLBlocks(text);
    text = _FormParagraphs(text);

    return text;
  };

  //
  // These are all the transformations that occur *within* block-level
  // tags like paragraphs, headers, and list items.
  //
  var _RunSpanGamut = function(text) {

    text = _DoCodeSpans(text);
    text = _EscapeSpecialCharsWithinTagAttributes(text);
    text = _EncodeBackslashEscapes(text);

    // Process anchor and image tags. Images must come first,
    // because ![foo][f] looks like an anchor.
    text = _DoImages(text);
    text = _DoAnchors(text);

    // Make links out of things like `<http://example.com/>`
    // Must come after _DoAnchors(), because you can use < and >
    // delimiters in inline links like [this](<url>).
    text = _DoAutoLinks(text);
    text = _EncodeAmpsAndAngles(text);
    text = _DoItalicsAndBold(text);

    // Do hard breaks:
    text = text.replace(/  +\n/g, " <br />\n");

    return text;
  };

  //
  // Within tags -- meaning between < and > -- encode [\ ` * _] so they
  // don't conflict with their use in Markdown for code, italics and strong.
  //
  var _EscapeSpecialCharsWithinTagAttributes = function(text) {

    // Build a regex to find HTML tags and comments.  See Friedl's
    // "Mastering Regular Expressions", 2nd Ed., pp. 200-201.
    var regex = /(<[a-z\/!$]("[^"]*"|'[^']*'|[^'">])*>|<!(--.*?--\s*)+>)/gi;

    text = text.replace(regex, function(wholeMatch) {
      var tag = wholeMatch.replace(/(.)<\/?code>(?=.)/g, "$1`");
      tag = escapeCharacters(tag, "\\`*_");
      return tag;
    });

    return text;
  };

  //
  // Turn Markdown link shortcuts into XHTML <a> tags.
  //
  var _DoAnchors = function(text) {
    //
    // First, handle reference-style links: [link text] [id]
    //

    /*
     text = text.replace(/
     (							// wrap whole match in $1
     \[
     (
     (?:
     \[[^\]]*\]		// allow brackets nested one level
     |
     [^\[]			// or anything else
     )*
     )
     \]

     [ ]?					// one optional space
     (?:\n[ ]*)?				// one optional newline followed by spaces

     \[
     (.*?)					// id = $3
     \]
     )()()()()					// pad remaining backreferences
     /g,_DoAnchors_callback);
     */
    text = text.replace(/(\[((?:\[[^\]]*\]|[^\[\]])*)\][ ]?(?:\n[ ]*)?\[(.*?)\])()()()()/g, writeAnchorTag);

    //
    // Next, inline-style links: [link text](url "optional title")
    //

    /*
     text = text.replace(/
     (						// wrap whole match in $1
     \[
     (
     (?:
     \[[^\]]*\]	// allow brackets nested one level
     |
     [^\[\]]			// or anything else
     )
     )
     \]
     \(						// literal paren
     [ \t]*
     ()						// no id, so leave $3 empty
     <?(.*?)>?				// href = $4
     [ \t]*
     (						// $5
     (['"])				// quote char = $6
     (.*?)				// Title = $7
     \6					// matching quote
     [ \t]*				// ignore any spaces/tabs between closing quote and )
     )?						// title is optional
     \)
     )
     /g,writeAnchorTag);
     */
    text = text.replace(/(\[((?:\[[^\]]*\]|[^\[\]])*)\]\([ \t]*()<?(.*?)>?[ \t]*((['"])(.*?)\6[ \t]*)?\))/g, writeAnchorTag);

    //
    // Last, handle reference-style shortcuts: [link text]
    // These must come last in case you've also got [link test][1]
    // or [link test](/foo)
    //

    /*
     text = text.replace(/
     (		 					// wrap whole match in $1
     \[
     ([^\[\]]+)				// link text = $2; can't contain '[' or ']'
     \]
     )()()()()()					// pad rest of backreferences
     /g, writeAnchorTag);
     */
    text = text.replace(/(\[([^\[\]]+)\])()()()()()/g, writeAnchorTag);

    return text;
  };

  var writeAnchorTag = function(wholeMatch, m1, m2, m3, m4, m5, m6, m7) {
    if (m7 == undefined) m7 = "";
    var whole_match = m1;
    var link_text = m2;
    var link_id = m3.toLowerCase();
    var url = m4;
    var title = m7;

    if (url == "") {
      if (link_id == "") {
        // lower-case and turn embedded newlines into spaces
        link_id = link_text.toLowerCase().replace(/ ?\n/g, " ");
      }
      url = "#" + link_id;

      if (g_urls[link_id] != undefined) {
        url = g_urls[link_id];
        if (g_titles[link_id] != undefined) {
          title = g_titles[link_id];
        }
      }
      else {
        if (whole_match.search(/\(\s*\)$/m) > -1) {
          // Special case for explicit empty url
          url = "";
        } else {
          return whole_match;
        }
      }
    }

    url = escapeCharacters(url, "*_");
    var result = "<a href=\"" + url + "\"";

    if (title != "") {
      title = title.replace(/"/g, "&quot;");
      title = escapeCharacters(title, "*_");
      result += " title=\"" + title + "\"";
    }

    result += ">" + link_text + "</a>";

    return result;
  };


  //
  // Turn Markdown image shortcuts into <img> tags.
  //
  var _DoImages = function(text) {
    //
    // First, handle reference-style labeled images: ![alt text][id]
    //

    /*
     text = text.replace(/
     (						// wrap whole match in $1
     !\[
     (.*?)				// alt text = $2
     \]

     [ ]?				// one optional space
     (?:\n[ ]*)?			// one optional newline followed by spaces

     \[
     (.*?)				// id = $3
     \]
     )()()()()				// pad rest of backreferences
     /g,writeImageTag);
     */
    text = text.replace(/(!\[(.*?)\][ ]?(?:\n[ ]*)?\[(.*?)\])()()()()/g, writeImageTag);

    //
    // Next, handle inline images:  ![alt text](url "optional title")
    // Don't forget: encode * and _

    /*
     text = text.replace(/
     (						// wrap whole match in $1
     !\[
     (.*?)				// alt text = $2
     \]
     \s?					// One optional whitespace character
     \(					// literal paren
     [ \t]*
     ()					// no id, so leave $3 empty
     <?(\S+?)>?			// src url = $4
     [ \t]*
     (					// $5
     (['"])			// quote char = $6
     (.*?)			// title = $7
     \6				// matching quote
     [ \t]*
     )?					// title is optional
     \)
     )
     /g,writeImageTag);
     */
    text = text.replace(/(!\[(.*?)\]\s?\([ \t]*()<?(\S+?)>?[ \t]*((['"])(.*?)\6[ \t]*)?\))/g, writeImageTag);

    return text;
  };

  var writeImageTag = function(wholeMatch, m1, m2, m3, m4, m5, m6, m7) {
    var whole_match = m1;
    var alt_text = m2;
    var link_id = m3.toLowerCase();
    var url = m4;
    var title = m7;

    if (!title) title = "";

    if (url == "") {
      if (link_id == "") {
        // lower-case and turn embedded newlines into spaces
        link_id = alt_text.toLowerCase().replace(/ ?\n/g, " ");
      }
      url = "#" + link_id;

      if (g_urls[link_id] != undefined) {
        url = g_urls[link_id];
        if (g_titles[link_id] != undefined) {
          title = g_titles[link_id];
        }
      }
      else {
        return whole_match;
      }
    }

    alt_text = alt_text.replace(/"/g, "&quot;");
    url = escapeCharacters(url, "*_");
    var result = "<img src=\"" + url + "\" alt=\"" + alt_text + "\"";

    // attacklab: Markdown.pl adds empty title attributes to images.
    // Replicate this bug.

    //if (title != "") {
    title = title.replace(/"/g, "&quot;");
    title = escapeCharacters(title, "*_");
    result += " title=\"" + title + "\"";
    //}

    result += " />";

    return result;
  };


  var _DoHeaders = function(text) {

    // Setext-style headers:
    //	Header 1
    //	========
    //
    //	Header 2
    //	--------
    //
    text = text.replace(/^(.+)[ \t]*\n=+[ \t]*\n+/gm,
            function(wholeMatch, m1) {
              return hashBlock("<h1>" + _RunSpanGamut(m1) + "</h1>");
            });

    text = text.replace(/^(.+)[ \t]*\n-+[ \t]*\n+/gm,
            function(matchFound, m1) {
              return hashBlock("<h2>" + _RunSpanGamut(m1) + "</h2>");
            });

    // atx-style headers:
    //  # Header 1
    //  ## Header 2
    //  ## Header 2 with closing hashes ##
    //  ...
    //  ###### Header 6
    //

    /*
     text = text.replace(/
     ^(\#{1,6})				// $1 = string of #'s
     [ \t]*
     (.+?)					// $2 = Header text
     [ \t]*
     \#*						// optional closing #'s (not counted)
     \n+
     /gm, function() {...});
     */

    text = text.replace(/^(\#{1,6})[ \t]*(.+?)[ \t]*\#*\n+/gm,
            function(wholeMatch, m1, m2) {
              var h_level = m1.length;
              return hashBlock("<h" + h_level + ">" + _RunSpanGamut(m2) + "</h" + h_level + ">");
            });

    return text;
  };

  // This declaration keeps Dojo compressor from outputting garbage:
  var _ProcessListItems;

  //
  // Form HTML ordered (numbered) and unordered (bulleted) lists.
  //
  var _DoLists = function(text) {

    // attacklab: add sentinel to hack around khtml/safari bug:
    // http://bugs.webkit.org/show_bug.cgi?id=11231
    text += "~0";

    // Re-usable pattern to match any entirel ul or ol list:

    /*
     var whole_list = /
     (									// $1 = whole list
     (								// $2
     [ ]{0,3}					// attacklab: g_tab_width - 1
     ([*+-]|\d+[.])				// $3 = first list item marker
     [ \t]+
     )
     [^\r]+?
     (								// $4
     ~0							// sentinel for workaround; should be $
     |
     \n{2,}
     (?=\S)
     (?!							// Negative lookahead for another list item marker
     [ \t]*
     (?:[*+-]|\d+[.])[ \t]+
     )
     )
     )/g
     */
    var whole_list = /^(([ ]{0,3}([*+-]|\d+[.])[ \t]+)[^\r]+?(~0|\n{2,}(?=\S)(?![ \t]*(?:[*+-]|\d+[.])[ \t]+)))/gm;

    if (g_list_level) {
      text = text.replace(whole_list, function(wholeMatch, m1, m2) {
        var list = m1;
        var list_type = (m2.search(/[*+-]/g) > -1) ? "ul" : "ol";

        // Turn double returns into triple returns, so that we can make a
        // paragraph for the last item in a list, if necessary:
        list = list.replace(/\n{2,}/g, "\n\n\n");
        var result = _ProcessListItems(list);

        // Trim any trailing whitespace, to put the closing `</$list_type>`
        // up on the preceding line, to get it past the current stupid
        // HTML block parser. This is a hack to work around the terrible
        // hack that is the HTML block parser.
        result = result.replace(/\s+$/, "");
        result = "<" + list_type + ">" + result + "</" + list_type + ">\n";
        return result;
      });
    } else {
      whole_list = /(\n\n|^\n?)(([ ]{0,3}([*+-]|\d+[.])[ \t]+)[^\r]+?(~0|\n{2,}(?=\S)(?![ \t]*(?:[*+-]|\d+[.])[ \t]+)))/g;
      text = text.replace(whole_list, function(wholeMatch, m1, m2, m3) {
        var runup = m1;
        var list = m2;

        var list_type = (m3.search(/[*+-]/g) > -1) ? "ul" : "ol";
        // Turn double returns into triple returns, so that we can make a
        // paragraph for the last item in a list, if necessary:
        var list = list.replace(/\n{2,}/g, "\n\n\n");
        var result = _ProcessListItems(list);
        result = runup + "<" + list_type + ">\n" + result + "</" + list_type + ">\n";
        return result;
      });
    }

    // attacklab: strip sentinel
    text = text.replace(/~0/, "");

    return text;
  };

  //
  //  Process the contents of a single ordered or unordered list, splitting it
  //  into individual list items.
  //
  _ProcessListItems = function(list_str) {
    // The $g_list_level global keeps track of when we're inside a list.
    // Each time we enter a list, we increment it; when we leave a list,
    // we decrement. If it's zero, we're not in a list anymore.
    //
    // We do this because when we're not inside a list, we want to treat
    // something like this:
    //
    //    I recommend upgrading to version
    //    8. Oops, now this line is treated
    //    as a sub-list.
    //
    // As a single paragraph, despite the fact that the second line starts
    // with a digit-period-space sequence.
    //
    // Whereas when we're inside a list (or sub-list), that line will be
    // treated as the start of a sub-list. What a kludge, huh? This is
    // an aspect of Markdown's syntax that's hard to parse perfectly
    // without resorting to mind-reading. Perhaps the solution is to
    // change the syntax rules such that sub-lists must start with a
    // starting cardinal number; e.g. "1." or "a.".

    g_list_level++;

    // trim trailing blank lines:
    list_str = list_str.replace(/\n{2,}$/, "\n");

    // attacklab: add sentinel to emulate \z
    list_str += "~0";

    /*
     list_str = list_str.replace(/
     (\n)?							// leading line = $1
     (^[ \t]*)						// leading whitespace = $2
     ([*+-]|\d+[.]) [ \t]+			// list marker = $3
     ([^\r]+?						// list item text   = $4
     (\n{1,2}))
     (?= \n* (~0 | \2 ([*+-]|\d+[.]) [ \t]+))
     /gm, function(){...});
     */
    list_str = list_str.replace(/(\n)?(^[ \t]*)([*+-]|\d+[.])[ \t]+([^\r]+?(\n{1,2}))(?=\n*(~0|\2([*+-]|\d+[.])[ \t]+))/gm,
            function(wholeMatch, m1, m2, m3, m4) {
              var item = m4;
              var leading_line = m1;
              var leading_space = m2;

              if (leading_line || (item.search(/\n{2,}/) > -1)) {
                item = _RunBlockGamut(_Outdent(item));
              }
              else {
                // Recursion for sub-lists:
                item = _DoLists(_Outdent(item));
                item = item.replace(/\n$/, ""); // chomp(item)
                item = _RunSpanGamut(item);
              }

              return  "<li>" + item + "</li>\n";
            }
            );

    // attacklab: strip sentinel
    list_str = list_str.replace(/~0/g, "");

    g_list_level--;
    return list_str;
  };


  //
  //  Process Markdown `<pre><code>` blocks.
  //
  var _DoCodeBlocks = function(text) {

    /*
     text = text.replace(text,
     /(?:\n\n|^)
     (								// $1 = the code block -- one or more lines, starting with a space/tab
     (?:
     (?:[ ]{4}|\t)			// Lines must start with a tab or a tab-width of spaces - attacklab: g_tab_width
     .*\n+
     )+
     )
     (\n*[ ]{0,3}[^ \t\n]|(?=~0))	// attacklab: g_tab_width
     /g,function(){...});
     */

    // attacklab: sentinel workarounds for lack of \A and \Z, safari\khtml bug
    text += "~0";

    text = text.replace(/(?:\n\n|^)((?:(?:[ ]{4}|\t).*\n+)+)(\n*[ ]{0,3}[^ \t\n]|(?=~0))/g, function(wholeMatch, m1, m2) {
      var codeblock = m1;
      var nextChar = m2;

      codeblock = _EncodeCode(_Outdent(codeblock));
      codeblock = _Detab(codeblock);
      codeblock = codeblock.replace(/^\n+/g, ""); // trim leading newlines
      codeblock = codeblock.replace(/\n+$/g, ""); // trim trailing whitespace

      codeblock = "<pre><code>" + codeblock + "\n</code></pre>";

      return hashBlock(codeblock) + nextChar;
    });

    // attacklab: strip sentinel
    text = text.replace(/~0/, "");

    return text;
  };

  var hashBlock = function(text) {
    text = text.replace(/(^\n+|\n+$)/g, "");
    return "\n\n~K" + (g_html_blocks.push(text) - 1) + "K\n\n";
  };


  //
  //   *  Backtick quotes are used for <code></code> spans.
  //
  //   *  You can use multiple backticks as the delimiters if you want to
  //	 include literal backticks in the code span. So, this input:
  //
  //		 Just type ``foo `bar` baz`` at the prompt.
  //
  //	   Will translate to:
  //
  //		 <p>Just type <code>foo `bar` baz</code> at the prompt.</p>
  //
  //	There's no arbitrary limit to the number of backticks you
  //	can use as delimters. If you need three consecutive backticks
  //	in your code, use four for delimiters, etc.
  //
  //  *  You can use spaces to get literal backticks at the edges:
  //
  //		 ... type `` `bar` `` ...
  //
  //	   Turns to:
  //
  //		 ... type <code>`bar`</code> ...
  //
  var _DoCodeSpans = function(text) {
    /*
     text = text.replace(/
     (^|[^\\])					// Character before opening ` can't be a backslash
     (`+)						// $2 = Opening run of `
     (							// $3 = The code block
     [^\r]*?
     [^`]					// attacklab: work around lack of lookbehind
     )
     \2							// Matching closer
     (?!`)
     /gm, function(){...});
     */

    text = text.replace(/(^|[^\\])(`+)([^\r]*?[^`])\2(?!`)/gm,
            function(wholeMatch, m1, m2, m3, m4) {
              var c = m3;
              c = c.replace(/^([ \t]*)/g, "");	// leading whitespace
              c = c.replace(/[ \t]*$/g, "");	// trailing whitespace
              c = _EncodeCode(c);
              return m1 + "<code>" + c + "</code>";
            });

    return text;
  };


  //
  // Encode/escape certain characters inside Markdown code runs.
  // The point is that in code, these characters are literals,
  // and lose their special Markdown meanings.
  //
  var _EncodeCode = function(text) {
    // Encode all ampersands; HTML entities are not
    // entities within a Markdown code span.
    text = text.replace(/&/g, "&amp;");

    // Do the angle bracket song and dance:
    text = text.replace(/</g, "&lt;");
    text = text.replace(/>/g, "&gt;");

    // Now, escape characters that are magic in Markdown:
    text = escapeCharacters(text, "\*_{}[]\\", false);

    return text;
  };


  var _DoItalicsAndBold = function(text) {

    // <strong> must go first:
    text = text.replace(/(\*\*|__)(?=\S)([^\r]*?\S[*_]*)\1/g,
            "<strong>$2</strong>");

    text = text.replace(/(\w)_(\w)/g, "$1~E95E$2"); // ** GFM **  "~E95E" == escaped "_"
    text = text.replace(/(\*|_)(?=\S)([^\r]*?\S)\1/g,
            "<em>$2</em>");

    return text;
  };


  var _DoBlockQuotes = function(text) {

    /*
     text = text.replace(/
     (								// Wrap whole match in $1
     (
     ^[ \t]*>[ \t]?			// '>' at the start of a line
     .+\n					// rest of the first line
     (.+\n)*					// subsequent consecutive lines
     \n*						// blanks
     )+
     )
     /gm, function(){...});
     */

    text = text.replace(/((^[ \t]*>[ \t]?.+\n(.+\n)*\n*)+)/gm,
            function(wholeMatch, m1) {
              var bq = m1;

              // attacklab: hack around Konqueror 3.5.4 bug:
              // "----------bug".replace(/^-/g,"") == "bug"

              bq = bq.replace(/^[ \t]*>[ \t]?/gm, "~0");	// trim one level of quoting

              // attacklab: clean up hack
              bq = bq.replace(/~0/g, "");

              bq = bq.replace(/^[ \t]+$/gm, "");		// trim whitespace-only lines
              bq = _RunBlockGamut(bq);				// recurse

              bq = bq.replace(/(^|\n)/g, "$1  ");
              // These leading spaces screw with <pre> content, so we need to fix that:
              bq = bq.replace(
                      /(\s*<pre>[^\r]+?<\/pre>)/gm,
                      function(wholeMatch, m1) {
                        var pre = m1;
                        // attacklab: hack around Konqueror 3.5.4 bug:
                        pre = pre.replace(/^  /mg, "~0");
                        pre = pre.replace(/~0/g, "");
                        return pre;
                      });

              return hashBlock("<blockquote>\n" + bq + "\n</blockquote>");
            });
    return text;
  };


  //
  //  Params:
  //    $text - string to process with html <p> tags
  //
  var _FormParagraphs = function(text) {

    // Strip leading and trailing lines:
    text = text.replace(/^\n+/g, "");
    text = text.replace(/\n+$/g, "");

    var grafs = text.split(/\n{2,}/g);
    var grafsOut = new Array();

    //
    // Wrap <p> tags.
    //
    var end = grafs.length;
    for (var i = 0; i < end; i++) {
      var str = grafs[i];

      // if this is an HTML marker, copy it
      if (str.search(/~K(\d+)K/g) >= 0) {
        grafsOut.push(str);
      }
      else if (str.search(/\S/) >= 0) {
        str = _RunSpanGamut(str);
        str = str.replace(/\n/g, "<br />");  // ** GFM **
        str = str.replace(/^([ \t]*)/g, "<p>");
        str += "</p>";
        grafsOut.push(str);
      }

    }

    //
    // Unhashify HTML blocks
    //
    end = grafsOut.length;
    for (var i = 0; i < end; i++) {
      // if this is a marker for an html block...
      while (grafsOut[i].search(/~K(\d+)K/) >= 0) {
        var blockText = g_html_blocks[RegExp.$1];
        blockText = blockText.replace(/\$/g, "$$$$"); // Escape any dollar signs
        grafsOut[i] = grafsOut[i].replace(/~K\d+K/, blockText);
      }
    }

    return grafsOut.join("\n\n");
  };

  // Smart processing for ampersands and angle brackets that need to be encoded.
  var _EncodeAmpsAndAngles = function(text) {

    // Ampersand-encoding based entirely on Nat Irons's Amputator MT plugin:
    //   http://bumppo.net/projects/amputator/
    text = text.replace(/&(?!#?[xX]?(?:[0-9a-fA-F]+|\w+);)/g, "&amp;");

    // Encode naked <'s
    text = text.replace(/<(?![a-z\/?\$!])/gi, "&lt;");

    return text;
  };

  //
  //   Parameter:  String.
  //   Returns:	The string, with after processing the following backslash
  //			   escape sequences.
  //
  var _EncodeBackslashEscapes = function(text) {
    // attacklab: The polite way to do this is with the new
    // escapeCharacters() function:
    //
    // 	text = escapeCharacters(text,"\\",true);
    // 	text = escapeCharacters(text,"`*_{}[]()>#+-.!",true);
    //
    // ...but we're sidestepping its use of the (slow) RegExp constructor
    // as an optimization for Firefox.  This function gets called a LOT.

    text = text.replace(/\\(\\)/g, escapeCharacters_callback);
    text = text.replace(/\\([`*_{}\[\]()>#+-.!])/g, escapeCharacters_callback);
    return text;
  };

  var _DoAutoLinks = function(text) {

    text = text.replace(/<((https?|ftp|dict):[^'">\s]+)>/gi, "<a href=\"$1\">$1</a>");

    // Email addresses: <address@domain.foo>

    /*
     text = text.replace(/
     <
     (?:mailto:)?
     (
     [-.\w]+
     \@
     [-a-z0-9]+(\.[-a-z0-9]+)*\.[a-z]+
     )
     >
     /gi, _DoAutoLinks_callback());
     */
    text = text.replace(/<(?:mailto:)?([-.\w]+\@[-a-z0-9]+(\.[-a-z0-9]+)*\.[a-z]+)>/gi, function(wholeMatch, m1) {
      return _EncodeEmailAddress(_UnescapeSpecialChars(m1));
    });

    return text;
  };

  //
  //  Input: an email address, e.g. "foo@example.com"
  //
  //  Output: the email address as a mailto link, with each character
  //	of the address encoded as either a decimal or hex entity, in
  //	the hopes of foiling most address harvesting spam bots. E.g.:
  //
  //	<a href="&#x6D;&#97;&#105;&#108;&#x74;&#111;:&#102;&#111;&#111;&#64;&#101;
  //	   x&#x61;&#109;&#x70;&#108;&#x65;&#x2E;&#99;&#111;&#109;">&#102;&#111;&#111;
  //	   &#64;&#101;x&#x61;&#109;&#x70;&#108;&#x65;&#x2E;&#99;&#111;&#109;</a>
  //
  //  Based on a filter by Matthew Wickline, posted to the BBEdit-Talk
  //  mailing list: <http://tinyurl.com/yu7ue>
  //
  var _EncodeEmailAddress = function(addr) {

    // attacklab: why can't javascript speak hex?
    function char2hex(ch) {
      var hexDigits = '0123456789ABCDEF';
      var dec = ch.charCodeAt(0);
      return(hexDigits.charAt(dec >> 4) + hexDigits.charAt(dec & 15));
    }

    var encode = [
      function(ch) { return "&#" + ch.charCodeAt(0) + ";" },
      function(ch) { return "&#x" + char2hex(ch) + ";" },
      function(ch) { return ch }
    ];

    addr = "mailto:" + addr;

    addr = addr.replace(/./g, function(ch) {
      if (ch == "@") {
        // this *must* be encoded. I insist.
        ch = encode[Math.floor(Math.random() * 2)](ch);
      } else if (ch != ":") {
        // leave ':' alone (to spot mailto: later)
        var r = Math.random();
        // roughly 10% raw, 45% hex, 45% dec
        ch = (r > .9 ? encode[2](ch) : r > .45 ? encode[1](ch) : encode[0](ch));
      }
      return ch;
    });

    addr = "<a href=\"" + addr + "\">" + addr + "</a>";
    addr = addr.replace(/">.+:/g, "\">"); // strip the mailto: from the visible part

    return addr;
  };

  //
  // Swap back in all the special characters we've hidden.
  //
  var _UnescapeSpecialChars = function(text) {
    text = text.replace(/~E(\d+)E/g, function(wholeMatch, m1) {
      var charCodeToReplace = parseInt(m1);
      return String.fromCharCode(charCodeToReplace);
    });
    return text;
  };

  //
  // Remove one level of line-leading tabs or spaces
  //
  var _Outdent = function(text) {

    // attacklab: hack around Konqueror 3.5.4 bug:
    // "----------bug".replace(/^-/g,"") == "bug"

    text = text.replace(/^(\t|[ ]{1,4})/gm, "~0"); // attacklab: g_tab_width

    // attacklab: clean up hack
    text = text.replace(/~0/g, "");

    return text;
  };

  // attacklab: Detab's completely rewritten for speed.
  // In perl we could fix it by anchoring the regexp with \G.
  // In javascript we're less fortunate.
  var _Detab = function(text) {
    // expand first n-1 tabs
    text = text.replace(/\t(?=\t)/g, "    "); // attacklab: g_tab_width

    // replace the nth with two sentinels
    text = text.replace(/\t/g, "~A~B");

    // use the sentinel to anchor our regex so it doesn't explode
    text = text.replace(/~B(.+?)~A/g, function(wholeMatch, m1, m2) {
      var leadingText = m1;
      var numSpaces = 4 - leadingText.length % 4;  // attacklab: g_tab_width

      // there *must* be a better way to do this:
      for (var i = 0; i < numSpaces; i++) leadingText += " ";

      return leadingText;
    });

    // clean up sentinels
    text = text.replace(/~A/g, "    ");  // attacklab: g_tab_width
    text = text.replace(/~B/g, "");

    return text;
  };


  //  attacklab: Utility functions
  var escapeCharacters = function(text, charsToEscape, afterBackslash) {
    // First we have to escape the escape characters so that
    // we can build a character class out of them
    var regexString = "([" + charsToEscape.replace(/([\[\]\\])/g, "\\$1") + "])";

    if (afterBackslash) {
      regexString = "\\\\" + regexString;
    }

    var regex = new RegExp(regexString, "g");
    text = text.replace(regex, escapeCharacters_callback);

    return text;
  };


  var escapeCharacters_callback = function(wholeMatch, m1) {
    var charCodeToEscape = m1.charCodeAt(0);
    return "~E" + charCodeToEscape + "E";
  };

};
(function() {
  var __slice = [].slice;

  this.Mercury || (this.Mercury = {});

  jQuery.extend(this.Mercury, {
    version: '0.9.0',
    Regions: Mercury.Regions || {},
    modalHandlers: Mercury.modalHandlers || {},
    lightviewHandlers: Mercury.lightviewHandlers || {},
    dialogHandlers: Mercury.dialogHandlers || {},
    preloadedViews: Mercury.preloadedViews || {},
    ajaxHeaders: function() {
      var headers;
      headers = {};
      headers[Mercury.config.csrfHeader] = Mercury.csrfToken;
      return headers;
    },
    on: function(eventName, callback) {
      return jQuery(window).on("mercury:" + eventName, callback);
    },
    off: function(eventName, callback) {
      return jQuery(window).off("mercury:" + eventName, callback);
    },
    one: function(eventName, callback) {
      return jQuery(window).one("mercury:" + eventName, callback);
    },
    trigger: function(eventName, options) {
      Mercury.log(eventName, options);
      return jQuery(window).trigger("mercury:" + eventName, options);
    },
    notify: function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return window.alert(Mercury.I18n.apply(this, args));
    },
    warn: function(message, severity) {
      if (severity == null) {
        severity = 0;
      }
      if (console) {
        try {
          return console.warn(message);
        } catch (e1) {
          if (severity >= 1) {
            try {
              return console.debug(message);
            } catch (e2) {

            }
          }
        }
      } else if (severity >= 1) {
        return Mercury.notify(message);
      }
    },
    deprecated: function(message) {
      if (console && console.trace) {
        message = "" + message + " -- " + (console.trace());
      }
      return Mercury.warn("deprecated: " + message, 1);
    },
    log: function() {
      if (Mercury.debug && console) {
        if (arguments[0] === 'hide:toolbar' || arguments[0] === 'show:toolbar') {
          return;
        }
        try {
          return console.debug(arguments);
        } catch (e) {

        }
      }
    },
    locale: function() {
      var locale, subLocale, topLocale;
      if (Mercury.determinedLocale) {
        return Mercury.determinedLocale;
      }
      if (Mercury.config.localization.enabled) {
        locale = [];
        if (navigator.language && (locale = navigator.language.toString().split('-')).length) {
          topLocale = Mercury.I18n[locale[0]] || {};
          subLocale = locale.length > 1 ? topLocale["_" + (locale[1].toUpperCase()) + "_"] : void 0;
        }
        if (!Mercury.I18n[locale[0]]) {
          locale = Mercury.config.localization.preferredLocale.split('-');
          topLocale = Mercury.I18n[locale[0]] || {};
          subLocale = locale.length > 1 ? topLocale["_" + (locale[1].toUpperCase()) + "_"] : void 0;
        }
      }
      return Mercury.determinedLocale = {
        top: topLocale || {},
        sub: subLocale || {}
      };
    },
    I18n: function() {
      var args, locale, sourceString, translation;
      sourceString = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      locale = Mercury.locale();
      translation = (locale.sub[sourceString] || locale.top[sourceString] || sourceString || '').toString();
      if (args.length) {
        return translation.printf.apply(translation, args);
      } else {
        return translation;
      }
    }
  });

}).call(this);
(function() {

  String.prototype.titleize = function() {
    return this[0].toUpperCase() + this.slice(1);
  };

  String.prototype.toHex = function() {
    if (this[0] === '#') {
      return this;
    }
    return this.replace(/rgb(a)?\(([0-9|%]+)[\s|,]?\s?([0-9|%]+)[\s|,]?\s?([0-9|%]+)[\s|,]?\s?([0-9|.|%]+\s?)?\)/gi, function(x, alpha, r, g, b, a) {
      return "#" + (parseInt(r).toHex()) + (parseInt(g).toHex()) + (parseInt(b).toHex());
    });
  };

  String.prototype.regExpEscape = function() {
    var escaped, specials;
    specials = ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'];
    escaped = new RegExp('(\\' + specials.join('|\\') + ')', 'g');
    return this.replace(escaped, '\\$1');
  };

  String.prototype.printf = function() {
    var arg, chunk, chunks, index, offset, p, re, result, _i, _len;
    chunks = this.split('%');
    result = chunks[0];
    re = /^([sdf])([\s\S%]*)$/;
    offset = 0;
    for (index = _i = 0, _len = chunks.length; _i < _len; index = ++_i) {
      chunk = chunks[index];
      p = re.exec(chunk);
      if (index === 0 || !p || arguments[index] === null) {
        if (index > 1) {
          offset += 2;
          result += "%" + chunk;
        }
        continue;
      }
      arg = arguments[(index - 1) - offset];
      switch (p[1]) {
        case 's':
          result += arg;
          break;
        case 'd':
        case 'i':
          result += parseInt(arg.toString(), 10);
          break;
        case 'f':
          result += parseFloat(arg);
      }
      result += p[2];
    }
    return result;
  };

  Number.prototype.toHex = function() {
    var result;
    result = this.toString(16).toUpperCase();
    if (result[1]) {
      return result;
    } else {
      return "0" + result;
    }
  };

  Number.prototype.toBytes = function() {
    var bytes, i;
    bytes = parseInt(this);
    i = 0;
    while (1023 < bytes) {
      bytes /= 1024;
      i += 1;
    }
    if (i) {
      return "" + (bytes.toFixed(2)) + ['', ' kb', ' Mb', ' Gb', ' Tb', ' Pb', ' Eb'][i];
    } else {
      return "" + bytes + " bytes";
    }
  };

}).call(this);
(function() {

  this.Mercury.PageEditor = (function() {

    function PageEditor(saveUrl, options) {
      var token;
      this.saveUrl = saveUrl != null ? saveUrl : null;
      this.options = options != null ? options : {};
      if (window.mercuryInstance) {
        throw Mercury.I18n('Mercury.PageEditor can only be instantiated once.');
      }
      if (!(this.options.visible === false || this.options.visible === 'false')) {
        this.options.visible = true;
      }
      this.visible = this.options.visible;
      if (!(this.options.saveDataType === false || this.options.saveDataType)) {
        this.options.saveDataType = 'json';
      }
      window.mercuryInstance = this;
      this.regions = [];
      this.initializeInterface();
      if (token = jQuery(Mercury.config.csrfSelector).attr('content')) {
        Mercury.csrfToken = token;
      }
    }

    PageEditor.prototype.initializeInterface = function() {
      var _ref, _ref1,
        _this = this;
      this.focusableElement = jQuery('<input>', {
        "class": 'mercury-focusable',
        type: 'text'
      }).appendTo((_ref = this.options.appendTo) != null ? _ref : 'body');
      this.iframe = jQuery('<iframe>', {
        id: 'mercury_iframe',
        "class": 'mercury-iframe',
        frameborder: '0',
        src: 'about:blank'
      });
      this.iframe.appendTo((_ref1 = jQuery(this.options.appendTo).get(0)) != null ? _ref1 : 'body');
      this.toolbar = new Mercury.Toolbar(jQuery.extend(true, {}, this.options, this.options.toolbarOptions));
      this.statusbar = new Mercury.Statusbar(jQuery.extend(true, {}, this.options, this.options.statusbarOptions));
      this.resize();
      this.iframe.one('load', function() {
        return _this.bindEvents();
      });
      this.iframe.on('load', function() {
        return _this.initializeFrame();
      });
      return this.loadIframeSrc(null);
    };

    PageEditor.prototype.initializeFrame = function() {
      var iframeWindow;
      try {
        if (this.iframe.data('loaded')) {
          return;
        }
        this.iframe.data('loaded', true);
        this.document = jQuery(this.iframe.get(0).contentWindow.document);
        jQuery("<style mercury-styles=\"true\">").html(Mercury.config.injectedStyles).appendTo(this.document.find('head'));
        iframeWindow = this.iframe.get(0).contentWindow;
        jQuery.globalEval = function(data) {
          if (data && /\S/.test(data)) {
            return (iframeWindow.execScript || function(data) {
              return iframeWindow["eval"].call(iframeWindow, data);
            })(data);
          }
        };
        iframeWindow.Mercury = Mercury;
        if (window.History && History.Adapter) {
          iframeWindow.History = History;
        }
        this.bindDocumentEvents();
        this.resize();
        this.initializeRegions();
        this.finalizeInterface();
        Mercury.trigger('ready');
        if (iframeWindow.jQuery) {
          iframeWindow.jQuery(iframeWindow).trigger('mercury:ready');
        }
        if (iframeWindow.Event && iframeWindow.Event.fire) {
          iframeWindow.Event.fire(iframeWindow, 'mercury:ready');
        }
        if (iframeWindow.onMercuryReady) {
          iframeWindow.onMercuryReady();
        }
        return this.iframe.css({
          visibility: 'visible'
        });
      } catch (error) {
        return Mercury.notify('Mercury.PageEditor failed to load: %s\n\nPlease try refreshing.', error);
      }
    };

    PageEditor.prototype.initializeRegions = function() {
      var region, _i, _j, _len, _len1, _ref, _ref1, _results;
      this.regions = [];
      _ref = jQuery("[" + Mercury.config.regions.attribute + "]", this.document);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        region = _ref[_i];
        this.buildRegion(jQuery(region));
      }
      if (!this.visible) {
        return;
      }
      _ref1 = this.regions;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        region = _ref1[_j];
        if (region.focus) {
          region.focus();
          break;
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    PageEditor.prototype.buildRegion = function(region) {
      var type, _base;
      if (region.data('region')) {
        region = region.data('region');
      } else {
        type = (region.attr(Mercury.config.regions.attribute) || (typeof (_base = Mercury.config.regions).determineType === "function" ? _base.determineType(region) : void 0) || 'unknown').titleize();
        if (type === 'Unknown' || !Mercury.Regions[type]) {
          throw Mercury.I18n('Region type is malformed, no data-type provided, or "%s" is unknown for the "%s" region.', type, region.attr('id') || 'unknown');
        }
        if (!Mercury.Regions[type].supported) {
          Mercury.notify('Mercury.Regions.%s is unsupported in this client. Supported browsers are %s.', type, Mercury.Regions[type].supportedText);
          return false;
        }
        region = new Mercury.Regions[type](region, this.iframe.get(0).contentWindow);
        if (this.previewing) {
          region.togglePreview();
        }
      }
      return this.regions.push(region);
    };

    PageEditor.prototype.finalizeInterface = function() {
      var _ref;
      this.santizerElement = jQuery('<div>', {
        id: 'mercury_sanitizer',
        contenteditable: 'true',
        style: 'position:fixed;width:100px;height:100px;min-width:0;top:0;left:-100px;opacity:0;overflow:hidden'
      });
      this.santizerElement.appendTo((_ref = this.options.appendTo) != null ? _ref : this.document.find('body'));
      if (this.snippetToolbar) {
        this.snippetToolbar.release();
      }
      this.snippetToolbar = new Mercury.SnippetToolbar(this.document);
      this.hijackLinksAndForms();
      if (!this.visible) {
        return Mercury.trigger('mode', {
          mode: 'preview'
        });
      }
    };

    PageEditor.prototype.bindDocumentEvents = function() {
      var _this = this;
      this.document.on('mousedown', function(event) {
        Mercury.trigger('hide:dialogs');
        if (Mercury.region) {
          if (jQuery(event.target).closest("[" + Mercury.config.regions.attribute + "]").get(0) !== Mercury.region.element.get(0)) {
            return Mercury.trigger('unfocus:regions');
          }
        }
      });
      return jQuery(this.document).bind('keydown', function(event) {
        if (!(event.ctrlKey || event.metaKey)) {
          return;
        }
        if (event.keyCode === 83) {
          Mercury.trigger('action', {
            action: 'save'
          });
          return event.preventDefault();
        }
      });
    };

    PageEditor.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('initialize:frame', function() {
        return setTimeout(_this.initializeFrame, 100);
      });
      Mercury.on('focus:frame', function() {
        return _this.iframe.focus();
      });
      Mercury.on('focus:window', function() {
        return setTimeout((function() {
          return _this.focusableElement.focus();
        }), 10);
      });
      Mercury.on('toggle:interface', function() {
        return _this.toggleInterface();
      });
      Mercury.on('reinitialize', function() {
        return _this.initializeRegions();
      });
      Mercury.on('mode', function(event, options) {
        if (options.mode === 'preview') {
          return _this.previewing = !_this.previewing;
        }
      });
      Mercury.on('action', function(event, options) {
        var action;
        action = Mercury.config.globalBehaviors[options.action] || _this[options.action];
        if (typeof action !== 'function') {
          return;
        }
        event.preventDefault();
        return action.call(_this, options);
      });
      jQuery(window).on('resize', function() {
        return _this.resize();
      });
      jQuery(window).bind('keydown', function(event) {
        if (!(event.ctrlKey || event.metaKey)) {
          return;
        }
        if (event.keyCode === 83) {
          Mercury.trigger('action', {
            action: 'save'
          });
          return event.preventDefault();
        }
      });
      return window.onbeforeunload = this.beforeUnload;
    };

    PageEditor.prototype.toggleInterface = function() {
      var _this = this;
      if (this.visible) {
        this.visible = false;
        this.toolbar.hide();
        this.statusbar.hide();
        if (!this.previewing) {
          Mercury.trigger('mode', {
            mode: 'preview'
          });
        }
        this.previewing = true;
        return this.resize();
      } else {
        this.visible = true;
        this.iframe.animate({
          top: this.toolbar.height(true)
        }, 200, 'easeInOutSine', function() {
          return _this.resize();
        });
        this.toolbar.show();
        this.statusbar.show();
        Mercury.trigger('mode', {
          mode: 'preview'
        });
        return this.previewing = false;
      }
    };

    PageEditor.prototype.resize = function() {
      var height, toolbarHeight, width;
      width = jQuery(window).width();
      height = this.statusbar.top();
      toolbarHeight = this.toolbar.top() + this.toolbar.height();
      Mercury.displayRect = {
        top: toolbarHeight,
        left: 0,
        width: width,
        height: height - toolbarHeight,
        fullHeight: height
      };
      this.iframe.css({
        top: toolbarHeight,
        left: 0,
        height: height - toolbarHeight
      });
      return Mercury.trigger('resize');
    };

    PageEditor.prototype.iframeSrc = function(url, params) {
      var _base, _ref;
      if (url == null) {
        url = null;
      }
      if (params == null) {
        params = false;
      }
      url = (url != null ? url : window.location.href).replace((_ref = (_base = Mercury.config).editorUrlRegEx) != null ? _ref : _base.editorUrlRegEx = /([http|https]:\/\/.[^\/]*)\/editor\/?(.*)/i, "$1/$2");
      url = url.replace(/[\?|\&]mercury_frame=true/gi, '');
      url = url.replace(/\&_=\d+/gi, '');
      if (params) {
        return "" + url + (url.indexOf('?') > -1 ? '&' : '?') + "mercury_frame=true&_=" + (new Date().getTime());
      } else {
        return url;
      }
    };

    PageEditor.prototype.loadIframeSrc = function(url) {
      if (this.document) {
        this.document.off();
      }
      this.iframe.data('loaded', false);
      return this.iframe.get(0).contentWindow.document.location.href = this.iframeSrc(url, true);
    };

    PageEditor.prototype.hijackLinksAndForms = function() {
      var classname, element, ignored, _i, _j, _len, _len1, _ref, _ref1, _results;
      _ref = jQuery('a, form', this.document);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        element = _ref[_i];
        ignored = false;
        _ref1 = Mercury.config.nonHijackableClasses || [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          classname = _ref1[_j];
          if (jQuery(element).hasClass(classname)) {
            ignored = true;
            continue;
          }
        }
        if (!ignored && (element.target === '' || element.target === '_self') && !jQuery(element).closest("[" + Mercury.config.regions.attribute + "]").length) {
          _results.push(jQuery(element).attr('target', '_parent'));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    PageEditor.prototype.beforeUnload = function() {
      if (Mercury.changes && !Mercury.silent) {
        return Mercury.I18n('You have unsaved changes.  Are you sure you want to leave without saving them first?');
      }
      return null;
    };

    PageEditor.prototype.getRegionByName = function(id) {
      var region, _i, _len, _ref;
      _ref = this.regions;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        region = _ref[_i];
        if (region.name === id) {
          return region;
        }
      }
      return null;
    };

    PageEditor.prototype.save = function(callback) {
      var data, method, options, url, _ref, _ref1,
        _this = this;
      url = (_ref = (_ref1 = this.saveUrl) != null ? _ref1 : Mercury.saveUrl) != null ? _ref : this.iframeSrc();
      data = this.serialize();
      data = {
        content: data
      };
      if (this.options.saveMethod === 'POST') {
        method = 'POST';
      } else {
        method = 'PUT';
        data['_method'] = method;
      }
      Mercury.log('saving', data);
      options = {
        headers: Mercury.ajaxHeaders(),
        type: method,
        dataType: this.options.saveDataType,
        data: data,
        success: function(response) {
          Mercury.changes = false;
          Mercury.trigger('saved', response);
          if (typeof callback === 'function') {
            return callback();
          }
        },
        error: function(response) {
          Mercury.trigger('save_failed', response);
          return Mercury.notify('Mercury was unable to save to the url: %s', url);
        }
      };
      if (this.options.saveStyle !== 'form') {
        options['data'] = jQuery.toJSON(data);
        options['contentType'] = 'application/json';
      }
      return jQuery.ajax(url, options);
    };

    PageEditor.prototype.serialize = function() {
      var region, serialized, _i, _len, _ref;
      serialized = {};
      _ref = this.regions;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        region = _ref[_i];
        serialized[region.name] = region.serialize();
      }
      return serialized;
    };

    return PageEditor;

  })();

}).call(this);
(function() {

  this.Mercury.HistoryBuffer = (function() {

    function HistoryBuffer(maxLength) {
      this.maxLength = maxLength != null ? maxLength : 200;
      this.index = 0;
      this.stack = [];
      this.markerRegExp = /<em class="mercury-marker"><\/em>/g;
    }

    HistoryBuffer.prototype.push = function(item) {
      if (jQuery.type(item) === 'string') {
        if (this.stack[this.index] && this.stack[this.index].replace(this.markerRegExp, '') === item.replace(this.markerRegExp, '')) {
          return;
        }
      } else if (jQuery.type(item) === 'object' && item.html) {
        if (this.stack[this.index] && this.stack[this.index].html === item.html) {
          return;
        }
      }
      this.stack = this.stack.slice(0, this.index + 1);
      this.stack.push(item);
      if (this.stack.length > this.maxLength) {
        this.stack.shift();
      }
      return this.index = this.stack.length - 1;
    };

    HistoryBuffer.prototype.undo = function() {
      if (this.index < 1) {
        return null;
      }
      this.index -= 1;
      return this.stack[this.index];
    };

    HistoryBuffer.prototype.redo = function() {
      if (this.index >= this.stack.length - 1) {
        return null;
      }
      this.index += 1;
      return this.stack[this.index];
    };

    return HistoryBuffer;

  })();

}).call(this);
(function() {

  this.Mercury.tableEditor = function(table, cell, cellContent) {
    Mercury.tableEditor.load(table, cell, cellContent);
    return Mercury.tableEditor;
  };

  jQuery.extend(Mercury.tableEditor, {
    load: function(table, cell, cellContent) {
      this.table = table;
      this.cell = cell;
      this.cellContent = cellContent != null ? cellContent : '';
      this.row = this.cell.parent('tr');
      this.columnCount = this.getColumnCount();
      return this.rowCount = this.getRowCount();
    },
    addColumnBefore: function() {
      return this.addColumn('before');
    },
    addColumnAfter: function() {
      return this.addColumn('after');
    },
    addColumn: function(position) {
      var i, intersecting, matchOptions, matching, newCell, row, rowSpan, sig, _i, _len, _ref, _results;
      if (position == null) {
        position = 'after';
      }
      sig = this.cellSignatureFor(this.cell);
      _ref = this.table.find('tr');
      _results = [];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        row = _ref[i];
        rowSpan = 1;
        matchOptions = position === 'after' ? {
          right: sig.right
        } : {
          left: sig.left
        };
        if (matching = this.findCellByOptionsFor(row, matchOptions)) {
          newCell = jQuery("<" + (matching.cell.get(0).tagName) + ">").html(this.cellContent);
          this.setRowspanFor(newCell, matching.height);
          if (position === 'before') {
            matching.cell.before(newCell);
          } else {
            matching.cell.after(newCell);
          }
          _results.push(i += matching.height - 1);
        } else if (intersecting = this.findCellByIntersectionFor(row, sig)) {
          _results.push(this.setColspanFor(intersecting.cell, intersecting.width + 1));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    },
    removeColumn: function() {
      var adjusting, cell, i, intersecting, matching, removing, row, sig, _i, _j, _k, _len, _len1, _len2, _ref, _results;
      sig = this.cellSignatureFor(this.cell);
      if (sig.width > 1) {
        return;
      }
      removing = [];
      adjusting = [];
      _ref = this.table.find('tr');
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        row = _ref[i];
        if (matching = this.findCellByOptionsFor(row, {
          left: sig.left,
          width: sig.width
        })) {
          removing.push(matching.cell);
          i += matching.height - 1;
        } else if (intersecting = this.findCellByIntersectionFor(row, sig)) {
          adjusting.push(intersecting.cell);
        }
      }
      for (_j = 0, _len1 = removing.length; _j < _len1; _j++) {
        cell = removing[_j];
        jQuery(cell).remove();
      }
      _results = [];
      for (_k = 0, _len2 = adjusting.length; _k < _len2; _k++) {
        cell = adjusting[_k];
        _results.push(this.setColspanFor(cell, this.colspanFor(cell) - 1));
      }
      return _results;
    },
    addRowBefore: function() {
      return this.addRow('before');
    },
    addRowAfter: function() {
      return this.addRow('after');
    },
    addRow: function(position) {
      var cell, cellCount, colspan, newCell, newRow, previousRow, rowCount, rowspan, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      if (position == null) {
        position = 'after';
      }
      newRow = jQuery('<tr>');
      if ((rowspan = this.rowspanFor(this.cell)) > 1 && position === 'after') {
        this.row = jQuery(this.row.nextAll('tr')[rowspan - 2]);
      }
      cellCount = 0;
      _ref = this.row.find('th, td');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        colspan = this.colspanFor(cell);
        newCell = jQuery("<" + cell.tagName + ">").html(this.cellContent);
        this.setColspanFor(newCell, colspan);
        cellCount += colspan;
        if ((rowspan = this.rowspanFor(cell)) > 1 && position === 'after') {
          this.setRowspanFor(cell, rowspan + 1);
          continue;
        }
        newRow.append(newCell);
      }
      if (cellCount < this.columnCount) {
        rowCount = 0;
        _ref1 = this.row.prevAll('tr');
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          previousRow = _ref1[_j];
          rowCount += 1;
          _ref2 = jQuery(previousRow).find('td[rowspan], th[rowspan]');
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            cell = _ref2[_k];
            rowspan = this.rowspanFor(cell);
            if (rowspan - 1 >= rowCount && position === 'before') {
              this.setRowspanFor(cell, rowspan + 1);
            } else if (rowspan - 1 >= rowCount && position === 'after') {
              if (rowspan - 1 === rowCount) {
                newCell = jQuery("<" + cell.tagName + ">").html(this.cellContent);
                this.setColspanFor(newCell, this.colspanFor(cell));
                newRow.append(newCell);
              } else {
                this.setRowspanFor(cell, rowspan + 1);
              }
            }
          }
        }
      }
      if (position === 'before') {
        return this.row.before(newRow);
      } else {
        return this.row.after(newRow);
      }
    },
    removeRow: function() {
      var aboveRow, cell, i, match, minRowspan, prevRowspan, rowsAbove, rowspan, rowspansMatch, sig, _i, _j, _k, _l, _len, _len1, _len2, _len3, _m, _ref, _ref1, _ref2, _ref3, _ref4;
      rowspansMatch = true;
      prevRowspan = 0;
      minRowspan = 0;
      _ref = this.row.find('td, th');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        rowspan = this.rowspanFor(cell);
        if (prevRowspan && rowspan !== prevRowspan) {
          rowspansMatch = false;
        }
        if (rowspan < minRowspan || !minRowspan) {
          minRowspan = rowspan;
        }
        prevRowspan = rowspan;
      }
      if (!rowspansMatch && this.rowspanFor(this.cell) > minRowspan) {
        return;
      }
      if (minRowspan > 1) {
        for (i = _j = 0, _ref1 = minRowspan - 2; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          jQuery(this.row.nextAll('tr')[i]).remove();
        }
      }
      _ref2 = this.row.find('td[rowspan], th[rowspan]');
      for (_k = 0, _len1 = _ref2.length; _k < _len1; _k++) {
        cell = _ref2[_k];
        sig = this.cellSignatureFor(cell);
        if (sig.height === minRowspan) {
          continue;
        }
        if (match = this.findCellByOptionsFor(this.row.nextAll('tr')[minRowspan - 1], {
          left: sig.left,
          forceAdjacent: true
        })) {
          this.setRowspanFor(cell, this.rowspanFor(cell) - this.rowspanFor(this.cell));
          if (match.direction === 'before') {
            match.cell.before(jQuery(cell).clone());
          } else {
            match.cell.after(jQuery(cell).clone());
          }
        }
      }
      if (this.columnsFor(this.row.find('td, th')) < this.columnCount) {
        rowsAbove = 0;
        _ref3 = this.row.prevAll('tr');
        for (_l = 0, _len2 = _ref3.length; _l < _len2; _l++) {
          aboveRow = _ref3[_l];
          rowsAbove += 1;
          _ref4 = jQuery(aboveRow).find('td[rowspan], th[rowspan]');
          for (_m = 0, _len3 = _ref4.length; _m < _len3; _m++) {
            cell = _ref4[_m];
            rowspan = this.rowspanFor(cell);
            if (rowspan > rowsAbove) {
              this.setRowspanFor(cell, rowspan - this.rowspanFor(this.cell));
            }
          }
        }
      }
      return this.row.remove();
    },
    increaseColspan: function() {
      var cell;
      cell = this.cell.next('td, th');
      if (!cell.length) {
        return;
      }
      if (this.rowspanFor(cell) !== this.rowspanFor(this.cell)) {
        return;
      }
      if (this.cellIndexFor(cell) > this.cellIndexFor(this.cell) + this.colspanFor(this.cell)) {
        return;
      }
      this.setColspanFor(this.cell, this.colspanFor(this.cell) + this.colspanFor(cell));
      return cell.remove();
    },
    decreaseColspan: function() {
      var newCell;
      if (this.colspanFor(this.cell) === 1) {
        return;
      }
      this.setColspanFor(this.cell, this.colspanFor(this.cell) - 1);
      newCell = jQuery("<" + (this.cell.get(0).tagName) + ">").html(this.cellContent);
      this.setRowspanFor(newCell, this.rowspanFor(this.cell));
      return this.cell.after(newCell);
    },
    increaseRowspan: function() {
      var match, nextRow, sig;
      sig = this.cellSignatureFor(this.cell);
      nextRow = this.row.nextAll('tr')[sig.height - 1];
      if (nextRow && (match = this.findCellByOptionsFor(nextRow, {
        left: sig.left,
        width: sig.width
      }))) {
        this.setRowspanFor(this.cell, sig.height + match.height);
        return match.cell.remove();
      }
    },
    decreaseRowspan: function() {
      var match, newCell, nextRow, sig;
      sig = this.cellSignatureFor(this.cell);
      if (sig.height === 1) {
        return;
      }
      nextRow = this.row.nextAll('tr')[sig.height - 2];
      if (match = this.findCellByOptionsFor(nextRow, {
        left: sig.left,
        forceAdjacent: true
      })) {
        newCell = jQuery("<" + (this.cell.get(0).tagName) + ">").html(this.cellContent);
        this.setColspanFor(newCell, this.colspanFor(this.cell));
        this.setRowspanFor(this.cell, sig.height - 1);
        if (match.direction === 'before') {
          return match.cell.before(newCell);
        } else {
          return match.cell.after(newCell);
        }
      }
    },
    getColumnCount: function() {
      return this.columnsFor(this.table.find('thead tr:first-child, tbody tr:first-child, tfoot tr:first-child').first().find('td, th'));
    },
    getRowCount: function() {
      return this.table.find('tr').length;
    },
    cellIndexFor: function(cell) {
      var aboveCell, aboveRow, columns, index, row, rowsAbove, _i, _j, _len, _len1, _ref, _ref1;
      cell = jQuery(cell);
      row = cell.parent('tr');
      columns = this.columnsFor(row.find('td, th'));
      index = this.columnsFor(cell.prevAll('td, th'));
      if (columns < this.columnCount) {
        rowsAbove = 0;
        _ref = row.prevAll('tr');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          aboveRow = _ref[_i];
          rowsAbove += 1;
          _ref1 = jQuery(aboveRow).find('td[rowspan], th[rowspan]');
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            aboveCell = _ref1[_j];
            if (this.rowspanFor(aboveCell) > rowsAbove && this.cellIndexFor(aboveCell) <= index) {
              index += this.colspanFor(aboveCell);
            }
          }
        }
      }
      return index;
    },
    cellSignatureFor: function(cell) {
      var sig;
      sig = {
        cell: jQuery(cell)
      };
      sig.left = this.cellIndexFor(cell);
      sig.width = this.colspanFor(cell);
      sig.height = this.rowspanFor(cell);
      sig.right = sig.left + sig.width;
      return sig;
    },
    findCellByOptionsFor: function(row, options) {
      var cell, prev, sig, _i, _len, _ref;
      _ref = jQuery(row).find('td, th');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        sig = this.cellSignatureFor(cell);
        if (typeof options.right !== 'undefined') {
          if (sig.right === options.right) {
            return sig;
          }
        }
        if (typeof options.left !== 'undefined') {
          if (options.width) {
            if (sig.left === options.left && sig.width === options.width) {
              return sig;
            }
          } else if (!options.forceAdjacent) {
            if (sig.left === options.left) {
              return sig;
            }
          } else if (options.forceAdjacent) {
            if (sig.left > options.left) {
              prev = jQuery(cell).prev('td, th');
              if (prev.length) {
                sig = this.cellSignatureFor(prev);
                sig.direction = 'after';
              } else {
                sig.direction = 'before';
              }
              return sig;
            }
          }
        }
      }
      if (options.forceAdjacent) {
        sig.direction = 'after';
        return sig;
      }
      return null;
    },
    findCellByIntersectionFor: function(row, signature) {
      var cell, sig, _i, _len, _ref;
      _ref = jQuery(row).find('td, th');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cell = _ref[_i];
        sig = this.cellSignatureFor(cell);
        if (sig.right - signature.left >= 0 && sig.right > signature.left) {
          return sig;
        }
      }
      return null;
    },
    columnsFor: function(cells) {
      var cell, count, _i, _len;
      count = 0;
      for (_i = 0, _len = cells.length; _i < _len; _i++) {
        cell = cells[_i];
        count += this.colspanFor(cell);
      }
      return count;
    },
    colspanFor: function(cell) {
      return parseInt(jQuery(cell).attr('colspan')) || 1;
    },
    rowspanFor: function(cell) {
      return parseInt(jQuery(cell).attr('rowspan')) || 1;
    },
    setColspanFor: function(cell, value) {
      return jQuery(cell).attr('colspan', value > 1 ? value : null);
    },
    setRowspanFor: function(cell, value) {
      return jQuery(cell).attr('rowspan', value > 1 ? value : null);
    }
  });

}).call(this);
(function() {

  this.Mercury.Dialog = (function() {

    function Dialog(url, name, options) {
      this.url = url;
      this.name = name;
      this.options = options != null ? options : {};
      this.button = this.options["for"];
      this.build();
      this.bindEvents();
      this.preload();
    }

    Dialog.prototype.build = function() {
      var _ref;
      this.element = jQuery('<div>', {
        "class": "mercury-dialog mercury-" + this.name + "-dialog loading",
        style: 'display:none'
      });
      return this.element.appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
    };

    Dialog.prototype.bindEvents = function() {
      return this.element.on('mousedown', function(event) {
        return event.stopPropagation();
      });
    };

    Dialog.prototype.preload = function() {
      if (this.options.preload) {
        return this.load();
      }
    };

    Dialog.prototype.toggle = function() {
      if (this.visible) {
        return this.hide();
      } else {
        return this.show();
      }
    };

    Dialog.prototype.resize = function() {
      return this.show();
    };

    Dialog.prototype.show = function() {
      Mercury.trigger('hide:dialogs', this);
      this.visible = true;
      if (this.loaded) {
        this.element.css({
          width: 'auto',
          height: 'auto'
        });
        this.position(this.visible);
      } else {
        this.position();
      }
      return this.appear();
    };

    Dialog.prototype.position = function(keepVisible) {};

    Dialog.prototype.appear = function() {
      var _this = this;
      this.element.css({
        display: 'block',
        opacity: 0
      });
      return this.element.animate({
        opacity: 0.95
      }, 200, 'easeInOutSine', function() {
        if (!_this.loaded) {
          return _this.load(function() {
            return _this.resize();
          });
        }
      });
    };

    Dialog.prototype.hide = function() {
      this.element.hide();
      return this.visible = false;
    };

    Dialog.prototype.load = function(callback) {
      var _this = this;
      if (!this.url) {
        return;
      }
      if (Mercury.preloadedViews[this.url]) {
        this.loadContent(Mercury.preloadedViews[this.url]);
        if (Mercury.dialogHandlers[this.name]) {
          Mercury.dialogHandlers[this.name].call(this);
        }
        if (callback) {
          return callback();
        }
      } else {
        return jQuery.ajax(this.url, {
          success: function(data) {
            _this.loadContent(data);
            if (Mercury.dialogHandlers[_this.name]) {
              Mercury.dialogHandlers[_this.name].call(_this);
            }
            if (callback) {
              return callback();
            }
          },
          error: function() {
            _this.hide();
            if (_this.button) {
              _this.button.removeClass('pressed');
            }
            return Mercury.notify('Mercury was unable to load %s for the "%s" dialog.', _this.url, _this.name);
          }
        });
      }
    };

    Dialog.prototype.loadContent = function(data) {
      this.loaded = true;
      this.element.removeClass('loading');
      this.element.html(data);
      if (Mercury.config.localization.enabled) {
        return this.element.localize(Mercury.locale());
      }
    };

    return Dialog;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Mercury.Palette = (function(_super) {

    __extends(Palette, _super);

    function Palette(url, name, options) {
      this.url = url;
      this.name = name;
      this.options = options != null ? options : {};
      Palette.__super__.constructor.apply(this, arguments);
    }

    Palette.prototype.build = function() {
      var _ref;
      this.element = jQuery('<div>', {
        "class": "mercury-palette mercury-" + this.name + "-palette loading",
        style: 'display:none'
      });
      return this.element.appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
    };

    Palette.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('hide:dialogs', function(event, dialog) {
        if (dialog !== _this) {
          return _this.hide();
        }
      });
      return Palette.__super__.bindEvents.apply(this, arguments);
    };

    Palette.prototype.position = function(keepVisible) {
      var position, width;
      this.element.css({
        top: 0,
        left: 0,
        display: 'block',
        visibility: 'hidden'
      });
      position = this.button.position();
      width = this.element.width();
      if (position.left + width > jQuery(window).width()) {
        position.left = position.left - width + this.button.width();
      }
      return this.element.css({
        top: position.top + this.button.height(),
        left: position.left,
        display: keepVisible ? 'block' : 'none',
        visibility: 'visible'
      });
    };

    return Palette;

  })(Mercury.Dialog);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Mercury.Select = (function(_super) {

    __extends(Select, _super);

    function Select(url, name, options) {
      this.url = url;
      this.name = name;
      this.options = options != null ? options : {};
      Select.__super__.constructor.apply(this, arguments);
    }

    Select.prototype.build = function() {
      var _ref;
      this.element = jQuery('<div>', {
        "class": "mercury-select mercury-" + this.name + "-select loading",
        style: 'display:none'
      });
      return this.element.appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
    };

    Select.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('hide:dialogs', function(event, dialog) {
        if (dialog !== _this) {
          return _this.hide();
        }
      });
      this.element.on('mousedown', function(event) {
        return event.preventDefault();
      });
      return Select.__super__.bindEvents.apply(this, arguments);
    };

    Select.prototype.position = function(keepVisible) {
      var documentHeight, elementHeight, elementWidth, height, left, position, top;
      this.element.css({
        top: 0,
        left: 0,
        display: 'block',
        visibility: 'hidden'
      });
      position = this.button.position();
      elementWidth = this.element.width();
      elementHeight = this.element.height();
      documentHeight = jQuery(document).height();
      top = position.top + (this.button.height() / 2) - (elementHeight / 2);
      if (top < position.top - 100) {
        top = position.top - 100;
      }
      if (top < 20) {
        top = 20;
      }
      height = this.loaded ? 'auto' : elementHeight;
      if (top + elementHeight >= documentHeight - 20) {
        height = documentHeight - top - 20;
      }
      left = position.left;
      if (left + elementWidth > jQuery(window).width()) {
        left = left - elementWidth + this.button.width();
      }
      return this.element.css({
        top: top,
        left: left,
        height: height,
        display: keepVisible ? 'block' : 'none',
        visibility: 'visible'
      });
    };

    return Select;

  })(Mercury.Dialog);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Mercury.Panel = (function(_super) {

    __extends(Panel, _super);

    function Panel(url, name, options) {
      this.url = url;
      this.name = name;
      this.options = options != null ? options : {};
      Panel.__super__.constructor.apply(this, arguments);
    }

    Panel.prototype.build = function() {
      var _ref;
      this.element = jQuery('<div>', {
        "class": 'mercury-panel loading',
        style: 'display:none;'
      });
      this.titleElement = jQuery("<h1><span>" + (Mercury.I18n(this.options.title)) + "</span></h1>").appendTo(this.element);
      this.paneElement = jQuery('<div>', {
        "class": 'mercury-panel-pane'
      }).appendTo(this.element);
      if (this.options.closeButton) {
        jQuery('<a/>', {
          "class": 'mercury-panel-close'
        }).appendTo(this.titleElement).css({
          opacity: 0
        });
      }
      return this.element.appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
    };

    Panel.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('resize', function() {
        return _this.position(_this.visible);
      });
      Mercury.on('hide:panels', function(event, panel) {
        if (panel === _this) {
          return;
        }
        _this.button.removeClass('pressed');
        return _this.hide();
      });
      this.titleElement.find('.mercury-panel-close').on('click', function(event) {
        event.preventDefault();
        return Mercury.trigger('hide:panels');
      });
      this.element.on('mousedown', function(event) {
        return event.stopPropagation();
      });
      this.element.on('ajax:beforeSend', function(event, xhr, options) {
        return options.success = function(content) {
          _this.loadContent(content);
          return _this.resize();
        };
      });
      return Panel.__super__.bindEvents.apply(this, arguments);
    };

    Panel.prototype.show = function() {
      Mercury.trigger('hide:panels', this);
      return Panel.__super__.show.apply(this, arguments);
    };

    Panel.prototype.resize = function() {
      var position, postWidth, preWidth,
        _this = this;
      this.titleElement.find('.mercury-panel-close').css({
        opacity: 0
      });
      this.paneElement.css({
        display: 'none'
      });
      preWidth = this.element.width();
      this.paneElement.css({
        visibility: 'hidden',
        width: 'auto',
        display: 'block'
      });
      postWidth = this.element.width();
      this.paneElement.css({
        visibility: 'visible',
        display: 'none'
      });
      position = this.element.offset();
      this.element.animate({
        left: position.left - (postWidth - preWidth),
        width: postWidth
      }, 200, 'easeInOutSine', function() {
        _this.titleElement.find('.mercury-panel-close').animate({
          opacity: 1
        }, 100);
        _this.paneElement.css({
          display: 'block',
          width: postWidth
        });
        jQuery(_this.paneElement.find('.focusable').get(0)).focus();
        return _this.makeDraggable();
      });
      if (!this.visible) {
        return this.hide();
      }
    };

    Panel.prototype.position = function(keepVisible) {
      var elementWidth, height, left, offset, paneHeight;
      this.element.css({
        display: 'block',
        visibility: 'hidden'
      });
      offset = this.element.offset();
      elementWidth = this.element.width();
      height = Mercury.displayRect.height - 16;
      paneHeight = height - this.titleElement.outerHeight();
      this.paneElement.css({
        height: paneHeight,
        overflowY: paneHeight < 30 ? 'hidden' : 'auto'
      });
      if (!this.moved) {
        left = Mercury.displayRect.width - elementWidth - 20;
      }
      if (left <= 8) {
        left = 8;
      }
      if (this.pinned || elementWidth + offset.left > Mercury.displayRect.width - 20) {
        left = Mercury.displayRect.width - elementWidth - 20;
      }
      this.element.css({
        top: Mercury.displayRect.top + 8,
        left: left,
        height: height,
        display: keepVisible ? 'block' : 'none',
        visibility: 'visible'
      });
      this.makeDraggable();
      if (!keepVisible) {
        return this.element.hide();
      }
    };

    Panel.prototype.loadContent = function(data) {
      this.loaded = true;
      this.element.removeClass('loading');
      this.paneElement.css({
        visibility: 'hidden'
      });
      this.paneElement.html(data);
      if (Mercury.config.localization.enabled) {
        return this.paneElement.localize(Mercury.locale());
      }
    };

    Panel.prototype.makeDraggable = function() {
      var elementWidth,
        _this = this;
      elementWidth = this.element.width();
      return this.element.draggable({
        handle: 'h1 span',
        axis: 'x',
        opacity: 0.70,
        scroll: false,
        addClasses: false,
        iframeFix: true,
        containment: [8, 0, Mercury.displayRect.width - elementWidth - 20, 0],
        stop: function() {
          var left;
          left = _this.element.offset().left;
          _this.moved = true;
          _this.pinned = left > Mercury.displayRect.width - elementWidth - 30 ? true : false;
          return true;
        }
      });
    };

    return Panel;

  })(Mercury.Dialog);

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.Mercury.modal = function(url, options) {
    var instance;
    if (options == null) {
      options = {};
    }
    instance = new Mercury.Modal(url, options);
    instance.show();
    return instance;
  };

  this.Mercury.Modal = (function() {

    function Modal(url, options) {
      this.url = url;
      this.options = options != null ? options : {};
      this.hide = __bind(this.hide, this);

    }

    Modal.prototype.show = function(url, options) {
      var _base,
        _this = this;
      if (url == null) {
        url = null;
      }
      if (options == null) {
        options = null;
      }
      this.url = url || this.url;
      this.options = options || this.options;
      (_base = this.options).minWidth || (_base.minWidth = 400);
      if (this.options.ujsHandling !== false) {
        this.options.ujsHandling = true;
      }
      Mercury.trigger('focus:window');
      this.initializeModal();
      if (this.visible) {
        this.update();
      } else {
        this.appear();
      }
      if (this.options.content) {
        return setTimeout((function() {
          return _this.loadContent(_this.options.content);
        }), 500);
      }
    };

    Modal.prototype.initializeModal = function() {
      if (this.initialized) {
        return;
      }
      this.build();
      this.bindEvents();
      return this.initialized = true;
    };

    Modal.prototype.build = function() {
      var _ref, _ref1;
      this.element = jQuery('<div>', {
        "class": 'mercury-modal loading'
      });
      this.element.html('<h1 class="mercury-modal-title"><span></span><a>&times;</a></h1>');
      this.element.append('<div class="mercury-modal-content-container"><div class="mercury-modal-content"></div></div>');
      this.overlay = jQuery('<div>', {
        "class": 'mercury-modal-overlay'
      });
      this.titleElement = this.element.find('.mercury-modal-title');
      this.contentContainerElement = this.element.find('.mercury-modal-content-container');
      this.contentElement = this.element.find('.mercury-modal-content');
      this.element.appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
      return this.overlay.appendTo((_ref1 = jQuery(this.options.appendTo).get(0)) != null ? _ref1 : 'body');
    };

    Modal.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('refresh', function() {
        return _this.resize(true);
      });
      Mercury.on('resize', function() {
        return _this.position();
      });
      this.overlay.on('click', function() {
        if (_this.options.allowHideUsingOverlay) {
          return _this.hide();
        }
      });
      this.titleElement.find('a').on('click', function() {
        return _this.hide();
      });
      if (this.options.ujsHandling) {
        this.element.on('ajax:beforeSend', function(event, xhr, options) {
          return options.success = function(content) {
            return _this.loadContent(content);
          };
        });
      }
      return jQuery(document).on('keydown', function(event) {
        if (event.keyCode === 27 && _this.visible) {
          return _this.hide();
        }
      });
    };

    Modal.prototype.appear = function() {
      var _this = this;
      this.showing = true;
      this.position();
      this.overlay.show();
      return this.overlay.animate({
        opacity: 1
      }, 200, 'easeInOutSine', function() {
        _this.element.css({
          top: -_this.element.height()
        });
        _this.setTitle();
        _this.element.show();
        return _this.element.animate({
          top: 0
        }, 200, 'easeInOutSine', function() {
          _this.visible = true;
          _this.showing = false;
          return _this.load();
        });
      });
    };

    Modal.prototype.resize = function(keepVisible) {
      var height, titleHeight, visibility, width,
        _this = this;
      visibility = keepVisible ? 'visible' : 'hidden';
      titleHeight = this.titleElement.outerHeight();
      width = this.contentElement.outerWidth();
      if (this.contentPane) {
        this.contentPane.css({
          height: 'auto'
        });
      }
      this.contentElement.css({
        height: 'auto',
        visibility: visibility,
        display: 'block'
      });
      height = this.contentElement.outerHeight() + titleHeight;
      if (width < this.options.minWidth) {
        width = this.options.minWidth;
      }
      if (height > Mercury.displayRect.fullHeight || this.options.fullHeight) {
        height = Mercury.displayRect.fullHeight;
      }
      return this.element.stop().animate({
        left: (Mercury.displayRect.width - width) / 2,
        width: width,
        height: height
      }, 200, 'easeInOutSine', function() {
        var controlHeight;
        _this.contentElement.css({
          visibility: 'visible',
          display: 'block'
        });
        if (_this.contentPane.length) {
          _this.contentElement.css({
            height: height - titleHeight,
            overflow: 'visible'
          });
          controlHeight = _this.contentControl.length ? _this.contentControl.outerHeight() + 10 : 0;
          _this.contentPane.css({
            height: height - titleHeight - controlHeight - 20
          });
          return _this.contentPane.find('.mercury-display-pane').css({
            width: width - 20
          });
        } else {
          return _this.contentElement.css({
            height: height - titleHeight,
            overflow: 'auto'
          });
        }
      });
    };

    Modal.prototype.position = function() {
      var controlHeight, height, titleHeight, viewportWidth, width;
      viewportWidth = Mercury.displayRect.width;
      if (this.contentPane) {
        this.contentPane.css({
          height: 'auto'
        });
      }
      this.contentElement.css({
        height: 'auto'
      });
      this.element.css({
        width: 'auto',
        height: 'auto',
        display: 'block',
        visibility: 'hidden'
      });
      width = this.element.width();
      height = this.element.height();
      if (width < this.options.minWidth) {
        width = this.options.minWidth;
      }
      if (height > Mercury.displayRect.fullHeight || this.options.fullHeight) {
        height = Mercury.displayRect.fullHeight;
      }
      titleHeight = this.titleElement.outerHeight();
      if (this.contentPane && this.contentPane.length) {
        this.contentElement.css({
          height: height - titleHeight,
          overflow: 'visible'
        });
        controlHeight = this.contentControl.length ? this.contentControl.outerHeight() + 10 : 0;
        this.contentPane.css({
          height: height - titleHeight - controlHeight - 20
        });
        this.contentPane.find('.mercury-display-pane').css({
          width: width - 20
        });
      } else {
        this.contentElement.css({
          height: height - titleHeight,
          overflow: 'auto'
        });
      }
      return this.element.css({
        left: (viewportWidth - width) / 2,
        width: width,
        height: height,
        display: this.visible ? 'block' : 'none',
        visibility: 'visible'
      });
    };

    Modal.prototype.update = function() {
      this.reset();
      this.resize();
      return this.load();
    };

    Modal.prototype.load = function() {
      var _this = this;
      this.setTitle();
      if (!this.url) {
        return;
      }
      this.element.addClass('loading');
      if (Mercury.preloadedViews[this.url]) {
        return setTimeout((function() {
          return _this.loadContent(Mercury.preloadedViews[_this.url]);
        }), 10);
      } else {
        return jQuery.ajax(this.url, {
          headers: Mercury.ajaxHeaders(),
          type: this.options.loadType || 'GET',
          data: this.options.loadData,
          success: function(data) {
            return _this.loadContent(data);
          },
          error: function() {
            _this.hide();
            return Mercury.notify("Mercury was unable to load %s for the modal.", _this.url);
          }
        });
      }
    };

    Modal.prototype.loadContent = function(data, options) {
      if (options == null) {
        options = null;
      }
      this.initializeModal();
      this.options = options || this.options;
      this.setTitle();
      this.loaded = true;
      this.element.removeClass('loading');
      this.contentElement.html(data);
      this.contentElement.css({
        display: 'none',
        visibility: 'hidden'
      });
      this.contentPane = this.element.find('.mercury-display-pane-container');
      this.contentControl = this.element.find('.mercury-display-controls');
      if (this.options.afterLoad) {
        this.options.afterLoad.call(this);
      }
      if (this.options.handler) {
        if (Mercury.modalHandlers[this.options.handler]) {
          if (typeof Mercury.modalHandlers[this.options.handler] === 'function') {
            Mercury.modalHandlers[this.options.handler].call(this);
          } else {
            jQuery.extend(this, Mercury.modalHandlers[this.options.handler]);
            this.initialize();
          }
        } else if (Mercury.lightviewHandlers[this.options.handler]) {
          if (typeof Mercury.lightviewHandlers[this.options.handler] === 'function') {
            Mercury.lightviewHandlers[this.options.handler].call(this);
          } else {
            jQuery.extend(this, Mercury.lightviewHandlers[this.options.handler]);
            this.initialize();
          }
        }
      }
      if (Mercury.config.localization.enabled) {
        this.element.localize(Mercury.locale());
      }
      this.element.find('.modal-close').on('click', this.hide);
      return this.resize();
    };

    Modal.prototype.setTitle = function() {
      var closeButton;
      this.titleElement.find('span').html(Mercury.I18n(this.options.title));
      closeButton = this.titleElement.find('a');
      if (this.options.closeButton === false) {
        return closeButton.hide();
      } else {
        return closeButton.show();
      }
    };

    Modal.prototype.serializeForm = function() {
      return this.element.find('form').serializeObject() || {};
    };

    Modal.prototype.reset = function() {
      this.titleElement.find('span').html('');
      return this.contentElement.html('');
    };

    Modal.prototype.hide = function() {
      if (this.showing) {
        return;
      }
      this.options = {};
      Mercury.trigger('focus:frame');
      this.element.hide();
      this.overlay.hide();
      this.reset();
      return this.visible = false;
    };

    return Modal;

  })();

}).call(this);
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.Mercury.lightview = function(url, options) {
    var _base;
    if (options == null) {
      options = {};
    }
    (_base = Mercury.lightview).instance || (_base.instance = new Mercury.Lightview(url, options));
    Mercury.lightview.instance.show(url, options);
    return Mercury.lightview.instance;
  };

  this.Mercury.Lightview = (function() {

    function Lightview(url, options) {
      this.url = url;
      this.options = options != null ? options : {};
      this.hide = __bind(this.hide, this);

    }

    Lightview.prototype.show = function(url, options) {
      var _this = this;
      this.url = url || this.url;
      this.options = options || this.options;
      if (this.options.ujsHandling !== false) {
        this.options.ujsHandling = true;
      }
      Mercury.trigger('focus:window');
      this.initializeLightview();
      if (this.visible) {
        this.update();
      } else {
        this.appear();
      }
      if (this.options.content) {
        return setTimeout((function() {
          return _this.loadContent(_this.options.content);
        }), 500);
      }
    };

    Lightview.prototype.initializeLightview = function() {
      if (this.initialized) {
        return;
      }
      this.build();
      this.bindEvents();
      return this.initialized = true;
    };

    Lightview.prototype.build = function() {
      var _ref, _ref1;
      this.element = jQuery('<div>', {
        "class": 'mercury-lightview loading'
      });
      this.element.html('<h1 class="mercury-lightview-title"><span></span></h1>');
      this.element.append('<div class="mercury-lightview-content"></div>');
      this.overlay = jQuery('<div>', {
        "class": 'mercury-lightview-overlay'
      });
      this.titleElement = this.element.find('.mercury-lightview-title');
      if (this.options.closeButton) {
        this.titleElement.append('<a class="mercury-lightview-close"></a>');
      }
      this.contentElement = this.element.find('.mercury-lightview-content');
      this.element.appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
      return this.overlay.appendTo((_ref1 = jQuery(this.options.appendTo).get(0)) != null ? _ref1 : 'body');
    };

    Lightview.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('refresh', function() {
        return _this.resize(true);
      });
      Mercury.on('resize', function() {
        if (_this.visible) {
          return _this.position();
        }
      });
      this.overlay.on('click', function() {
        if (!_this.options.closeButton) {
          return _this.hide();
        }
      });
      this.titleElement.find('.mercury-lightview-close').on('click', function() {
        return _this.hide();
      });
      if (this.options.ujsHandling) {
        this.element.on('ajax:beforeSend', function(event, xhr, options) {
          return options.success = function(content) {
            return _this.loadContent(content);
          };
        });
      }
      return jQuery(document).on('keydown', function(event) {
        if (event.keyCode === 27 && _this.visible) {
          return _this.hide();
        }
      });
    };

    Lightview.prototype.appear = function() {
      var _this = this;
      this.showing = true;
      this.position();
      this.overlay.show().css({
        opacity: 0
      });
      return this.overlay.animate({
        opacity: 1
      }, 200, 'easeInOutSine', function() {
        _this.setTitle();
        _this.element.show().css({
          opacity: 0
        });
        return _this.element.stop().animate({
          opacity: 1
        }, 200, 'easeInOutSine', function() {
          _this.visible = true;
          _this.showing = false;
          return _this.load();
        });
      });
    };

    Lightview.prototype.resize = function(keepVisible) {
      var height, titleHeight, viewportHeight, viewportWidth, visibility, width,
        _this = this;
      visibility = keepVisible ? 'visible' : 'hidden';
      viewportWidth = Mercury.displayRect.width;
      viewportHeight = Mercury.displayRect.fullHeight;
      titleHeight = this.titleElement.outerHeight();
      width = this.contentElement.outerWidth();
      if (width > viewportWidth - 40 || this.options.fullSize) {
        width = viewportWidth - 40;
      }
      if (this.contentPane) {
        this.contentPane.css({
          height: 'auto'
        });
      }
      this.contentElement.css({
        height: 'auto',
        visibility: visibility,
        display: 'block'
      });
      height = this.contentElement.outerHeight() + titleHeight;
      if (height > viewportHeight - 20 || this.options.fullSize) {
        height = viewportHeight - 20;
      }
      if (width < 300) {
        width = 300;
      }
      if (height < 150) {
        height = 150;
      }
      return this.element.stop().animate({
        top: ((viewportHeight - height) / 2) + 10,
        left: (Mercury.displayRect.width - width) / 2,
        width: width,
        height: height
      }, 200, 'easeInOutSine', function() {
        var controlHeight;
        _this.contentElement.css({
          visibility: 'visible',
          display: 'block'
        });
        if (_this.contentPane.length) {
          _this.contentElement.css({
            height: height - titleHeight,
            overflow: 'visible'
          });
          controlHeight = _this.contentControl.length ? _this.contentControl.outerHeight() : 0;
          _this.contentPane.css({
            height: height - titleHeight - controlHeight - 40
          });
          return _this.contentPane.find('.mercury-display-pane').css({
            width: width - 40
          });
        } else {
          return _this.contentElement.css({
            height: height - titleHeight - 30,
            overflow: 'auto'
          });
        }
      });
    };

    Lightview.prototype.position = function() {
      var controlHeight, height, titleHeight, viewportHeight, viewportWidth, width;
      viewportWidth = Mercury.displayRect.width;
      viewportHeight = Mercury.displayRect.fullHeight;
      if (this.contentPane) {
        this.contentPane.css({
          height: 'auto'
        });
      }
      this.contentElement.css({
        height: 'auto'
      });
      this.element.css({
        width: 'auto',
        height: 'auto',
        display: 'block',
        visibility: 'hidden'
      });
      width = this.contentElement.width() + 40;
      height = this.contentElement.height() + this.titleElement.outerHeight() + 30;
      if (width > viewportWidth - 40 || this.options.fullSize) {
        width = viewportWidth - 40;
      }
      if (height > viewportHeight - 20 || this.options.fullSize) {
        height = viewportHeight - 20;
      }
      if (width < 300) {
        width = 300;
      }
      if (height < 150) {
        height = 150;
      }
      titleHeight = this.titleElement.outerHeight();
      if (this.contentPane && this.contentPane.length) {
        this.contentElement.css({
          height: height - titleHeight,
          overflow: 'visible'
        });
        controlHeight = this.contentControl.length ? this.contentControl.outerHeight() : 0;
        this.contentPane.css({
          height: height - titleHeight - controlHeight - 40
        });
        this.contentPane.find('.mercury-display-pane').css({
          width: width - 40
        });
      } else {
        this.contentElement.css({
          height: height - titleHeight - 30,
          overflow: 'auto'
        });
      }
      return this.element.css({
        top: ((viewportHeight - height) / 2) + 10,
        left: (viewportWidth - width) / 2,
        width: width,
        height: height,
        display: this.visible ? 'block' : 'none',
        visibility: 'visible'
      });
    };

    Lightview.prototype.update = function() {
      this.reset();
      this.resize();
      return this.load();
    };

    Lightview.prototype.load = function() {
      var _this = this;
      this.setTitle();
      if (!this.url) {
        return;
      }
      this.element.addClass('loading');
      if (Mercury.preloadedViews[this.url]) {
        return setTimeout((function() {
          return _this.loadContent(Mercury.preloadedViews[_this.url]);
        }), 10);
      } else {
        return jQuery.ajax(this.url, {
          headers: Mercury.ajaxHeaders(),
          type: this.options.loadType || 'GET',
          data: this.options.loadData,
          success: function(data) {
            return _this.loadContent(data);
          },
          error: function() {
            _this.hide();
            return Mercury.notify('Mercury was unable to load %s for the lightview.', _this.url);
          }
        });
      }
    };

    Lightview.prototype.loadContent = function(data, options) {
      if (options == null) {
        options = null;
      }
      this.initializeLightview();
      this.options = options || this.options;
      this.setTitle();
      this.loaded = true;
      this.element.removeClass('loading');
      this.contentElement.html(data);
      this.contentElement.css({
        display: 'none',
        visibility: 'hidden'
      });
      this.contentPane = this.element.find('.mercury-display-pane-container');
      this.contentControl = this.element.find('.mercury-display-controls');
      if (this.options.afterLoad) {
        this.options.afterLoad.call(this);
      }
      if (this.options.handler) {
        if (Mercury.modalHandlers[this.options.handler]) {
          if (typeof Mercury.modalHandlers[this.options.handler] === 'function') {
            Mercury.modalHandlers[this.options.handler].call(this);
          } else {
            jQuery.extend(this, Mercury.modalHandlers[this.options.handler]);
            this.initialize();
          }
        } else if (Mercury.lightviewHandlers[this.options.handler]) {
          if (typeof Mercury.lightviewHandlers[this.options.handler] === 'function') {
            Mercury.lightviewHandlers[this.options.handler].call(this);
          } else {
            jQuery.extend(this, Mercury.lightviewHandlers[this.options.handler]);
            this.initialize();
          }
        }
      }
      if (Mercury.config.localization.enabled) {
        this.element.localize(Mercury.locale());
      }
      this.element.find('.lightview-close').on('click', this.hide);
      return this.resize();
    };

    Lightview.prototype.setTitle = function() {
      return this.titleElement.find('span').html(Mercury.I18n(this.options.title));
    };

    Lightview.prototype.serializeForm = function() {
      return this.element.find('form').serializeObject() || {};
    };

    Lightview.prototype.reset = function() {
      this.titleElement.find('span').html('');
      return this.contentElement.html('');
    };

    Lightview.prototype.hide = function() {
      if (this.showing) {
        return;
      }
      this.options = {};
      Mercury.trigger('focus:frame');
      this.element.hide();
      this.overlay.hide();
      this.reset();
      return this.visible = false;
    };

    return Lightview;

  })();

}).call(this);
(function() {

  this.Mercury.Statusbar = (function() {

    function Statusbar(options) {
      this.options = options != null ? options : {};
      this.visible = this.options.visible;
      this.build();
      this.bindEvents();
    }

    Statusbar.prototype.build = function() {
      var _ref;
      this.element = jQuery('<div>', {
        "class": 'mercury-statusbar'
      });
      this.aboutElement = jQuery('<a>', {
        "class": "mercury-statusbar-about"
      }).appendTo(this.element).html("Mercury Editor v" + Mercury.version);
      this.pathElement = jQuery('<div>', {
        "class": 'mercury-statusbar-path'
      }).appendTo(this.element);
      if (!this.visible) {
        this.element.css({
          visibility: 'hidden'
        });
      }
      return this.element.appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
    };

    Statusbar.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('region:update', function(event, options) {
        if (options.region && jQuery.type(options.region.path) === 'function') {
          return _this.setPath(options.region.path());
        }
      });
      return this.aboutElement.on('click', function() {
        return Mercury.lightview('/mercury/lightviews/about.html', {
          title: "Mercury Editor v" + Mercury.version
        });
      });
    };

    Statusbar.prototype.height = function() {
      return this.element.outerHeight();
    };

    Statusbar.prototype.top = function() {
      var currentTop, top;
      top = this.element.offset().top;
      currentTop = parseInt(this.element.css('bottom')) < 0 ? top - this.element.outerHeight() : top;
      if (this.visible) {
        return currentTop;
      } else {
        return top + this.element.outerHeight();
      }
    };

    Statusbar.prototype.setPath = function(elements) {
      var element, path, _i, _len;
      path = [];
      for (_i = 0, _len = elements.length; _i < _len; _i++) {
        element = elements[_i];
        path.push("<a>" + (element.tagName.toLowerCase()) + "</a>");
      }
      return this.pathElement.html("<span><strong>" + (Mercury.I18n('Path:')) + " </strong>" + (path.reverse().join(' &raquo; ')) + "</span>");
    };

    Statusbar.prototype.show = function() {
      this.visible = true;
      this.element.css({
        opacity: 0,
        visibility: 'visible'
      });
      return this.element.animate({
        opacity: 1
      }, 200, 'easeInOutSine');
    };

    Statusbar.prototype.hide = function() {
      this.visible = false;
      return this.element.css({
        visibility: 'hidden'
      });
    };

    return Statusbar;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty;

  this.Mercury.Toolbar = (function() {

    function Toolbar(options) {
      this.options = options != null ? options : {};
      this.visible = this.options.visible;
      this.build();
      this.bindEvents();
    }

    Toolbar.prototype.build = function() {
      var button, buttonName, buttons, container, expander, options, toolbar, toolbarName, _ref, _ref1;
      this.element = jQuery('<div>', {
        "class": 'mercury-toolbar-container',
        style: 'width:10000px'
      });
      this.element.css({
        width: '100%'
      });
      this.element.appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
      _ref1 = Mercury.config.toolbars;
      for (toolbarName in _ref1) {
        if (!__hasProp.call(_ref1, toolbarName)) continue;
        buttons = _ref1[toolbarName];
        if (buttons._custom) {
          continue;
        }
        toolbar = jQuery('<div>', {
          "class": "mercury-toolbar mercury-" + toolbarName + "-toolbar"
        }).appendTo(this.element);
        if (buttons._regions) {
          toolbar.attr('data-regions', buttons._regions);
        }
        container = jQuery('<div>', {
          "class": 'mercury-toolbar-button-container'
        }).appendTo(toolbar);
        for (buttonName in buttons) {
          if (!__hasProp.call(buttons, buttonName)) continue;
          options = buttons[buttonName];
          if (buttonName === '_regions') {
            continue;
          }
          button = this.buildButton(buttonName, options);
          if (button) {
            button.appendTo(container);
          }
        }
        if (container.css('white-space') === 'nowrap') {
          expander = new Mercury.Toolbar.Expander(toolbarName, {
            appendTo: toolbar,
            "for": container
          });
          expander.appendTo(this.element);
        }
        if (Mercury.config.toolbars['primary'] && toolbarName !== 'primary') {
          toolbar.addClass('disabled');
        }
      }
      if (!this.visible) {
        return this.element.css({
          display: 'none'
        });
      }
    };

    Toolbar.prototype.buildButton = function(name, options) {
      var action, button, group, handled, opts, summary, title;
      if (name[0] === '_') {
        return false;
      }
      switch (jQuery.type(options)) {
        case 'array':
          title = options[0], summary = options[1], handled = options[2];
          return new Mercury.Toolbar.Button(name, title, summary, handled, {
            appendDialogsTo: this.element
          });
        case 'object':
          group = new Mercury.Toolbar.ButtonGroup(name, options);
          for (action in options) {
            if (!__hasProp.call(options, action)) continue;
            opts = options[action];
            button = this.buildButton(action, opts);
            if (button) {
              button.appendTo(group);
            }
          }
          return group;
        case 'string':
          return jQuery('<hr>', {
            "class": "mercury-" + (options === '-' ? 'line-separator' : 'separator')
          });
        default:
          throw Mercury.I18n('Unknown button structure -- please provide an array, object, or string for "%s".', name);
      }
    };

    Toolbar.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('region:focused', function(event, options) {
        var regions, toolbar, _i, _len, _ref, _results;
        _ref = _this.element.find(".mercury-toolbar");
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          toolbar = _ref[_i];
          toolbar = jQuery(toolbar);
          if (regions = toolbar.data('regions')) {
            if (regions.split(',').indexOf(options.region.type()) > -1) {
              _results.push(toolbar.removeClass('disabled'));
            } else {
              _results.push(void 0);
            }
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
      Mercury.on('region:blurred', function(event, options) {
        var regions, toolbar, _i, _len, _ref, _results;
        _ref = _this.element.find(".mercury-toolbar");
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          toolbar = _ref[_i];
          toolbar = jQuery(toolbar);
          if (regions = toolbar.data('regions')) {
            if (regions.split(',').indexOf(options.region.type()) > -1) {
              _results.push(toolbar.addClass('disabled'));
            } else {
              _results.push(void 0);
            }
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
      this.element.on('click', function() {
        return Mercury.trigger('hide:dialogs');
      });
      return this.element.on('mousedown', function(event) {
        return event.preventDefault();
      });
    };

    Toolbar.prototype.height = function(force) {
      if (force == null) {
        force = false;
      }
      if (this.visible || force) {
        return this.element.outerHeight();
      } else {
        return 0;
      }
    };

    Toolbar.prototype.top = function() {
      if (this.visible) {
        return this.element.offset().top;
      } else {
        return 0;
      }
    };

    Toolbar.prototype.show = function() {
      this.visible = true;
      this.element.css({
        top: -this.element.outerHeight(),
        display: 'block'
      });
      return this.element.animate({
        top: 0
      }, 200, 'easeInOutSine');
    };

    Toolbar.prototype.hide = function() {
      this.visible = false;
      return this.element.hide();
    };

    return Toolbar;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty;

  this.Mercury.Toolbar.Button = (function() {

    function Button(name, title, summary, types, options) {
      this.name = name;
      this.title = title;
      this.summary = summary != null ? summary : null;
      this.types = types != null ? types : {};
      this.options = options != null ? options : {};
      if (this.title) {
        this.title = Mercury.I18n(this.title);
      }
      if (this.summary) {
        this.summary = Mercury.I18n(this.summary);
      }
      this.build();
      this.bindEvents();
      return this.element;
    }

    Button.prototype.build = function() {
      var mixed, result, type, _ref, _ref1, _results;
      this.element = jQuery('<div>', {
        title: (_ref = this.summary) != null ? _ref : this.title,
        "class": "mercury-button mercury-" + this.name + "-button"
      }).html("<em>" + this.title + "</em>");
      this.element.data('expander', "<div class=\"mercury-expander-button\" data-button=\"" + this.name + "\"><em></em><span>" + this.title + "</span></div>");
      this.handled = {};
      _ref1 = this.types;
      _results = [];
      for (type in _ref1) {
        if (!__hasProp.call(_ref1, type)) continue;
        mixed = _ref1[type];
        switch (type) {
          case 'preload':
            _results.push(true);
            break;
          case 'regions':
            this.element.addClass('disabled');
            _results.push(this.handled[type] = jQuery.isFunction(mixed) ? mixed.call(this, this.name) : mixed);
            break;
          case 'toggle':
            _results.push(this.handled[type] = true);
            break;
          case 'mode':
            _results.push(this.handled[type] = mixed === true ? this.name : mixed);
            break;
          case 'context':
            _results.push(this.handled[type] = jQuery.isFunction(mixed) ? mixed : Mercury.Toolbar.Button.contexts[this.name]);
            break;
          case 'palette':
            this.element.addClass("mercury-button-palette");
            result = jQuery.isFunction(mixed) ? mixed.call(this, this.name) : mixed;
            _results.push(this.handled[type] = typeof result === 'string' ? new Mercury.Palette(result, this.name, this.defaultDialogOptions()) : result);
            break;
          case 'select':
            this.element.addClass("mercury-button-select").find('em').html(this.title);
            result = jQuery.isFunction(mixed) ? mixed.call(this, this.name) : mixed;
            _results.push(this.handled[type] = typeof result === 'string' ? new Mercury.Select(result, this.name, this.defaultDialogOptions()) : result);
            break;
          case 'panel':
            this.element.addClass('mercury-button-panel');
            this.handled['toggle'] = true;
            result = jQuery.isFunction(mixed) ? mixed.call(this, this.name) : mixed;
            _results.push(this.handled[type] = typeof result === 'string' ? new Mercury.Panel(result, this.name, this.defaultDialogOptions()) : result);
            break;
          case 'modal':
            _results.push(this.handled[type] = jQuery.isFunction(mixed) ? mixed.call(this, this.name) : mixed);
            break;
          case 'lightview':
            _results.push(this.handled[type] = jQuery.isFunction(mixed) ? mixed.call(this, this.name) : mixed);
            break;
          default:
            throw Mercury.I18n('Unknown button type \"%s\" used for the \"%s\" button.', type, this.name);
        }
      }
      return _results;
    };

    Button.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('button', function(event, options) {
        if (options.action === _this.name) {
          return _this.element.click();
        }
      });
      Mercury.on('mode', function(event, options) {
        if (_this.handled.mode === options.mode && _this.handled.toggle) {
          return _this.togglePressed();
        }
      });
      Mercury.on('region:update', function(event, options) {
        var element;
        if (_this.handled.context && options.region && jQuery.type(options.region.currentElement) === 'function') {
          element = options.region.currentElement();
          if (element.length && _this.handled.context.call(_this, element, options.region.element)) {
            return _this.element.addClass('active');
          } else {
            return _this.element.removeClass('active');
          }
        } else {
          return _this.element.removeClass('active');
        }
      });
      Mercury.on('region:focused', function(event, options) {
        if (_this.handled.regions && options.region && options.region.type()) {
          if (_this.handled.regions.indexOf(options.region.type()) > -1) {
            return _this.element.removeClass('disabled');
          } else {
            return _this.element.addClass('disabled');
          }
        }
      });
      Mercury.on('region:blurred', function() {
        if (_this.handled.regions) {
          return _this.element.addClass('disabled');
        }
      });
      this.element.on('mousedown', function() {
        return _this.element.addClass('active');
      });
      this.element.on('mouseup', function() {
        return _this.element.removeClass('active');
      });
      return this.element.on('click', function(event) {
        if (_this.element.closest('.disabled').length) {
          return;
        }
        return _this.handleClick(event);
      });
    };

    Button.prototype.handleClick = function(event) {
      var handled, mixed, type, _ref;
      handled = false;
      _ref = this.handled;
      for (type in _ref) {
        if (!__hasProp.call(_ref, type)) continue;
        mixed = _ref[type];
        switch (type) {
          case 'toggle':
            if (!this.handled.mode) {
              this.togglePressed();
            }
            break;
          case 'mode':
            handled = true;
            Mercury.trigger('mode', {
              mode: mixed
            });
            break;
          case 'modal':
            handled = this.handleModal(event);
            break;
          case 'lightview':
            handled = this.handleLightview(event);
            break;
          case 'palette':
          case 'select':
          case 'panel':
            handled = this.handleDialog(event, type);
        }
      }
      if (!handled) {
        Mercury.trigger('action', {
          action: this.name
        });
      }
      if (this.options['regions'] && this.options['regions'].length) {
        return Mercury.trigger('focus:frame');
      }
    };

    Button.prototype.handleModal = function(event) {
      Mercury.modal(this.handled.modal, {
        title: this.summary || this.title,
        handler: this.name
      });
      return true;
    };

    Button.prototype.handleLightview = function(event) {
      Mercury.lightview(this.handled.lightview, {
        title: this.summary || this.title,
        handler: this.name,
        closeButton: true
      });
      return true;
    };

    Button.prototype.handleDialog = function(event, type) {
      event.stopPropagation();
      this.handled[type].toggle();
      return true;
    };

    Button.prototype.defaultDialogOptions = function() {
      return {
        title: this.summary || this.title,
        preload: this.types.preload,
        appendTo: this.options.appendDialogsTo || 'body',
        closeButton: true,
        "for": this.element
      };
    };

    Button.prototype.togglePressed = function() {
      return this.element.toggleClass('pressed');
    };

    return Button;

  })();

  this.Mercury.Toolbar.Button.contexts = {
    backColor: function(node) {
      return this.element.css('background-color', node.css('background-color'));
    },
    foreColor: function(node) {
      return this.element.css('background-color', node.css('color'));
    },
    bold: function(node) {
      var weight;
      weight = node.css('font-weight');
      return weight === 'bold' || weight > 400;
    },
    italic: function(node) {
      return node.css('font-style') === 'italic';
    },
    overline: function(node) {
      var parent, _i, _len, _ref;
      if (node.css('text-decoration') === 'overline') {
        return true;
      }
      _ref = node.parentsUntil(this.element);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        parent = _ref[_i];
        if (jQuery(parent).css('text-decoration') === 'overline') {
          return true;
        }
      }
      return false;
    },
    strikethrough: function(node, region) {
      return node.css('text-decoration') === 'line-through' || !!node.closest('strike', region).length;
    },
    underline: function(node, region) {
      return node.css('text-decoration') === 'underline' || !!node.closest('u', region).length;
    },
    subscript: function(node, region) {
      return !!node.closest('sub', region).length;
    },
    superscript: function(node, region) {
      return !!node.closest('sup', region).length;
    },
    justifyLeft: function(node) {
      return node.css('text-align').indexOf('left') > -1;
    },
    justifyCenter: function(node) {
      return node.css('text-align').indexOf('center') > -1;
    },
    justifyRight: function(node) {
      return node.css('text-align').indexOf('right') > -1;
    },
    justifyFull: function(node) {
      return node.css('text-align').indexOf('justify') > -1;
    },
    insertOrderedList: function(node, region) {
      return !!node.closest('ol', region.element).length;
    },
    insertUnorderedList: function(node, region) {
      return !!node.closest('ul', region.element).length;
    }
  };

}).call(this);
(function() {

  this.Mercury.Toolbar.ButtonGroup = (function() {

    function ButtonGroup(name, options) {
      this.name = name;
      this.options = options != null ? options : {};
      this.build();
      this.bindEvents();
      this.regions = this.options._regions;
      return this.element;
    }

    ButtonGroup.prototype.build = function() {
      this.element = jQuery('<div>', {
        "class": "mercury-button-group mercury-" + this.name + "-group"
      });
      if (this.options._context || this.options._regions) {
        return this.element.addClass('disabled');
      }
    };

    ButtonGroup.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('region:update', function(event, options) {
        var context, element;
        context = Mercury.Toolbar.ButtonGroup.contexts[_this.name];
        if (context) {
          if (options.region && jQuery.type(options.region.currentElement) === 'function') {
            element = options.region.currentElement();
            if (element.length && context.call(_this, element, options.region.element)) {
              return _this.element.removeClass('disabled');
            } else {
              return _this.element.addClass('disabled');
            }
          }
        }
      });
      Mercury.on('region:focused', function(event, options) {
        if (_this.regions && options.region && options.region.type()) {
          if (_this.regions.indexOf(options.region.type()) > -1) {
            if (!_this.options._context) {
              return _this.element.removeClass('disabled');
            }
          } else {
            return _this.element.addClass('disabled');
          }
        }
      });
      return Mercury.on('region:blurred', function(event, options) {
        if (_this.options.regions) {
          return _this.element.addClass('disabled');
        }
      });
    };

    return ButtonGroup;

  })();

  this.Mercury.Toolbar.ButtonGroup.contexts = {
    table: function(node, region) {
      return !!node.closest('table', region).length;
    }
  };

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Mercury.Toolbar.Expander = (function(_super) {

    __extends(Expander, _super);

    function Expander(name, options) {
      this.name = name;
      this.options = options;
      this.container = this.options["for"];
      Expander.__super__.constructor.call(this, null, this.name, this.options);
      return this.element;
    }

    Expander.prototype.build = function() {
      var _ref;
      this.container.css({
        whiteSpace: 'normal',
        visibility: 'hidden',
        display: 'block'
      });
      this.containerWidth = this.container.outerWidth();
      this.container.css({
        visibility: 'visible'
      });
      this.trigger = jQuery('<div>', {
        "class": 'mercury-toolbar-expander'
      }).appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
      this.element = jQuery('<div>', {
        "class": "mercury-palette mercury-expander mercury-" + this.name + "-expander",
        style: 'display:none'
      });
      return this.windowResize();
    };

    Expander.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('hide:dialogs', function(event, dialog) {
        if (dialog !== _this) {
          return _this.hide();
        }
      });
      Mercury.on('resize', function() {
        return _this.windowResize();
      });
      Expander.__super__.bindEvents.apply(this, arguments);
      this.trigger.click(function(event) {
        var button, hiddenButtons, _i, _len, _ref;
        event.stopPropagation();
        hiddenButtons = [];
        _ref = _this.container.find('.mercury-button');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          button = _ref[_i];
          button = jQuery(button);
          if (button.position().top > 5) {
            hiddenButtons.push(button.data('expander'));
          }
        }
        _this.loadContent(hiddenButtons.join(''));
        return _this.toggle();
      });
      return this.element.click(function(event) {
        var button, buttonName;
        buttonName = jQuery(event.target).closest('[data-button]').data('button');
        button = _this.container.find(".mercury-" + buttonName + "-button");
        return button.click();
      });
    };

    Expander.prototype.windowResize = function() {
      if (this.containerWidth > jQuery(window).width()) {
        this.trigger.show();
      } else {
        this.trigger.hide();
      }
      return this.hide();
    };

    Expander.prototype.position = function(keepVisible) {
      var position, width;
      this.element.css({
        top: 0,
        left: 0,
        display: 'block',
        visibility: 'hidden'
      });
      position = this.trigger.position();
      width = this.element.width();
      if (position.left + width > jQuery(window).width()) {
        position.left = position.left - width + this.trigger.width();
      }
      return this.element.css({
        top: position.top + this.trigger.height(),
        left: position.left,
        display: keepVisible ? 'block' : 'none',
        visibility: 'visible'
      });
    };

    return Expander;

  })(Mercury.Palette);

}).call(this);
(function() {

  this.Mercury.tooltip = function(forElement, content, options) {
    if (options == null) {
      options = {};
    }
    Mercury.tooltip.show(forElement, content, options);
    return Mercury.tooltip;
  };

  jQuery.extend(Mercury.tooltip, {
    show: function(forElement, content, options) {
      this.forElement = forElement;
      this.content = content;
      this.options = options != null ? options : {};
      this.document = this.forElement.get(0).ownerDocument;
      this.initialize();
      if (this.visible) {
        return this.update();
      } else {
        return this.appear();
      }
    },
    initialize: function() {
      if (this.initialized) {
        return;
      }
      this.build();
      this.bindEvents();
      return this.initialized = true;
    },
    build: function() {
      var _ref;
      this.element = jQuery('<div>', {
        "class": 'mercury-tooltip'
      });
      return this.element.appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
    },
    bindEvents: function() {
      var parent, _i, _len, _ref,
        _this = this;
      Mercury.on('resize', function() {
        if (_this.visible) {
          return _this.position();
        }
      });
      this.element.on('mousedown', function(event) {
        event.preventDefault();
        return event.stopPropagation();
      });
      _ref = this.forElement.parentsUntil(jQuery('body', this.document));
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        parent = _ref[_i];
        if (!(parent.scrollHeight > parent.clientHeight)) {
          continue;
        }
        jQuery(parent).on('scroll', function() {
          if (_this.visible) {
            return _this.position();
          }
        });
      }
      return jQuery(this.document).on('scroll', function() {
        if (_this.visible) {
          return _this.position();
        }
      });
    },
    appear: function() {
      var _this = this;
      this.update();
      this.element.show();
      return this.element.animate({
        opacity: 1
      }, 200, 'easeInOutSine', function() {
        return _this.visible = true;
      });
    },
    update: function() {
      this.element.html(this.content);
      return this.position();
    },
    position: function() {
      var left, offset, top, width;
      offset = this.forElement.offset();
      width = this.element.width();
      top = offset.top + (Mercury.displayRect.top - jQuery(this.document).scrollTop()) + this.forElement.outerHeight();
      left = offset.left - jQuery(this.document).scrollLeft();
      if ((left + width + 25) > Mercury.displayRect.width) {
        left = left - (left + width + 25) - Mercury.displayRect.width;
      }
      left = left <= 0 ? 0 : left;
      return this.element.css({
        top: top,
        left: left
      });
    },
    hide: function() {
      if (!this.initialized) {
        return;
      }
      this.element.hide();
      return this.visible = false;
    }
  });

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty;

  this.Mercury.Snippet = (function() {

    Snippet.all = [];

    Snippet.displayOptionsFor = function(name, options, displayOptions) {
      var snippet;
      if (options == null) {
        options = {};
      }
      if (displayOptions == null) {
        displayOptions = true;
      }
      if (displayOptions) {
        Mercury.modal(this.optionsUrl(name), jQuery.extend({
          title: 'Snippet Options',
          handler: 'insertSnippet',
          snippetName: name,
          loadType: Mercury.config.snippets.method
        }, options));
      } else {
        snippet = Mercury.Snippet.create(name);
        Mercury.trigger('action', {
          action: 'insertSnippet',
          value: snippet
        });
      }
      return Mercury.snippet = null;
    };

    Snippet.optionsUrl = function(name) {
      var url;
      url = Mercury.config.snippets.optionsUrl;
      if (typeof url === 'function') {
        url = url();
      }
      return url.replace(':name', name);
    };

    Snippet.previewUrl = function(name) {
      var url;
      url = Mercury.config.snippets.previewUrl;
      if (typeof url === 'function') {
        url = url();
      }
      return url.replace(':name', name);
    };

    Snippet.create = function(name, options) {
      var instance;
      instance = new Mercury.Snippet(name, this.uniqueId(), options);
      this.all.push(instance);
      return instance;
    };

    Snippet.uniqueId = function() {
      var i, identities, identity, snippet, _ref;
      _ref = [0, "snippet_0"], i = _ref[0], identity = _ref[1];
      identities = (function() {
        var _i, _len, _ref1, _results;
        _ref1 = this.all;
        _results = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          snippet = _ref1[_i];
          _results.push(snippet.identity);
        }
        return _results;
      }).call(this);
      while (identities.indexOf(identity) !== -1) {
        i += 1;
        identity = "snippet_" + i;
      }
      return identity;
    };

    Snippet.find = function(identity) {
      var snippet, _i, _len, _ref;
      _ref = this.all;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        snippet = _ref[_i];
        if (snippet.identity === identity) {
          return snippet;
        }
      }
      return null;
    };

    Snippet.load = function(snippets) {
      var details, identity, instance, _results;
      _results = [];
      for (identity in snippets) {
        if (!__hasProp.call(snippets, identity)) continue;
        details = snippets[identity];
        instance = new Mercury.Snippet(details.name, identity, details);
        _results.push(this.all.push(instance));
      }
      return _results;
    };

    Snippet.clearAll = function() {
      delete this.all;
      return this.all = [];
    };

    function Snippet(name, identity, options) {
      this.name = name;
      this.identity = identity;
      if (options == null) {
        options = {};
      }
      this.version = 0;
      this.data = '';
      this.wrapperTag = 'div';
      this.history = new Mercury.HistoryBuffer();
      this.setOptions(options);
    }

    Snippet.prototype.getHTML = function(context, callback) {
      var element;
      if (callback == null) {
        callback = null;
      }
      element = jQuery("<" + this.wrapperTag + ">", {
        "class": "" + this.name + "-snippet",
        contenteditable: "false",
        'data-snippet': this.identity,
        'data-version': this.version
      }, context);
      element.html("[" + this.identity + "]");
      this.loadPreview(element, callback);
      return element;
    };

    Snippet.prototype.getText = function(callback) {
      return "[--" + this.identity + "--]";
    };

    Snippet.prototype.loadPreview = function(element, callback) {
      var _this = this;
      if (callback == null) {
        callback = null;
      }
      return jQuery.ajax(Snippet.previewUrl(this.name), {
        headers: Mercury.ajaxHeaders(),
        type: Mercury.config.snippets.method,
        data: this.options,
        success: function(data) {
          _this.data = data;
          element.html(data);
          if (callback) {
            return callback();
          }
        },
        error: function() {
          return Mercury.notify('Error loading the preview for the \"%s\" snippet.', _this.name);
        }
      });
    };

    Snippet.prototype.displayOptions = function() {
      Mercury.snippet = this;
      return Mercury.modal(Snippet.optionsUrl(this.name), {
        title: 'Snippet Options',
        handler: 'insertSnippet',
        loadType: Mercury.config.snippets.method,
        loadData: this.options
      });
    };

    Snippet.prototype.setOptions = function(options) {
      this.options = options;
      delete this.options['authenticity_token'];
      delete this.options['utf8'];
      if (this.options.wrapperTag) {
        this.wrapperTag = this.options.wrapperTag;
      }
      this.version += 1;
      return this.history.push(this.options);
    };

    Snippet.prototype.setVersion = function(version) {
      if (version == null) {
        version = null;
      }
      version = parseInt(version);
      if (version && this.history.stack[version - 1]) {
        this.version = version;
        this.options = this.history.stack[version - 1];
        return true;
      }
      return false;
    };

    Snippet.prototype.serialize = function() {
      return $.extend({
        name: this.name
      }, this.options);
    };

    return Snippet;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Mercury.SnippetToolbar = (function(_super) {

    __extends(SnippetToolbar, _super);

    function SnippetToolbar(document, options) {
      this.document = document;
      this.options = options != null ? options : {};
      this._boundEvents = [];
      SnippetToolbar.__super__.constructor.call(this, this.options);
    }

    SnippetToolbar.prototype.build = function() {
      var button, buttonName, options, _ref, _ref1, _results;
      this.element = jQuery('<div>', {
        "class": 'mercury-toolbar mercury-snippet-toolbar',
        style: 'display:none'
      });
      this.element.appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
      _ref1 = Mercury.config.toolbars.snippets;
      _results = [];
      for (buttonName in _ref1) {
        if (!__hasProp.call(_ref1, buttonName)) continue;
        options = _ref1[buttonName];
        button = this.buildButton(buttonName, options);
        if (button) {
          _results.push(button.appendTo(this.element));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    SnippetToolbar.prototype.bindEvents = function() {
      var _this = this;
      this.bindReleasableEvent(Mercury, 'show:toolbar', function(event, options) {
        if (!options.snippet) {
          return;
        }
        options.snippet.mouseout(function() {
          return _this.hide();
        });
        return _this.show(options.snippet);
      });
      this.bindReleasableEvent(Mercury, 'hide:toolbar', function(event, options) {
        if (!(options.type && options.type === 'snippet')) {
          return;
        }
        return _this.hide(options.immediately);
      });
      this.bindReleasableEvent(jQuery(this.document), 'scroll', function() {
        if (_this.visible) {
          return _this.position();
        }
      });
      this.element.mousemove(function() {
        return clearTimeout(_this.hideTimeout);
      });
      return this.element.mouseout(function() {
        return _this.hide();
      });
    };

    SnippetToolbar.prototype.bindReleasableEvent = function(target, eventName, handler) {
      target.on(eventName, handler);
      return this._boundEvents.push([target, eventName, handler]);
    };

    SnippetToolbar.prototype.show = function(snippet) {
      this.snippet = snippet;
      Mercury.tooltip.hide();
      this.position();
      return this.appear();
    };

    SnippetToolbar.prototype.position = function() {
      var left, offset, top;
      offset = this.snippet.offset();
      top = offset.top + Mercury.displayRect.top - jQuery(this.document).scrollTop() - this.height() + 10;
      left = offset.left - jQuery(this.document).scrollLeft();
      return this.element.css({
        top: top,
        left: left
      });
    };

    SnippetToolbar.prototype.appear = function() {
      clearTimeout(this.hideTimeout);
      if (this.visible) {
        return;
      }
      this.visible = true;
      this.element.css({
        display: 'block',
        opacity: 0
      });
      return this.element.stop().animate({
        opacity: 1
      }, 200, 'easeInOutSine');
    };

    SnippetToolbar.prototype.hide = function(immediately) {
      var _this = this;
      if (immediately == null) {
        immediately = false;
      }
      clearTimeout(this.hideTimeout);
      if (immediately) {
        this.element.hide();
        return this.visible = false;
      } else {
        return this.hideTimeout = setTimeout(function() {
          _this.element.stop().animate({
            opacity: 0
          }, 300, 'easeInOutSine', function() {
            return _this.element.hide();
          });
          return _this.visible = false;
        }, 500);
      }
    };

    SnippetToolbar.prototype.release = function() {
      var eventName, handler, target, _i, _len, _ref, _ref1;
      this.element.off();
      this.element.remove();
      _ref = this._boundEvents;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _ref1 = _ref[_i], target = _ref1[0], eventName = _ref1[1], handler = _ref1[2];
        target.off(eventName, handler);
      }
      return this._boundEvents = [];
    };

    return SnippetToolbar;

  })(Mercury.Toolbar);

}).call(this);
(function() {

  this.Mercury.Region = (function() {

    function Region(element, window, options) {
      this.element = element;
      this.window = window;
      this.options = options != null ? options : {};
      Mercury.log("building " + (this.type()), this.element, this.options);
      this.document = this.window.document;
      this.name = this.element.attr(Mercury.config.regions.identifier);
      this.history = new Mercury.HistoryBuffer();
      this.build();
      this.bindEvents();
      this.pushHistory();
      this.element.data('region', this);
    }

    Region.prototype.type = function() {
      return 'unknown';
    };

    Region.prototype.build = function() {};

    Region.prototype.focus = function() {};

    Region.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('mode', function(event, options) {
        if (options.mode === 'preview') {
          return _this.togglePreview();
        }
      });
      Mercury.on('focus:frame', function() {
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        return _this.focus();
      });
      Mercury.on('action', function(event, options) {
        if (_this.previewing || Mercury.region !== _this || event.isDefaultPrevented()) {
          return;
        }
        if (options.action) {
          return _this.execCommand(options.action, options);
        }
      });
      this.element.on('mousemove', function(event) {
        var snippet;
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        snippet = jQuery(event.target).closest('[data-snippet]');
        if (snippet.length) {
          _this.snippet = snippet;
          if (_this.snippet.data('snippet')) {
            return Mercury.trigger('show:toolbar', {
              type: 'snippet',
              snippet: _this.snippet
            });
          }
        }
      });
      return this.element.on('mouseout', function() {
        if (_this.previewing) {
          return;
        }
        return Mercury.trigger('hide:toolbar', {
          type: 'snippet',
          immediately: false
        });
      });
    };

    Region.prototype.content = function(value, filterSnippets) {
      var container, snippet, _i, _len, _ref;
      if (value == null) {
        value = null;
      }
      if (filterSnippets == null) {
        filterSnippets = false;
      }
      if (value !== null) {
        return this.element.html(value);
      } else {
        container = jQuery('<div>').appendTo(this.document.createDocumentFragment());
        container.html(this.element.html().replace(/^\s+|\s+$/g, ''));
        if (filterSnippets) {
          _ref = container.find('[data-snippet]');
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            snippet = _ref[_i];
            snippet = jQuery(snippet);
            snippet.attr({
              contenteditable: null,
              'data-version': null
            });
            snippet.html("[" + (snippet.data('snippet')) + "]");
          }
        }
        return container.html();
      }
    };

    Region.prototype.togglePreview = function() {
      if (this.previewing) {
        this.previewing = false;
        this.element.attr(Mercury.config.regions.attribute, this.type());
        if (Mercury.region === this) {
          return this.focus();
        }
      } else {
        this.previewing = true;
        this.element.removeAttr(Mercury.config.regions.attribute);
        return Mercury.trigger('region:blurred', {
          region: this
        });
      }
    };

    Region.prototype.execCommand = function(action, options) {
      if (options == null) {
        options = {};
      }
      this.focus();
      if (action !== 'redo') {
        this.pushHistory();
      }
      Mercury.log('execCommand', action, options.value);
      return Mercury.changes = true;
    };

    Region.prototype.pushHistory = function() {
      return this.history.push(this.content());
    };

    Region.prototype.snippets = function() {
      var element, snippet, snippets, _i, _len, _ref;
      snippets = {};
      _ref = this.element.find('[data-snippet]');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        element = _ref[_i];
        snippet = Mercury.Snippet.find(jQuery(element).data('snippet'));
        if (!snippet) {
          continue;
        }
        snippets[snippet.identity] = snippet.serialize();
      }
      return snippets;
    };

    Region.prototype.dataAttributes = function() {
      var attr, data, _i, _len, _ref;
      data = {};
      _ref = Mercury.config.regions.dataAttributes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attr = _ref[_i];
        data[attr] = (this.container || this.element).attr('data-' + attr);
      }
      return data;
    };

    Region.prototype.serialize = function() {
      return {
        type: this.type(),
        data: this.dataAttributes(),
        value: this.content(null, true),
        snippets: this.snippets()
      };
    };

    return Region;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty;

  this.Mercury.uploader = function(file, options) {
    if (Mercury.config.uploading.enabled) {
      Mercury.uploader.show(file, options);
    }
    return Mercury.uploader;
  };

  jQuery.extend(Mercury.uploader, {
    show: function(file, options) {
      this.options = options != null ? options : {};
      this.file = new Mercury.uploader.File(file);
      if (this.file.errors) {
        alert("Error: " + this.file.errors);
        return;
      }
      if (!this.supported()) {
        return;
      }
      Mercury.trigger('focus:window');
      this.initialize();
      return this.appear();
    },
    initialize: function() {
      if (this.initialized) {
        return;
      }
      this.build();
      this.bindEvents();
      return this.initialized = true;
    },
    supported: function() {
      var xhr;
      xhr = new XMLHttpRequest;
      if (window.Uint8Array && window.ArrayBuffer && !XMLHttpRequest.prototype.sendAsBinary) {
        XMLHttpRequest.prototype.sendAsBinary = function(datastr) {
          var data, index, ui8a, _i, _len;
          ui8a = new Uint8Array(datastr.length);
          for (index = _i = 0, _len = datastr.length; _i < _len; index = ++_i) {
            data = datastr[index];
            ui8a[index] = datastr.charCodeAt(index) & 0xff;
          }
          return this.send(ui8a.buffer);
        };
      }
      return !!(xhr.upload && xhr.sendAsBinary && (Mercury.uploader.fileReaderSupported() || Mercury.uploader.formDataSupported()));
    },
    fileReaderSupported: function() {
      return !!window.FileReader;
    },
    formDataSupported: function() {
      return !!window.FormData;
    },
    build: function() {
      var _ref, _ref1;
      this.element = jQuery('<div>', {
        "class": 'mercury-uploader',
        style: 'display:none'
      });
      this.element.append('<div class="mercury-uploader-preview"><b><img/></b></div>');
      this.element.append('<div class="mercury-uploader-details"></div>');
      this.element.append('<div class="mercury-uploader-progress"><span></span><div class="mercury-uploader-indicator"><div><b>0%</b></div></div></div>');
      this.updateStatus('Processing...');
      this.overlay = jQuery('<div>', {
        "class": 'mercury-uploader-overlay',
        style: 'display:none'
      });
      this.element.appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
      return this.overlay.appendTo((_ref1 = jQuery(this.options.appendTo).get(0)) != null ? _ref1 : 'body');
    },
    bindEvents: function() {
      var _this = this;
      return Mercury.on('resize', function() {
        return _this.position();
      });
    },
    appear: function() {
      var _this = this;
      this.fillDisplay();
      this.position();
      this.overlay.show();
      return this.overlay.animate({
        opacity: 1
      }, 200, 'easeInOutSine', function() {
        _this.element.show();
        return _this.element.animate({
          opacity: 1
        }, 200, 'easeInOutSine', function() {
          _this.visible = true;
          return _this.loadImage();
        });
      });
    },
    position: function() {
      var height, width;
      width = this.element.outerWidth();
      height = this.element.outerHeight();
      return this.element.css({
        top: (Mercury.displayRect.height - height) / 2,
        left: (Mercury.displayRect.width - width) / 2
      });
    },
    fillDisplay: function() {
      var details;
      details = [Mercury.I18n('Name: %s', this.file.name), Mercury.I18n('Size: %s', this.file.readableSize), Mercury.I18n('Type: %s', this.file.type)];
      return this.element.find('.mercury-uploader-details').html(details.join('<br/>'));
    },
    loadImage: function() {
      var _this = this;
      if (Mercury.uploader.fileReaderSupported()) {
        return this.file.readAsDataURL(function(result) {
          _this.element.find('.mercury-uploader-preview b').html(jQuery('<img>', {
            src: result
          }));
          return _this.upload();
        });
      } else {
        return this.upload();
      }
    },
    upload: function() {
      var formData, xhr,
        _this = this;
      xhr = new XMLHttpRequest;
      jQuery.each(['onloadstart', 'onprogress', 'onload', 'onabort', 'onerror'], function(index, eventName) {
        return xhr.upload[eventName] = function(event) {
          return _this.uploaderEvents[eventName].call(_this, event);
        };
      });
      xhr.onload = function(event) {
        var response, src;
        if (event.currentTarget.status >= 400) {
          _this.updateStatus('Error: Unable to upload the file');
          Mercury.notify('Unable to process response: %s', event.currentTarget.status);
          return _this.hide();
        } else {
          try {
            response = Mercury.config.uploading.handler ? Mercury.config.uploading.handler(event.target.responseText) : jQuery.parseJSON(event.target.responseText);
            src = response.url || response.image.url;
            if (!src) {
              throw 'Malformed response from server.';
            }
            Mercury.trigger('action', {
              action: 'insertImage',
              value: {
                src: src
              }
            });
            return _this.hide();
          } catch (error) {
            _this.updateStatus('Error: Unable to upload the file');
            Mercury.notify('Unable to process response: %s', error);
            return _this.hide();
          }
        }
      };
      xhr.open('post', Mercury.config.uploading.url, true);
      xhr.setRequestHeader('Accept', 'application/json, text/javascript, text/html, application/xml, text/xml, */*');
      xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
      xhr.setRequestHeader(Mercury.config.csrfHeader, Mercury.csrfToken);
      if (Mercury.uploader.fileReaderSupported()) {
        return this.file.readAsBinaryString(function(result) {
          var multipart;
          multipart = new Mercury.uploader.MultiPartPost(Mercury.config.uploading.inputName, _this.file, result);
          _this.file.updateSize(multipart.delta);
          xhr.setRequestHeader('Content-Type', 'multipart/form-data; boundary=' + multipart.boundary);
          return xhr.sendAsBinary(multipart.body);
        });
      } else {
        formData = new FormData();
        formData.append(Mercury.config.uploading.inputName, this.file.file, this.file.file.name);
        return xhr.send(formData);
      }
    },
    updateStatus: function(message, loaded) {
      var percent;
      this.element.find('.mercury-uploader-progress span').html(Mercury.I18n(message).toString());
      if (loaded) {
        percent = Math.floor(loaded * 100 / this.file.size) + '%';
        this.element.find('.mercury-uploader-indicator div').css({
          width: percent
        });
        return this.element.find('.mercury-uploader-indicator b').html(percent).show();
      }
    },
    hide: function(delay) {
      var _this = this;
      if (delay == null) {
        delay = 0;
      }
      return setTimeout(function() {
        return _this.element.animate({
          opacity: 0
        }, 200, 'easeInOutSine', function() {
          return _this.overlay.animate({
            opacity: 0
          }, 200, 'easeInOutSine', function() {
            _this.overlay.hide();
            _this.element.hide();
            _this.reset();
            _this.visible = false;
            return Mercury.trigger('focus:frame');
          });
        });
      }, delay * 1000);
    },
    reset: function() {
      this.element.find('.mercury-uploader-preview b').html('');
      this.element.find('.mercury-uploader-indicator div').css({
        width: 0
      });
      this.element.find('.mercury-uploader-indicator b').html('0%').hide();
      return this.updateStatus('Processing...');
    },
    uploaderEvents: {
      onloadstart: function() {
        return this.updateStatus('Uploading...');
      },
      onprogress: function(event) {
        return this.updateStatus('Uploading...', event.loaded);
      },
      onabort: function() {
        this.updateStatus('Aborted');
        return this.hide(1);
      },
      onload: function() {
        return this.updateStatus('Successfully uploaded...', this.file.size);
      },
      onerror: function() {
        this.updateStatus('Error: Unable to upload the file');
        return this.hide(3);
      }
    }
  });

  Mercury.uploader.File = (function() {

    function File(file) {
      var errors;
      this.file = file;
      this.fullSize = this.size = this.file.size || this.file.fileSize;
      this.readableSize = this.size.toBytes();
      this.name = this.file.name || this.file.fileName;
      this.type = this.file.type || this.file.fileType;
      errors = [];
      if (this.size >= Mercury.config.uploading.maxFileSize) {
        errors.push(Mercury.I18n('Too large'));
      }
      if (!(Mercury.config.uploading.allowedMimeTypes.indexOf(this.type) > -1)) {
        errors.push(Mercury.I18n('Unsupported format'));
      }
      if (errors.length) {
        this.errors = errors.join(' / ');
      }
    }

    File.prototype.readAsDataURL = function(callback) {
      var reader,
        _this = this;
      if (callback == null) {
        callback = null;
      }
      reader = new FileReader();
      reader.readAsDataURL(this.file);
      return reader.onload = function() {
        if (callback) {
          return callback(reader.result);
        }
      };
    };

    File.prototype.readAsBinaryString = function(callback) {
      var reader,
        _this = this;
      if (callback == null) {
        callback = null;
      }
      reader = new FileReader();
      reader.readAsBinaryString(this.file);
      return reader.onload = function() {
        if (callback) {
          return callback(reader.result);
        }
      };
    };

    File.prototype.updateSize = function(delta) {
      return this.fullSize = this.size + delta;
    };

    return File;

  })();

  Mercury.uploader.MultiPartPost = (function() {

    function MultiPartPost(inputName, file, contents, formInputs) {
      this.inputName = inputName;
      this.file = file;
      this.contents = contents;
      this.formInputs = formInputs != null ? formInputs : {};
      this.boundary = 'Boundaryx20072377098235644401115438165x';
      this.body = '';
      this.buildBody();
      this.delta = this.body.length - this.file.size;
    }

    MultiPartPost.prototype.buildBody = function() {
      var boundary, name, value, _ref;
      boundary = '--' + this.boundary;
      _ref = this.formInputs;
      for (name in _ref) {
        if (!__hasProp.call(_ref, name)) continue;
        value = _ref[name];
        this.body += "" + boundary + "\r\nContent-Disposition: form-data; name=\"" + name + "\"\r\n\r\n" + (unescape(encodeURIComponent(value))) + "\r\n";
      }
      return this.body += "" + boundary + "\r\nContent-Disposition: form-data; name=\"" + this.inputName + "\"; filename=\"" + this.file.name + "\"\r\nContent-Type: " + this.file.type + "\r\nContent-Transfer-Encoding: binary\r\n\r\n" + this.contents + "\r\n" + boundary + "--";
    };

    return MultiPartPost;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  this.Mercury.Regions.Full = (function(_super) {
    var type;

    __extends(Full, _super);

    Full.supported = document.designMode && !jQuery.browser.konqueror && (!jQuery.browser.msie || (jQuery.browser.msie && parseFloat(jQuery.browser.version, 10) >= 10));

    Full.supportedText = "Chrome 10+, Firefox 4+, Safari 5+, Opera 11.64+";

    type = 'full';

    Full.prototype.type = function() {
      return type;
    };

    function Full(element, window, options) {
      this.element = element;
      this.window = window;
      this.options = options != null ? options : {};
      Full.__super__.constructor.apply(this, arguments);
    }

    Full.prototype.build = function() {
      var element, _i, _len, _ref;
      if (jQuery.browser.mozilla && this.content() === '') {
        this.content('&nbsp;');
      }
      this.element.data({
        originalOverflow: this.element.css('overflow')
      });
      this.element.css({
        overflow: 'auto'
      });
      this.specialContainer = jQuery.browser.mozilla && this.element.get(0).tagName !== 'DIV';
      this.element.get(0).contentEditable = true;
      _ref = this.element.find('[data-snippet]');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        element = _ref[_i];
        element.contentEditable = false;
        jQuery(element).attr('data-version', '1');
      }
      if (!this.document.mercuryEditing) {
        this.document.mercuryEditing = true;
        try {
          this.document.execCommand('styleWithCSS', false, false);
          this.document.execCommand('insertBROnReturn', false, true);
          this.document.execCommand('enableInlineTableEditing', false, false);
          return this.document.execCommand('enableObjectResizing', false, false);
        } catch (e) {

        }
      }
    };

    Full.prototype.bindEvents = function() {
      var _this = this;
      Full.__super__.bindEvents.apply(this, arguments);
      Mercury.on('region:update', function() {
        var anchor, currentElement, table;
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        setTimeout((function() {
          return _this.selection().forceSelection(_this.element.get(0));
        }), 1);
        currentElement = _this.currentElement();
        if (currentElement.length) {
          table = currentElement.closest('table', _this.element);
          if (table.length) {
            Mercury.tableEditor(table, currentElement.closest('tr, td'), '<br/>');
          }
          anchor = currentElement.closest('a', _this.element);
          if (anchor.length && anchor.attr('href')) {
            return Mercury.tooltip(anchor, "<a href=\"" + (anchor.attr('href')) + "\" target=\"_blank\">" + (anchor.attr('href')) + "</a>", {
              position: 'below'
            });
          } else {
            return Mercury.tooltip.hide();
          }
        }
      });
      this.element.on('dragenter', function(event) {
        if (_this.previewing) {
          return;
        }
        if (!Mercury.snippet) {
          event.preventDefault();
        }
        return event.originalEvent.dataTransfer.dropEffect = 'copy';
      });
      this.element.on('dragover', function(event) {
        if (_this.previewing) {
          return;
        }
        if (!Mercury.snippet) {
          event.preventDefault();
        }
        event.originalEvent.dataTransfer.dropEffect = 'copy';
        if (jQuery.browser.webkit) {
          clearTimeout(_this.dropTimeout);
          return _this.dropTimeout = setTimeout((function() {
            return _this.element.trigger('possible:drop');
          }), 10);
        }
      });
      this.element.on('drop', function(event) {
        if (_this.previewing) {
          return;
        }
        clearTimeout(_this.dropTimeout);
        _this.dropTimeout = setTimeout((function() {
          return _this.element.trigger('possible:drop');
        }), 1);
        if (!event.originalEvent.dataTransfer.files.length) {
          return;
        }
        event.preventDefault();
        _this.focus();
        return Mercury.uploader(event.originalEvent.dataTransfer.files[0]);
      });
      this.element.on('possible:drop', function() {
        var snippetPlaceHolder;
        if (_this.previewing) {
          return;
        }
        if (snippetPlaceHolder = _this.element.find('img[data-snippet]').get(0)) {
          _this.focus();
          Mercury.Snippet.displayOptionsFor(jQuery(snippetPlaceHolder).data('snippet'), {}, jQuery(snippetPlaceHolder).data('options'));
          return _this.document.execCommand('undo', false, null);
        }
      });
      this.element.on('paste', function(event) {
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        if (_this.specialContainer) {
          event.preventDefault();
          return;
        }
        if (_this.pasting) {
          return;
        }
        Mercury.changes = true;
        return _this.handlePaste(event.originalEvent);
      });
      this.element.on('focus', function() {
        if (_this.previewing) {
          return;
        }
        Mercury.region = _this;
        setTimeout((function() {
          return _this.selection().forceSelection(_this.element.get(0));
        }), 1);
        return Mercury.trigger('region:focused', {
          region: _this
        });
      });
      this.element.on('blur', function() {
        if (_this.previewing) {
          return;
        }
        Mercury.trigger('region:blurred', {
          region: _this
        });
        return Mercury.tooltip.hide();
      });
      this.element.on('click', function(event) {
        if (_this.previewing) {
          return jQuery(event.target).closest('a').attr('target', '_parent');
        }
      });
      this.element.on('dblclick', function(event) {
        var image;
        if (_this.previewing) {
          return;
        }
        image = jQuery(event.target).closest('img', _this.element);
        if (image.length) {
          _this.selection().selectNode(image.get(0), true);
          return Mercury.trigger('button', {
            action: 'insertMedia'
          });
        }
      });
      this.element.on('mouseup', function() {
        if (_this.previewing) {
          return;
        }
        _this.pushHistory();
        return Mercury.trigger('region:update', {
          region: _this
        });
      });
      this.element.on('keydown', function(event) {
        var container;
        if (_this.previewing) {
          return;
        }
        switch (event.keyCode) {
          case 90:
            if (!event.metaKey) {
              return;
            }
            event.preventDefault();
            if (event.shiftKey) {
              _this.execCommand('redo');
            } else {
              _this.execCommand('undo');
            }
            return;
          case 13:
            if (jQuery.browser.webkit && _this.selection().commonAncestor().closest('li, ul, ol', _this.element).length === 0) {
              event.preventDefault();
              _this.document.execCommand('insertParagraph', false, null);
            } else if (_this.specialContainer || jQuery.browser.opera) {
              event.preventDefault();
              _this.document.execCommand('insertHTML', false, '<br/>');
            }
            break;
          case 9:
            event.preventDefault();
            container = _this.selection().commonAncestor();
            if (container.closest('li', _this.element).length) {
              if (!event.shiftKey) {
                _this.execCommand('indent');
              } else if (container.parents('ul, ol').length > 1) {
                _this.execCommand('outdent');
              }
            } else {
              _this.execCommand('insertHTML', {
                value: '&nbsp;&nbsp;'
              });
            }
        }
        if (event.metaKey) {
          switch (event.keyCode) {
            case 66:
              _this.execCommand('bold');
              event.preventDefault();
              break;
            case 73:
              _this.execCommand('italic');
              event.preventDefault();
              break;
            case 85:
              _this.execCommand('underline');
              event.preventDefault();
          }
        }
        return _this.pushHistory(event.keyCode);
      });
      return this.element.on('keyup', function() {
        if (_this.previewing) {
          return;
        }
        Mercury.trigger('region:update', {
          region: _this
        });
        return Mercury.changes = true;
      });
    };

    Full.prototype.focus = function() {
      var _this = this;
      if (Mercury.region !== this) {
        setTimeout((function() {
          return _this.element.focus();
        }), 10);
        try {
          this.selection().selection.collapseToStart();
        } catch (e) {

        }
      } else {
        setTimeout((function() {
          return _this.element.focus();
        }), 10);
      }
      Mercury.trigger('region:focused', {
        region: this
      });
      return Mercury.trigger('region:update', {
        region: this
      });
    };

    Full.prototype.content = function(value, filterSnippets, includeMarker) {
      var container, content, element, index, selection, snippet, version, _i, _j, _len, _len1, _ref, _ref1;
      if (value == null) {
        value = null;
      }
      if (filterSnippets == null) {
        filterSnippets = true;
      }
      if (includeMarker == null) {
        includeMarker = false;
      }
      if (value !== null) {
        container = jQuery('<div>').appendTo(this.document.createDocumentFragment());
        container.html(value);
        _ref = container.find('[data-snippet]');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          element = _ref[_i];
          element.contentEditable = false;
          element = jQuery(element);
          if (snippet = Mercury.Snippet.find(element.data('snippet'))) {
            if (element.data('version')) {
              snippet.setVersion(element.data('version'));
            } else {
              try {
                version = parseInt(element.html().match(/\/(\d+)\]/)[1]);
                if (version) {
                  snippet.setVersion(version);
                  element.attr({
                    'data-version': version
                  });
                  element.html(snippet.data);
                }
              } catch (error) {

              }
            }
          }
        }
        this.element.html(container.html());
        return this.selection().selectMarker(this.element);
      } else {
        this.element.find('meta').remove();
        if (includeMarker) {
          selection = this.selection();
          selection.placeMarker();
        }
        container = jQuery('<div>').appendTo(this.document.createDocumentFragment());
        container.html(this.element.html().replace(/^\s+|\s+$/g, ''));
        if (filterSnippets) {
          _ref1 = container.find('[data-snippet]');
          for (index = _j = 0, _len1 = _ref1.length; _j < _len1; index = ++_j) {
            element = _ref1[index];
            element = jQuery(element);
            if (snippet = Mercury.Snippet.find(element.data("snippet"))) {
              snippet.data = element.html();
            }
            element.html("[" + (element.data("snippet")) + "/" + (element.data("version")) + "]");
            element.attr({
              contenteditable: null,
              'data-version': null
            });
          }
        }
        content = container.html();
        if (includeMarker) {
          selection.removeMarker();
        }
        return content;
      }
    };

    Full.prototype.togglePreview = function() {
      if (this.previewing) {
        this.element.get(0).contentEditable = true;
        this.element.css({
          overflow: 'auto'
        });
      } else {
        this.content(this.content());
        this.element.get(0).contentEditable = false;
        this.element.css({
          overflow: this.element.data('originalOverflow')
        });
        this.element.blur();
      }
      return Full.__super__.togglePreview.apply(this, arguments);
    };

    Full.prototype.execCommand = function(action, options) {
      var handler, sibling;
      if (options == null) {
        options = {};
      }
      Full.__super__.execCommand.apply(this, arguments);
      if (handler = Mercury.config.behaviors[action] || Mercury.Regions.Full.actions[action]) {
        handler.call(this, this.selection(), options);
      } else {
        if (action === 'indent') {
          sibling = this.element.get(0).previousSibling;
        }
        if (action === 'insertHTML' && options.value && options.value.get) {
          options.value = jQuery('<div>').html(options.value).html();
        }
        try {
          this.document.execCommand(action, false, options.value);
        } catch (error) {
          if (action === 'indent' && this.element.prev() !== sibling) {
            this.element.prev().remove();
          }
        }
      }
      return this.element.find('img').one('error', function() {
        return jQuery(this).attr({
          src: '/assets/mercury/missing-image.png',
          title: 'Image not found'
        });
      });
    };

    Full.prototype.pushHistory = function(keyCode) {
      var keyCodes, knownKeyCode, waitTime,
        _this = this;
      keyCodes = [13, 46, 8];
      waitTime = 2.5;
      if (keyCode) {
        knownKeyCode = keyCodes.indexOf(keyCode);
      }
      clearTimeout(this.historyTimeout);
      if (knownKeyCode >= 0 && knownKeyCode !== this.lastKnownKeyCode) {
        this.history.push(this.content(null, false, true));
      } else if (keyCode) {
        this.historyTimeout = setTimeout((function() {
          return _this.history.push(_this.content(null, false, true));
        }), waitTime * 1000);
      } else {
        this.history.push(this.content(null, false, true));
      }
      return this.lastKnownKeyCode = knownKeyCode;
    };

    Full.prototype.selection = function() {
      return new Mercury.Regions.Full.Selection(this.window.getSelection(), this.document);
    };

    Full.prototype.path = function() {
      var container;
      container = this.selection().commonAncestor();
      if (!container) {
        return [];
      }
      if (container.get(0) === this.element.get(0)) {
        return [];
      } else {
        return container.parentsUntil(this.element);
      }
    };

    Full.prototype.currentElement = function() {
      var element, selection;
      element = [];
      selection = this.selection();
      if (selection.range) {
        element = selection.commonAncestor();
        if (element.get(0).nodeType === 3) {
          element = element.parent();
        }
      }
      return element;
    };

    Full.prototype.handlePaste = function(event) {
      var sanitizer, selection,
        _this = this;
      if (Mercury.config.pasting.sanitize === 'text' && event.clipboardData) {
        this.execCommand('insertHTML', {
          value: event.clipboardData.getData('text/plain')
        });
        event.preventDefault();
      } else {
        selection = this.selection();
        selection.placeMarker();
        sanitizer = jQuery('#mercury_sanitizer', this.document).focus();
        return setTimeout(function() {
          var content;
          content = _this.sanitize(sanitizer);
          selection.selectMarker(_this.element);
          selection.removeMarker();
          _this.element.focus();
          return _this.execCommand('insertHTML', {
            value: content
          });
        }, 1);
      }
    };

    Full.prototype.sanitize = function(sanitizer) {
      var allowed, allowedAttributes, allowedTag, attr, content, element, _i, _j, _len, _len1, _ref, _ref1, _ref2, _ref3;
      sanitizer.find("[" + Mercury.config.regions.attribute + "]").remove();
      sanitizer.find('[src*="webkit-fake-url://"]').remove();
      if (Mercury.config.pasting.sanitize) {
        switch (Mercury.config.pasting.sanitize) {
          case 'blacklist':
            sanitizer.find('[style]').removeAttr('style');
            sanitizer.find('[class="Apple-style-span"]').removeClass('Apple-style-span');
            content = sanitizer.html();
            break;
          case 'whitelist':
            _ref = sanitizer.find('*');
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              element = _ref[_i];
              allowed = false;
              _ref1 = Mercury.config.pasting.whitelist;
              for (allowedTag in _ref1) {
                allowedAttributes = _ref1[allowedTag];
                if (element.tagName.toLowerCase() === allowedTag.toLowerCase()) {
                  allowed = true;
                  _ref2 = jQuery(element.attributes);
                  for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
                    attr = _ref2[_j];
                    if (_ref3 = attr.name, __indexOf.call(allowedAttributes, _ref3) < 0) {
                      jQuery(element).removeAttr(attr.name);
                    }
                  }
                  break;
                }
              }
              if (!allowed) {
                jQuery(element).replaceWith(jQuery(element).contents());
              }
            }
            content = sanitizer.html();
            break;
          default:
            content = sanitizer.text();
        }
      } else {
        content = sanitizer.html();
        if (content.indexOf('<!--StartFragment-->') > -1 || content.indexOf('="mso-') > -1 || content.indexOf('<o:') > -1 || content.indexOf('="Mso') > -1) {
          content = sanitizer.text();
        }
      }
      sanitizer.html('');
      return content;
    };

    Full.actions = {
      insertRowBefore: function() {
        return Mercury.tableEditor.addRow('before');
      },
      insertRowAfter: function() {
        return Mercury.tableEditor.addRow('after');
      },
      insertColumnBefore: function() {
        return Mercury.tableEditor.addColumn('before');
      },
      insertColumnAfter: function() {
        return Mercury.tableEditor.addColumn('after');
      },
      deleteColumn: function() {
        return Mercury.tableEditor.removeColumn();
      },
      deleteRow: function() {
        return Mercury.tableEditor.removeRow();
      },
      increaseColspan: function() {
        return Mercury.tableEditor.increaseColspan();
      },
      decreaseColspan: function() {
        return Mercury.tableEditor.decreaseColspan();
      },
      increaseRowspan: function() {
        return Mercury.tableEditor.increaseRowspan();
      },
      decreaseRowspan: function() {
        return Mercury.tableEditor.decreaseRowspan();
      },
      undo: function() {
        return this.content(this.history.undo());
      },
      redo: function() {
        return this.content(this.history.redo());
      },
      horizontalRule: function() {
        return this.execCommand('insertHTML', {
          value: '<hr/>'
        });
      },
      removeFormatting: function(selection) {
        return selection.insertTextNode(selection.textContent());
      },
      backColor: function(selection, options) {
        return selection.wrap("<span style=\"background-color:" + (options.value.toHex()) + "\">", true);
      },
      overline: function(selection) {
        return selection.wrap('<span style="text-decoration:overline">', true);
      },
      style: function(selection, options) {
        return selection.wrap("<span class=\"" + options.value + "\">", true);
      },
      replaceHTML: function(selection, options) {
        return this.content(options.value);
      },
      insertImage: function(selection, options) {
        return this.execCommand('insertHTML', {
          value: jQuery('<img/>', options.value)
        });
      },
      insertTable: function(selection, options) {
        return this.execCommand('insertHTML', {
          value: options.value
        });
      },
      insertLink: function(selection, options) {
        var anchor;
        anchor = jQuery("<" + options.value.tagName + ">", this.document).attr(options.value.attrs).html(options.value.content);
        return selection.insertNode(anchor);
      },
      replaceLink: function(selection, options) {
        var anchor, html;
        anchor = jQuery("<" + options.value.tagName + ">", this.document).attr(options.value.attrs).html(options.value.content);
        selection.selectNode(options.node);
        html = jQuery('<div>').html(selection.content()).find('a').html();
        return selection.replace(jQuery(anchor, selection.context).html(html));
      },
      insertSnippet: function(selection, options) {
        var existing, snippet;
        snippet = options.value;
        if ((existing = this.element.find("[data-snippet=" + snippet.identity + "]")).length) {
          selection.selectNode(existing.get(0));
        }
        return selection.insertNode(snippet.getHTML(this.document));
      },
      editSnippet: function() {
        var snippet;
        if (!this.snippet) {
          return;
        }
        snippet = Mercury.Snippet.find(this.snippet.data('snippet'));
        return snippet.displayOptions();
      },
      removeSnippet: function() {
        if (this.snippet) {
          this.snippet.remove();
        }
        return Mercury.trigger('hide:toolbar', {
          type: 'snippet',
          immediately: true
        });
      }
    };

    return Full;

  })(Mercury.Region);

  Mercury.Regions.Full.Selection = (function() {

    function Selection(selection, context) {
      this.selection = selection;
      this.context = context;
      if (!(this.selection.rangeCount >= 1)) {
        return;
      }
      this.range = this.selection.getRangeAt(0);
      this.fragment = this.range.cloneContents();
      this.clone = this.range.cloneRange();
      this.collapsed = this.selection.isCollapsed;
    }

    Selection.prototype.commonAncestor = function(onlyTag) {
      var ancestor;
      if (onlyTag == null) {
        onlyTag = false;
      }
      if (!this.range) {
        return null;
      }
      ancestor = this.range.commonAncestorContainer;
      if (ancestor.nodeType === 3 && onlyTag) {
        ancestor = ancestor.parentNode;
      }
      return jQuery(ancestor);
    };

    Selection.prototype.wrap = function(element, replace) {
      if (replace == null) {
        replace = false;
      }
      element = jQuery(element, this.context).html(this.fragment);
      if (replace) {
        this.replace(element);
      }
      return element;
    };

    Selection.prototype.textContent = function() {
      return this.content().textContent;
    };

    Selection.prototype.htmlContent = function() {
      var content;
      content = this.content();
      return jQuery('<div>').html(content).html();
      return null;
    };

    Selection.prototype.content = function() {
      return this.range.cloneContents();
    };

    Selection.prototype.is = function(elementType) {
      var content;
      content = this.content();
      if (jQuery(content).length === 1 && jQuery(content.firstChild).is(elementType)) {
        return jQuery(content.firstChild);
      }
      return false;
    };

    Selection.prototype.forceSelection = function(element) {
      var lastChild, range;
      if (!jQuery.browser.webkit) {
        return;
      }
      range = this.context.createRange();
      if (this.range) {
        if (this.commonAncestor(true).closest('[data-snippet]').length) {
          lastChild = this.context.createTextNode("\x00");
          element.appendChild(lastChild);
        }
      } else {
        if (element.lastChild && element.lastChild.nodeType === 3 && element.lastChild.textContent.replace(/^[\s+|\n+]|[\s+|\n+]$/, '') === '') {
          lastChild = element.lastChild;
          element.lastChild.textContent = "\x00";
        } else {
          lastChild = this.context.createTextNode("\x00");
          element.appendChild(lastChild);
        }
      }
      if (lastChild) {
        range.setStartBefore(lastChild);
        range.setEndBefore(lastChild);
        return this.selection.addRange(range);
      }
    };

    Selection.prototype.selectMarker = function(context) {
      var markers, range;
      markers = context.find('em.mercury-marker');
      if (!markers.length) {
        return;
      }
      range = this.context.createRange();
      range.setStartBefore(markers.get(0));
      if (markers.length >= 2) {
        range.setEndBefore(markers.get(1));
      }
      markers.remove();
      this.selection.removeAllRanges();
      return this.selection.addRange(range);
    };

    Selection.prototype.placeMarker = function() {
      var rangeEnd, rangeStart;
      if (!this.range) {
        return;
      }
      this.startMarker = jQuery('<em class="mercury-marker"/>', this.context).get(0);
      this.endMarker = jQuery('<em class="mercury-marker"/>', this.context).get(0);
      rangeEnd = this.range.cloneRange();
      rangeEnd.collapse(false);
      rangeEnd.insertNode(this.endMarker);
      if (!this.range.collapsed) {
        rangeStart = this.range.cloneRange();
        rangeStart.collapse(true);
        rangeStart.insertNode(this.startMarker);
      }
      this.selection.removeAllRanges();
      return this.selection.addRange(this.range);
    };

    Selection.prototype.removeMarker = function() {
      jQuery(this.startMarker).remove();
      return jQuery(this.endMarker).remove();
    };

    Selection.prototype.insertTextNode = function(string) {
      var node;
      node = this.context.createTextNode(string);
      this.range.extractContents();
      this.range.insertNode(node);
      this.range.selectNodeContents(node);
      return this.selection.addRange(this.range);
    };

    Selection.prototype.insertNode = function(element) {
      if (element.get) {
        element = element.get(0);
      }
      if (jQuery.type(element) === 'string') {
        element = jQuery(element, this.context).get(0);
      }
      this.range.deleteContents();
      this.range.insertNode(element);
      this.range.selectNodeContents(element);
      return this.selection.addRange(this.range);
    };

    Selection.prototype.selectNode = function(node, removeExisting) {
      if (removeExisting == null) {
        removeExisting = false;
      }
      this.range.selectNode(node);
      if (removeExisting) {
        this.selection.removeAllRanges();
      }
      return this.selection.addRange(this.range);
    };

    Selection.prototype.replace = function(element, collapse) {
      if (element.get) {
        element = element.get(0);
      }
      if (jQuery.type(element) === 'string') {
        element = jQuery(element, this.context).get(0);
      }
      this.range.deleteContents();
      this.range.insertNode(element);
      this.range.selectNodeContents(element);
      this.selection.addRange(this.range);
      if (collapse) {
        return this.range.collapse(false);
      }
    };

    return Selection;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Mercury.Regions.Image = (function(_super) {
    var type;

    __extends(Image, _super);

    Image.supported = document.getElementById;

    Image.supportedText = "Chrome 10+, Firefox 4+, IE 7+, Safari 5+, Opera 8+";

    type = 'image';

    Image.prototype.type = function() {
      return type;
    };

    function Image(element, window, options) {
      this.element = element;
      this.window = window;
      this.options = options != null ? options : {};
      Image.__super__.constructor.apply(this, arguments);
    }

    Image.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('mode', function(event, options) {
        if (options.mode === 'preview') {
          return _this.togglePreview();
        }
      });
      Mercury.on('focus:frame', function() {
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        return _this.focus();
      });
      Mercury.on('action', function(event, options) {
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        if (options.action) {
          return _this.execCommand(options.action, options);
        }
      });
      this.element.on('dragenter', function(event) {
        if (_this.previewing) {
          return;
        }
        event.preventDefault();
        return event.originalEvent.dataTransfer.dropEffect = 'copy';
      });
      this.element.on('dragover', function(event) {
        if (_this.previewing) {
          return;
        }
        event.preventDefault();
        return event.originalEvent.dataTransfer.dropEffect = 'copy';
      });
      this.element.on('drop', function(event) {
        if (_this.previewing) {
          return;
        }
        if (event.originalEvent.dataTransfer.files.length) {
          event.preventDefault();
          _this.focus();
          return Mercury.uploader(event.originalEvent.dataTransfer.files[0]);
        }
      });
      return this.element.on('focus', function() {
        return _this.focus();
      });
    };

    Image.prototype.togglePreview = function() {
      if (this.previewing) {
        this.previewing = false;
        this.element.attr(Mercury.config.regions.attribute, type);
        return this.build();
      } else {
        this.previewing = true;
        this.element.removeAttr(Mercury.config.regions.attribute);
        return Mercury.trigger('region:blurred', {
          region: this
        });
      }
    };

    Image.prototype.focus = function() {
      if (this.previewing) {
        return;
      }
      Mercury.region = this;
      Mercury.trigger('region:focused', {
        region: this
      });
      return Mercury.trigger('region:update', {
        region: this
      });
    };

    Image.prototype.execCommand = function(action, options) {
      var handler;
      if (options == null) {
        options = {};
      }
      Image.__super__.execCommand.apply(this, arguments);
      if (handler = Mercury.Regions.Image.actions[action]) {
        return handler.call(this, options);
      }
    };

    Image.prototype.pushHistory = function() {
      return this.history.push({
        src: this.element.attr('src')
      });
    };

    Image.prototype.updateSrc = function(src) {
      return this.element.attr('src', src);
    };

    Image.prototype.serialize = function() {
      return {
        type: type,
        data: this.dataAttributes(),
        attributes: {
          src: this.element.attr('src')
        }
      };
    };

    Image.actions = {
      undo: function() {
        var prev;
        if (prev = this.history.undo()) {
          return this.updateSrc(prev.src);
        }
      },
      redo: function() {
        var next;
        if (next = this.history.redo()) {
          return this.updateSrc(next.src);
        }
      },
      insertImage: function(options) {
        return this.updateSrc(options.value.src);
      }
    };

    return Image;

  })(Mercury.Region);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Mercury.Regions.Markdown = (function(_super) {
    var type;

    __extends(Markdown, _super);

    Markdown.supported = document.getElementById;

    Markdown.supportedText = "Chrome 10+, Firefox 4+, IE 7+, Safari 5+, Opera 8+";

    type = 'markdown';

    Markdown.prototype.type = function() {
      return type;
    };

    function Markdown(element, window, options) {
      this.element = element;
      this.window = window;
      this.options = options != null ? options : {};
      Markdown.__super__.constructor.apply(this, arguments);
      this.converter = new Showdown.converter();
    }

    Markdown.prototype.build = function() {
      var height, value, width;
      width = '100%';
      height = this.element.height();
      value = this.element.html().replace(/^\s+|\s+$/g, '').replace('&gt;', '>');
      this.textarea = jQuery('<textarea>', this.document).val(value).addClass('mercury-textarea');
      this.textarea.css({
        border: 0,
        background: 'transparent',
        display: 'block',
        'overflow-y': 'hidden',
        width: width,
        height: height,
        fontFamily: '"Courier New", Courier, monospace'
      });
      this.element.empty().append(this.textarea);
      this.previewElement = jQuery('<div>', this.document);
      this.element.append(this.previewElement);
      this.container = this.element;
      this.container.data('region', this);
      this.element = this.textarea;
      return this.resize();
    };

    Markdown.prototype.dataAttributes = function() {
      var attr, data, _i, _len, _ref;
      data = {};
      _ref = Mercury.config.regions.dataAttributes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attr = _ref[_i];
        data[attr] = this.container.attr('data-' + attr);
      }
      return data;
    };

    Markdown.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('mode', function(event, options) {
        if (options.mode === 'preview') {
          return _this.togglePreview();
        }
      });
      Mercury.on('focus:frame', function() {
        if (!_this.previewing && Mercury.region === _this) {
          return _this.focus();
        }
      });
      Mercury.on('action', function(event, options) {
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        if (options.action) {
          return _this.execCommand(options.action, options);
        }
      });
      Mercury.on('unfocus:regions', function() {
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        _this.element.blur();
        _this.container.removeClass('focus');
        return Mercury.trigger('region:blurred', {
          region: _this
        });
      });
      this.element.on('dragenter', function(event) {
        if (_this.previewing) {
          return;
        }
        event.preventDefault();
        return event.originalEvent.dataTransfer.dropEffect = 'copy';
      });
      this.element.on('dragover', function(event) {
        if (_this.previewing) {
          return;
        }
        event.preventDefault();
        return event.originalEvent.dataTransfer.dropEffect = 'copy';
      });
      this.element.on('drop', function(event) {
        if (_this.previewing) {
          return;
        }
        if (Mercury.snippet) {
          event.preventDefault();
          _this.focus();
          Mercury.Snippet.displayOptionsFor(Mercury.snippet.name, {}, Mercury.snippet.hasOptions);
        }
        if (event.originalEvent.dataTransfer.files.length) {
          event.preventDefault();
          _this.focus();
          return Mercury.uploader(event.originalEvent.dataTransfer.files[0]);
        }
      });
      this.element.on('focus', function() {
        if (_this.previewing) {
          return;
        }
        Mercury.region = _this;
        _this.container.addClass('focus');
        return Mercury.trigger('region:focused', {
          region: _this
        });
      });
      this.element.on('keydown', function(event) {
        var end, lineText, number, selection, start, text;
        if (_this.previewing) {
          return;
        }
        _this.resize();
        switch (event.keyCode) {
          case 90:
            if (!event.metaKey) {
              return;
            }
            event.preventDefault();
            if (event.shiftKey) {
              _this.execCommand('redo');
            } else {
              _this.execCommand('undo');
            }
            return;
          case 13:
            selection = _this.selection();
            text = _this.element.val();
            start = text.lastIndexOf('\n', selection.start);
            end = text.indexOf('\n', selection.end);
            if (end < start) {
              end = text.length;
            }
            if (text[start] === '\n') {
              start = text.lastIndexOf('\n', selection.start - 1);
            }
            if (text[start + 1] === '-') {
              selection.replace('\n- ', false, true);
              event.preventDefault();
            }
            if (/\d/.test(text[start + 1])) {
              lineText = text.substring(start, end);
              if (/(\d+)\./.test(lineText)) {
                number = parseInt(RegExp.$1);
                selection.replace("\n" + (number += 1) + ". ", false, true);
                event.preventDefault();
              }
            }
            break;
          case 9:
            event.preventDefault();
            _this.execCommand('insertHTML', {
              value: '  '
            });
        }
        if (event.metaKey) {
          switch (event.keyCode) {
            case 66:
              _this.execCommand('bold');
              event.preventDefault();
              break;
            case 73:
              _this.execCommand('italic');
              event.preventDefault();
              break;
            case 85:
              _this.execCommand('underline');
              event.preventDefault();
          }
        }
        return _this.pushHistory(event.keyCode);
      });
      this.element.on('keyup', function() {
        if (_this.previewing) {
          return;
        }
        Mercury.changes = true;
        _this.resize();
        return Mercury.trigger('region:update', {
          region: _this
        });
      });
      this.element.on('mouseup', function() {
        if (_this.previewing) {
          return;
        }
        _this.focus();
        return Mercury.trigger('region:focused', {
          region: _this
        });
      });
      return this.previewElement.on('click', function(event) {
        if (_this.previewing) {
          return $(event.target).closest('a').attr('target', '_parent');
        }
      });
    };

    Markdown.prototype.focus = function() {
      return this.element.focus();
    };

    Markdown.prototype.content = function(value, filterSnippets) {
      if (value == null) {
        value = null;
      }
      if (filterSnippets == null) {
        filterSnippets = true;
      }
      if (value !== null) {
        if (jQuery.type(value) === 'string') {
          return this.element.val(value);
        } else {
          this.element.val(value.html);
          return this.selection().select(value.selection.start, value.selection.end);
        }
      } else {
        return this.element.val();
      }
    };

    Markdown.prototype.contentAndSelection = function() {
      return {
        html: this.content(null, false),
        selection: this.selection().serialize()
      };
    };

    Markdown.prototype.togglePreview = function() {
      var value;
      if (this.previewing) {
        this.previewing = false;
        this.container.attr(Mercury.config.regions.attribute, type);
        this.previewElement.hide();
        this.element.show();
        if (Mercury.region === this) {
          return this.focus();
        }
      } else {
        this.previewing = true;
        this.container.removeAttr(Mercury.config.regions.attribute);
        value = this.converter.makeHtml(this.element.val());
        this.previewElement.html(value);
        this.previewElement.show();
        this.element.hide();
        return Mercury.trigger('region:blurred', {
          region: this
        });
      }
    };

    Markdown.prototype.execCommand = function(action, options) {
      var handler;
      if (options == null) {
        options = {};
      }
      Markdown.__super__.execCommand.apply(this, arguments);
      if (handler = Mercury.Regions.Markdown.actions[action]) {
        handler.call(this, this.selection(), options);
      }
      return this.resize();
    };

    Markdown.prototype.pushHistory = function(keyCode) {
      var keyCodes, knownKeyCode, waitTime,
        _this = this;
      keyCodes = [13, 46, 8];
      waitTime = 2.5;
      if (keyCode) {
        knownKeyCode = keyCodes.indexOf(keyCode);
      }
      clearTimeout(this.historyTimeout);
      if (knownKeyCode >= 0 && knownKeyCode !== this.lastKnownKeyCode) {
        this.history.push(this.contentAndSelection());
      } else if (keyCode) {
        this.historyTimeout = setTimeout((function() {
          return _this.history.push(_this.contentAndSelection());
        }), waitTime * 1000);
      } else {
        this.history.push(this.contentAndSelection());
      }
      return this.lastKnownKeyCode = knownKeyCode;
    };

    Markdown.prototype.selection = function() {
      return new Mercury.Regions.Markdown.Selection(this.element);
    };

    Markdown.prototype.resize = function() {
      this.element.css({
        height: this.element.get(0).scrollHeight - 100
      });
      return this.element.css({
        height: this.element.get(0).scrollHeight
      });
    };

    Markdown.prototype.snippets = function() {};

    Markdown.actions = {
      undo: function() {
        return this.content(this.history.undo());
      },
      redo: function() {
        return this.content(this.history.redo());
      },
      insertHTML: function(selection, options) {
        var element;
        if (options.value.get && (element = options.value.get(0))) {
          options.value = jQuery('<div>').html(element).html();
        }
        return selection.replace(options.value, false, true);
      },
      insertImage: function(selection, options) {
        return selection.replace('![add alt text](' + encodeURI(options.value.src) + ')', true);
      },
      insertTable: function(selection, options) {
        return selection.replace(options.value.replace(/<br>|<br\/>/ig, ''), false, true);
      },
      insertLink: function(selection, options) {
        return selection.replace("[" + options.value.content + "](" + options.value.attrs.href + " 'optional title')", true);
      },
      insertUnorderedList: function(selection) {
        return selection.addList('unordered');
      },
      insertOrderedList: function(selection) {
        return selection.addList('ordered');
      },
      style: function(selection, options) {
        return selection.wrap("<span class=\"" + options.value + "\">", '</span>');
      },
      formatblock: function(selection, options) {
        var wrapper, wrapperName, wrappers;
        wrappers = {
          h1: ['# ', ' #'],
          h2: ['## ', ' ##'],
          h3: ['### ', ' ###'],
          h4: ['#### ', ' ####'],
          h5: ['##### ', ' #####'],
          h6: ['###### ', ' ######'],
          pre: ['    ', ''],
          blockquote: ['> ', ''],
          p: ['\n', '\n']
        };
        for (wrapperName in wrappers) {
          wrapper = wrappers[wrapperName];
          selection.unWrapLine("" + wrapper[0], "" + wrapper[1]);
        }
        if (options.value === 'blockquote') {
          Mercury.Regions.Markdown.actions.indent.call(this, selection, options);
          return;
        }
        return selection.wrapLine("" + wrappers[options.value][0], "" + wrappers[options.value][1]);
      },
      bold: function(selection) {
        return selection.wrap('**', '**');
      },
      italic: function(selection) {
        return selection.wrap('_', '_');
      },
      subscript: function(selection) {
        return selection.wrap('<sub>', '</sub>');
      },
      superscript: function(selection) {
        return selection.wrap('<sup>', '</sup>');
      },
      indent: function(selection) {
        return selection.wrapLine('> ', '', false, true);
      },
      outdent: function(selection) {
        return selection.unWrapLine('> ', '', false, true);
      },
      horizontalRule: function(selection) {
        return selection.replace('\n- - -\n');
      },
      insertSnippet: function(selection, options) {
        var snippet;
        snippet = options.value;
        return selection.replace(snippet.getText());
      }
    };

    return Markdown;

  })(Mercury.Region);

  Mercury.Regions.Markdown.Selection = (function() {

    function Selection(element) {
      this.element = element;
      this.el = this.element.get(0);
      this.getDetails();
    }

    Selection.prototype.serialize = function() {
      return {
        start: this.start,
        end: this.end
      };
    };

    Selection.prototype.getDetails = function() {
      this.length = this.el.selectionEnd - this.el.selectionStart;
      this.start = this.el.selectionStart;
      this.end = this.el.selectionEnd;
      return this.text = this.element.val().substr(this.start, this.length);
    };

    Selection.prototype.replace = function(text, select, placeCursor) {
      var changed, savedVal, val;
      if (select == null) {
        select = false;
      }
      if (placeCursor == null) {
        placeCursor = false;
      }
      this.getDetails();
      val = this.element.val();
      savedVal = this.element.val();
      this.element.val(val.substr(0, this.start) + text + val.substr(this.end, val.length));
      changed = this.element.val() !== savedVal;
      if (select) {
        this.select(this.start, this.start + text.length);
      }
      if (placeCursor) {
        this.select(this.start + text.length, this.start + text.length);
      }
      return changed;
    };

    Selection.prototype.select = function(start, end) {
      this.start = start;
      this.end = end;
      this.element.focus();
      this.el.selectionStart = this.start;
      this.el.selectionEnd = this.end;
      return this.getDetails();
    };

    Selection.prototype.wrap = function(left, right) {
      this.getDetails();
      this.deselectNewLines();
      this.replace(left + this.text + right, this.text !== '');
      if (this.text === '') {
        return this.select(this.start + left.length, this.start + left.length);
      }
    };

    Selection.prototype.wrapLine = function(left, right, selectAfter, reselect) {
      var end, savedSelection, start, text;
      if (selectAfter == null) {
        selectAfter = true;
      }
      if (reselect == null) {
        reselect = false;
      }
      this.getDetails();
      savedSelection = this.serialize();
      text = this.element.val();
      start = text.lastIndexOf('\n', this.start);
      end = text.indexOf('\n', this.end);
      if (end < start) {
        end = text.length;
      }
      if (text[start] === '\n') {
        start = text.lastIndexOf('\n', this.start - 1);
      }
      this.select(start + 1, end);
      this.replace(left + this.text + right, selectAfter);
      if (reselect) {
        return this.select(savedSelection.start + left.length, savedSelection.end + left.length);
      }
    };

    Selection.prototype.unWrapLine = function(left, right, selectAfter, reselect) {
      var changed, end, leftRegExp, rightRegExp, savedSelection, start, text;
      if (selectAfter == null) {
        selectAfter = true;
      }
      if (reselect == null) {
        reselect = false;
      }
      this.getDetails();
      savedSelection = this.serialize();
      text = this.element.val();
      start = text.lastIndexOf('\n', this.start);
      end = text.indexOf('\n', this.end);
      if (end < start) {
        end = text.length;
      }
      if (text[start] === '\n') {
        start = text.lastIndexOf('\n', this.start - 1);
      }
      this.select(start + 1, end);
      window.something = this.text;
      leftRegExp = new RegExp("^" + (left.regExpEscape()));
      rightRegExp = new RegExp("" + (right.regExpEscape()) + "$");
      changed = this.replace(this.text.replace(leftRegExp, '').replace(rightRegExp, ''), selectAfter);
      if (reselect && changed) {
        return this.select(savedSelection.start - left.length, savedSelection.end - left.length);
      }
    };

    Selection.prototype.addList = function(type) {
      var end, index, line, lines, start, text;
      text = this.element.val();
      start = text.lastIndexOf('\n', this.start);
      end = text.indexOf('\n', this.end);
      if (end < start) {
        end = text.length;
      }
      if (text[start] === '\n') {
        start = text.lastIndexOf('\n', this.start - 1);
      }
      this.select(start + 1, end);
      lines = this.text.split('\n');
      if (type === 'unordered') {
        return this.replace("- " + lines.join("\n- "), true);
      } else {
        return this.replace(((function() {
          var _i, _len, _results;
          _results = [];
          for (index = _i = 0, _len = lines.length; _i < _len; index = ++_i) {
            line = lines[index];
            _results.push("" + (index + 1) + ". " + line);
          }
          return _results;
        })()).join('\n'), true);
      }
    };

    Selection.prototype.deselectNewLines = function() {
      var length, text;
      text = this.text;
      length = text.replace(/\n+$/g, '').length;
      return this.select(this.start, this.start + length);
    };

    Selection.prototype.placeMarker = function() {
      return this.wrap('[mercury-marker]', '[mercury-marker]');
    };

    Selection.prototype.removeMarker = function() {
      var end, start, val;
      val = this.element.val();
      start = val.indexOf('[mercury-marker]');
      if (!(start > -1)) {
        return;
      }
      end = val.indexOf('[mercury-marker]', start + 1) - '[mercury-marker]'.length;
      this.element.val(this.element.val().replace(/\[mercury-marker\]/g, ''));
      return this.select(start, end);
    };

    Selection.prototype.textContent = function() {
      return this.text;
    };

    return Selection;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Mercury.Regions.Simple = (function(_super) {
    var type;

    __extends(Simple, _super);

    Simple.supported = document.getElementById;

    Simple.supportedText = "Chrome 10+, Firefox 4+, IE 7+, Safari 5+, Opera 8+";

    type = 'simple';

    Simple.prototype.type = function() {
      return type;
    };

    function Simple(element, window, options) {
      this.element = element;
      this.window = window;
      this.options = options != null ? options : {};
      Mercury.log("building " + type, this.element, this.options);
      Simple.__super__.constructor.apply(this, arguments);
    }

    Simple.prototype.build = function() {
      var height, value, width;
      if (this.element.css('display') === 'block') {
        width = '100%';
        height = this.element.height();
      } else {
        width = this.element.width();
        height = this.element.height();
      }
      value = this.element.text();
      this.textarea = jQuery('<textarea>', this.document).val(value).addClass('mercury-textarea');
      this.textarea.css({
        border: 0,
        background: 'transparent',
        'overflow-y': 'hidden',
        width: width,
        height: height,
        fontFamily: 'inherit',
        fontSize: 'inherit',
        fontWeight: 'inherit',
        fontStyle: 'inherit',
        color: 'inherit',
        'min-height': 0,
        padding: '0',
        margin: 0,
        'border-radius': 0,
        display: 'inherit',
        lineHeight: 'inherit',
        textAlign: 'inherit'
      });
      this.element.empty().append(this.textarea);
      this.container = this.element;
      this.container.data('region', this);
      this.element = this.textarea;
      return this.resize();
    };

    Simple.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('mode', function(event, options) {
        if (options.mode === 'preview') {
          return _this.togglePreview();
        }
      });
      Mercury.on('focus:frame', function() {
        if (!_this.previewing && Mercury.region === _this) {
          return _this.focus();
        }
      });
      Mercury.on('action', function(event, options) {
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        if (options.action) {
          return _this.execCommand(options.action, options);
        }
      });
      Mercury.on('unfocus:regions', function() {
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        _this.element.blur();
        _this.container.removeClass('focus');
        return Mercury.trigger('region:blurred', {
          region: _this
        });
      });
      return this.bindElementEvents();
    };

    Simple.prototype.bindElementEvents = function() {
      var _this = this;
      this.element.on('focus', function() {
        if (_this.previewing) {
          return;
        }
        Mercury.region = _this;
        _this.container.addClass('focus');
        return Mercury.trigger('region:focused', {
          region: _this
        });
      });
      this.element.on('keydown', function(event) {
        var end, lineText, number, selection, start, text;
        if (_this.previewing) {
          return;
        }
        _this.resize();
        switch (event.keyCode) {
          case 90:
            if (!event.metaKey) {
              return;
            }
            event.preventDefault();
            if (event.shiftKey) {
              _this.execCommand('redo');
            } else {
              _this.execCommand('undo');
            }
            return;
          case 13:
            selection = _this.selection();
            text = _this.element.val();
            start = text.lastIndexOf('\n', selection.start);
            end = text.indexOf('\n', selection.end);
            if (end < start) {
              end = text.length;
            }
            if (text[start] === '\n') {
              start = text.lastIndexOf('\n', selection.start - 1);
            }
            if (text[start + 1] === '-') {
              selection.replace('\n- ', false, true);
            }
            if (/\d/.test(text[start + 1])) {
              lineText = text.substring(start, end);
              if (/(\d+)\./.test(lineText)) {
                number = parseInt(RegExp.$1);
                selection.replace("\n" + (number += 1) + ". ", false, true);
              }
            }
            event.preventDefault();
            break;
          case 9:
            event.preventDefault();
            _this.execCommand('insertHTML', {
              value: '  '
            });
        }
        return _this.pushHistory(event.keyCode);
      });
      this.element.on('keyup', function() {
        if (_this.previewing) {
          return;
        }
        Mercury.changes = true;
        _this.resize();
        return Mercury.trigger('region:update', {
          region: _this
        });
      });
      this.element.on('mouseup', function() {
        if (_this.previewing) {
          return;
        }
        _this.focus();
        return Mercury.trigger('region:focused', {
          region: _this
        });
      });
      return this.element.on('paste', function(event) {
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        if (_this.specialContainer) {
          event.preventDefault();
          return;
        }
        if (_this.pasting) {
          return;
        }
        Mercury.changes = true;
        return _this.handlePaste(event.originalEvent);
      });
    };

    Simple.prototype.handlePaste = function(event) {
      this.execCommand('insertHTML', {
        value: event.clipboardData.getData('text/plain').replace(/\n/g, ' ')
      });
      event.preventDefault();
    };

    Simple.prototype.path = function() {
      return [this.container.get(0)];
    };

    Simple.prototype.focus = function() {
      return this.element.focus();
    };

    Simple.prototype.content = function(value, filterSnippets) {
      if (value == null) {
        value = null;
      }
      if (filterSnippets == null) {
        filterSnippets = true;
      }
      if (value !== null) {
        if (jQuery.type(value) === 'string') {
          return this.element.val(value);
        } else {
          this.element.val(value.html);
          return this.selection().select(value.selection.start, value.selection.end);
        }
      } else {
        return this.element.val();
      }
    };

    Simple.prototype.contentAndSelection = function() {
      return {
        html: this.content(null, false),
        selection: this.selection().serialize()
      };
    };

    Simple.prototype.togglePreview = function() {
      var value;
      if (this.previewing) {
        this.previewing = false;
        this.element = this.container;
        this.container.attr(Mercury.config.regions.attribute, type);
        this.build();
        this.bindElementEvents();
        if (Mercury.region === this) {
          return this.focus();
        }
      } else {
        this.previewing = true;
        value = jQuery('<div></div>').text(this.element.val()).html();
        this.container.removeAttr(Mercury.config.regions.attribute);
        this.container.html(value);
        return Mercury.trigger('region:blurred', {
          region: this
        });
      }
    };

    Simple.prototype.execCommand = function(action, options) {
      var handler;
      if (options == null) {
        options = {};
      }
      Simple.__super__.execCommand.apply(this, arguments);
      if (handler = Mercury.Regions.Simple.actions[action]) {
        handler.call(this, this.selection(), options);
      }
      return this.resize();
    };

    Simple.prototype.pushHistory = function(keyCode) {
      var keyCodes, knownKeyCode, waitTime,
        _this = this;
      keyCodes = [13, 46, 8];
      waitTime = 2.5;
      if (keyCode) {
        knownKeyCode = keyCodes.indexOf(keyCode);
      }
      clearTimeout(this.historyTimeout);
      if (knownKeyCode >= 0 && knownKeyCode !== this.lastKnownKeyCode) {
        this.history.push(this.contentAndSelection());
      } else if (keyCode) {
        this.historyTimeout = setTimeout((function() {
          return _this.history.push(_this.contentAndSelection());
        }), waitTime * 1000);
      } else {
        this.history.push(this.contentAndSelection());
      }
      return this.lastKnownKeyCode = knownKeyCode;
    };

    Simple.prototype.selection = function() {
      return new Mercury.Regions.Simple.Selection(this.element);
    };

    Simple.prototype.resize = function() {
      this.element.css({
        height: this.element.get(0).scrollHeight - 100
      });
      return this.element.css({
        height: this.element.get(0).scrollHeight
      });
    };

    Simple.prototype.snippets = function() {};

    Simple.actions = {
      undo: function() {
        return this.content(this.history.undo());
      },
      redo: function() {
        return this.content(this.history.redo());
      },
      insertHTML: function(selection, options) {
        var element;
        if (options.value.get && (element = options.value.get(0))) {
          options.value = jQuery('<div>').html(element).html();
        }
        return selection.replace(options.value, false, true);
      }
    };

    return Simple;

  })(Mercury.Region);

  Mercury.Regions.Simple.Selection = (function() {

    function Selection(element) {
      this.element = element;
      this.el = this.element.get(0);
      this.getDetails();
    }

    Selection.prototype.serialize = function() {
      return {
        start: this.start,
        end: this.end
      };
    };

    Selection.prototype.getDetails = function() {
      this.length = this.el.selectionEnd - this.el.selectionStart;
      this.start = this.el.selectionStart;
      this.end = this.el.selectionEnd;
      return this.text = this.element.val().substr(this.start, this.length);
    };

    Selection.prototype.replace = function(text, select, placeCursor) {
      var changed, savedVal, val;
      if (select == null) {
        select = false;
      }
      if (placeCursor == null) {
        placeCursor = false;
      }
      this.getDetails();
      val = this.element.val();
      savedVal = this.element.val();
      this.element.val(val.substr(0, this.start) + text + val.substr(this.end, val.length));
      changed = this.element.val() !== savedVal;
      if (select) {
        this.select(this.start, this.start + text.length);
      }
      if (placeCursor) {
        this.select(this.start + text.length, this.start + text.length);
      }
      return changed;
    };

    Selection.prototype.select = function(start, end) {
      this.start = start;
      this.end = end;
      this.element.focus();
      this.el.selectionStart = this.start;
      this.el.selectionEnd = this.end;
      return this.getDetails();
    };

    Selection.prototype.wrap = function(left, right) {
      this.getDetails();
      this.deselectNewLines();
      this.replace(left + this.text + right, this.text !== '');
      if (this.text === '') {
        return this.select(this.start + left.length, this.start + left.length);
      }
    };

    Selection.prototype.deselectNewLines = function() {
      var length, text;
      text = this.text;
      length = text.replace(/\n+$/g, '').length;
      return this.select(this.start, this.start + length);
    };

    Selection.prototype.placeMarker = function() {
      return this.wrap('[mercury-marker]', '[mercury-marker]');
    };

    Selection.prototype.removeMarker = function() {
      var end, start, val;
      val = this.element.val();
      start = val.indexOf('[mercury-marker]');
      if (!(start > -1)) {
        return;
      }
      end = val.indexOf('[mercury-marker]', start + 1) - '[mercury-marker]'.length;
      this.element.val(this.element.val().replace(/\[mercury-marker\]/g, ''));
      return this.select(start, end);
    };

    Selection.prototype.textContent = function() {
      return this.text;
    };

    return Selection;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Mercury.Regions.Snippets = (function(_super) {
    var type;

    __extends(Snippets, _super);

    Snippets.supported = document.getElementById;

    Snippets.supportedText = "Chrome 10+, Firefox 4+, IE 7+, Safari 5+, Opera 8+";

    type = 'snippets';

    Snippets.prototype.type = function() {
      return type;
    };

    function Snippets(element, window, options) {
      this.element = element;
      this.window = window;
      this.options = options != null ? options : {};
      Mercury.log("building " + type, this.element, this.options);
      Snippets.__super__.constructor.apply(this, arguments);
      this.makeSortable();
    }

    Snippets.prototype.build = function() {
      var snippet, _i, _len, _ref;
      _ref = this.element.find('[data-snippet]');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        snippet = _ref[_i];
        jQuery(snippet).attr('data-version', 0);
      }
      if (this.element.css('minHeight') === '0px') {
        return this.element.css({
          minHeight: 20
        });
      }
    };

    Snippets.prototype.bindEvents = function() {
      var _this = this;
      Snippets.__super__.bindEvents.apply(this, arguments);
      Mercury.on('unfocus:regions', function(event) {
        if (_this.previewing) {
          return;
        }
        if (Mercury.region === _this) {
          _this.element.removeClass('focus');
          _this.element.sortable('destroy');
          return Mercury.trigger('region:blurred', {
            region: _this
          });
        }
      });
      Mercury.on('focus:window', function(event) {
        if (_this.previewing) {
          return;
        }
        if (Mercury.region === _this) {
          _this.element.removeClass('focus');
          _this.element.sortable('destroy');
          return Mercury.trigger('region:blurred', {
            region: _this
          });
        }
      });
      this.element.on('mouseup', function() {
        if (_this.previewing) {
          return;
        }
        _this.focus();
        return Mercury.trigger('region:focused', {
          region: _this
        });
      });
      this.element.on('dragover', function(event) {
        if (_this.previewing) {
          return;
        }
        event.preventDefault();
        return event.originalEvent.dataTransfer.dropEffect = 'copy';
      });
      this.element.on('drop', function(event) {
        if (_this.previewing || !Mercury.snippet) {
          return;
        }
        _this.focus();
        event.preventDefault();
        return Mercury.Snippet.displayOptionsFor(Mercury.snippet.name, {}, Mercury.snippet.hasOptions);
      });
      jQuery(this.document).on('keydown', function(event) {
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        switch (event.keyCode) {
          case 90:
            if (!event.metaKey) {
              return;
            }
            event.preventDefault();
            if (event.shiftKey) {
              return _this.execCommand('redo');
            } else {
              return _this.execCommand('undo');
            }
        }
      });
      return jQuery(this.document).on('keyup', function() {
        if (_this.previewing || Mercury.region !== _this) {
          return;
        }
        return Mercury.changes = true;
      });
    };

    Snippets.prototype.focus = function() {
      Mercury.region = this;
      this.makeSortable();
      return this.element.addClass('focus');
    };

    Snippets.prototype.togglePreview = function() {
      if (this.previewing) {
        this.makeSortable();
      } else {
        this.element.sortable('destroy');
        this.element.removeClass('focus');
      }
      return Snippets.__super__.togglePreview.apply(this, arguments);
    };

    Snippets.prototype.execCommand = function(action, options) {
      var handler;
      if (options == null) {
        options = {};
      }
      Snippets.__super__.execCommand.apply(this, arguments);
      if (handler = Mercury.Regions.Snippets.actions[action]) {
        return handler.call(this, options);
      }
    };

    Snippets.prototype.makeSortable = function() {
      var _this = this;
      return this.element.sortable('destroy').sortable({
        document: this.document,
        scroll: false,
        containment: 'parent',
        items: '[data-snippet]',
        opacity: 0.4,
        revert: 100,
        tolerance: 'pointer',
        beforeStop: function() {
          Mercury.trigger('hide:toolbar', {
            type: 'snippet',
            immediately: true
          });
          return true;
        },
        stop: function() {
          setTimeout((function() {
            return _this.pushHistory();
          }), 100);
          return true;
        }
      });
    };

    Snippets.actions = {
      undo: function() {
        return this.content(this.history.undo());
      },
      redo: function() {
        return this.content(this.history.redo());
      },
      insertSnippet: function(options) {
        var existing, snippet,
          _this = this;
        snippet = options.value;
        if ((existing = this.element.find("[data-snippet=" + snippet.identity + "]")).length) {
          return existing.replaceWith(snippet.getHTML(this.document, function() {
            return _this.pushHistory();
          }));
        } else {
          return this.element.append(snippet.getHTML(this.document, function() {
            return _this.pushHistory();
          }));
        }
      },
      editSnippet: function() {
        var snippet;
        if (!this.snippet) {
          return;
        }
        snippet = Mercury.Snippet.find(this.snippet.data('snippet'));
        return snippet.displayOptions();
      },
      removeSnippet: function() {
        if (this.snippet) {
          this.snippet.remove();
        }
        return Mercury.trigger('hide:toolbar', {
          type: 'snippet',
          immediately: true
        });
      }
    };

    return Snippets;

  })(Mercury.Region);

}).call(this);
(function() {

  this.Mercury.dialogHandlers.backColor = function() {
    var _this = this;
    return this.element.find('.picker, .last-picked').on('click', function(event) {
      var color;
      color = jQuery(event.target).css('background-color');
      _this.element.find('.last-picked').css({
        background: color
      });
      _this.button.css({
        backgroundColor: color
      });
      return Mercury.trigger('action', {
        action: 'backColor',
        value: color
      });
    });
  };

}).call(this);
(function() {

  this.Mercury.dialogHandlers.foreColor = function() {
    var _this = this;
    return this.element.find('.picker, .last-picked').on('click', function(event) {
      var color;
      color = jQuery(event.target).css('background-color').toHex();
      _this.element.find('.last-picked').css({
        background: color
      });
      _this.button.css({
        backgroundColor: color
      });
      return Mercury.trigger('action', {
        action: 'foreColor',
        value: color
      });
    });
  };

}).call(this);
(function() {

  this.Mercury.dialogHandlers.formatblock = function() {
    var _this = this;
    return this.element.find('[data-tag]').on('click', function(event) {
      var tag;
      tag = jQuery(event.target).data('tag');
      return Mercury.trigger('action', {
        action: 'formatblock',
        value: tag
      });
    });
  };

}).call(this);
(function() {

  this.Mercury.dialogHandlers.snippetPanel = function() {
    var _this = this;
    this.element.find('input.filter').on('keyup', function() {
      var snippet, value, _i, _len, _ref, _results;
      value = _this.element.find('input.filter').val();
      _ref = _this.element.find('li[data-filter]');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        snippet = _ref[_i];
        if (LiquidMetal.score(jQuery(snippet).data('filter'), value) === 0) {
          _results.push(jQuery(snippet).hide());
        } else {
          _results.push(jQuery(snippet).show());
        }
      }
      return _results;
    });
    return this.element.find('img[data-snippet]').on('dragstart', function() {
      return Mercury.snippet = {
        name: jQuery(this).data('snippet'),
        hasOptions: !(jQuery(this).data('options') === false)
      };
    });
  };

}).call(this);
(function() {

  this.Mercury.dialogHandlers.style = function() {
    var _this = this;
    return this.element.find('[data-class]').on('click', function(event) {
      var className;
      className = jQuery(event.target).data('class');
      return Mercury.trigger('action', {
        action: 'style',
        value: className
      });
    });
  };

}).call(this);
(function() {

  this.Mercury.modalHandlers.htmlEditor = function() {
    var content,
      _this = this;
    content = Mercury.region.content(null, true, false);
    this.element.find('textarea').val(content);
    return this.element.find('form').on('submit', function(event) {
      var value;
      event.preventDefault();
      value = _this.element.find('textarea').val();
      Mercury.trigger('action', {
        action: 'replaceHTML',
        value: value
      });
      return _this.hide();
    });
  };

}).call(this);
(function() {

  this.Mercury.modalHandlers.insertCharacter = function() {
    var _this = this;
    return this.element.find('.character').on('click', function(event) {
      Mercury.trigger('action', {
        action: 'insertHTML',
        value: "&" + (jQuery(event.target).attr('data-entity')) + ";"
      });
      return _this.hide();
    });
  };

}).call(this);
(function() {

  this.Mercury.modalHandlers.insertLink = {
    initialize: function() {
      var _this = this;
      this.editing = false;
      this.content = null;
      this.element.find('.control-label input').on('click', this.onLabelChecked);
      this.element.find('.controls .optional, .controls .required').on('focus', this.onInputFocused);
      this.element.find('#link_target').on('change', function() {
        return _this.onChangeTarget();
      });
      this.initializeForm();
      return this.element.find('form').on('submit', function(event) {
        event.preventDefault();
        _this.validateForm();
        if (!_this.valid) {
          _this.resize();
          return;
        }
        _this.submitForm();
        return _this.hide();
      });
    },
    initializeForm: function() {
      var a, bookmarkSelect, href, img, newBookmarkInput, selection;
      this.fillExistingBookmarks();
      if (!(Mercury.region && Mercury.region.selection)) {
        return;
      }
      selection = Mercury.region.selection();
      if (selection.textContent) {
        this.element.find('#link_text').val(selection.textContent());
      }
      if (selection && selection.commonAncestor) {
        a = selection.commonAncestor(true).closest('a');
      }
      if (selection.htmlContent) {
        img = /<img/.test(selection.htmlContent());
      }
      if (!(img || a && a.length)) {
        return false;
      }
      this.element.find('#link_text_container').hide();
      if (img) {
        this.content = selection.htmlContent();
      }
      if (!(a && a.length)) {
        return false;
      }
      this.editing = a;
      if (a.attr('href') && a.attr('href').indexOf('#') === 0) {
        bookmarkSelect = this.element.find('#link_existing_bookmark');
        bookmarkSelect.val(a.attr('href').replace(/[^#]*#/, ''));
        bookmarkSelect.closest('.control-group').find('input[type=radio]').prop('checked', true);
      } else {
        this.element.find('#link_external_url').val(a.attr('href'));
      }
      if (a.attr('name')) {
        newBookmarkInput = this.element.find('#link_new_bookmark');
        newBookmarkInput.val(a.attr('name'));
        newBookmarkInput.closest('.control-group').find('input[type=radio]').prop('checked', true);
      }
      if (a.attr('target')) {
        this.element.find('#link_target').val(a.attr('target'));
      }
      if (a.attr('href') && a.attr('href').indexOf('javascript:void') === 0) {
        href = a.attr('href');
        this.element.find('#link_external_url').val(href.match(/window.open\('([^']+)',/)[1]);
        this.element.find('#link_target').val('popup');
        this.element.find('#link_popup_width').val(href.match(/width=(\d+),/)[1]);
        this.element.find('#link_popup_height').val(href.match(/height=(\d+),/)[1]);
        return this.element.find('#popup_options').show();
      }
    },
    fillExistingBookmarks: function() {
      var bookmarkSelect, tag, _i, _len, _ref, _results;
      bookmarkSelect = this.element.find('#link_existing_bookmark');
      _ref = jQuery('a[name]', window.mercuryInstance.document);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tag = _ref[_i];
        _results.push(bookmarkSelect.append(jQuery('<option>', {
          value: jQuery(tag).attr('name')
        }).text(jQuery(tag).text())));
      }
      return _results;
    },
    onLabelChecked: function() {
      var forInput;
      forInput = jQuery(this).closest('.control-label').attr('for');
      return jQuery(this).closest('.control-group').find("#" + forInput).focus();
    },
    onInputFocused: function() {
      return jQuery(this).closest('.control-group').find('input[type=radio]').prop('checked', true);
    },
    onChangeTarget: function() {
      this.element.find(".link-target-options").hide();
      this.element.find("#" + (this.element.find('#link_target').val()) + "_options").show();
      return this.resize(true);
    },
    addInputError: function(input, message) {
      input.after('<span class="help-inline error-message">' + Mercury.I18n(message) + '</span>').closest('.control-group').addClass('error');
      return this.valid = false;
    },
    clearInputErrors: function() {
      this.element.find('.control-group.error').removeClass('error').find('.error-message').remove();
      return this.valid = true;
    },
    validateForm: function() {
      var el, type;
      this.clearInputErrors();
      type = this.element.find('input[name=link_type]:checked').val();
      el = this.element.find("#link_" + type);
      if (!el.val()) {
        this.addInputError(el, "can't be blank");
      }
      if (!this.editing && !this.content) {
        el = this.element.find('#link_text');
        if (!el.val()) {
          return this.addInputError(el, "can't be blank");
        }
      }
    },
    submitForm: function() {
      var args, attrs, content, target, type, value;
      content = this.element.find('#link_text').val();
      target = this.element.find('#link_target').val();
      type = this.element.find('input[name=link_type]:checked').val();
      switch (type) {
        case 'existing_bookmark':
          attrs = {
            href: "#" + (this.element.find('#link_existing_bookmark').val())
          };
          break;
        case 'new_bookmark':
          attrs = {
            name: "" + (this.element.find('#link_new_bookmark').val())
          };
          break;
        default:
          attrs = {
            href: this.element.find("#link_" + type).val()
          };
      }
      switch (target) {
        case 'popup':
          args = {
            width: parseInt(this.element.find('#link_popup_width').val()) || 500,
            height: parseInt(this.element.find('#link_popup_height').val()) || 500,
            menubar: 'no',
            toolbar: 'no'
          };
          attrs['href'] = "javascript:void(window.open('" + attrs['href'] + "', 'popup_window', '" + (jQuery.param(args).replace(/&/g, ',')) + "'))";
          break;
        default:
          if (target) {
            attrs['target'] = target;
          }
      }
      value = {
        tagName: 'a',
        attrs: attrs,
        content: this.content || content
      };
      if (this.editing) {
        return Mercury.trigger('action', {
          action: 'replaceLink',
          value: value,
          node: this.editing.get(0)
        });
      } else {
        return Mercury.trigger('action', {
          action: 'insertLink',
          value: value
        });
      }
    }
  };

}).call(this);
(function() {

  this.Mercury.modalHandlers.insertMedia = {
    initialize: function() {
      var _this = this;
      this.element.find('.control-label input').on('click', this.onLabelChecked);
      this.element.find('.controls .optional, .controls .required').on('focus', function(event) {
        return _this.onInputFocused($(event.target));
      });
      this.focus('#media_image_url');
      this.initializeForm();
      return this.element.find('form').on('submit', function(event) {
        event.preventDefault();
        _this.validateForm();
        if (!_this.valid) {
          _this.resize();
          return;
        }
        _this.submitForm();
        return _this.hide();
      });
    },
    initializeForm: function() {
      var iframe, image, selection, src;
      if (!(Mercury.region && Mercury.region.selection)) {
        return;
      }
      selection = Mercury.region.selection();
      if (image = typeof selection.is === "function" ? selection.is('img') : void 0) {
        this.element.find('#media_image_url').val(image.attr('src'));
        this.element.find('#media_image_alignment').val(image.attr('align'));
        this.element.find('#media_image_float').val(image.attr('style') != null ? image.css('float') : '');
        this.focus('#media_image_url');
      }
      if (iframe = typeof selection.is === "function" ? selection.is('iframe') : void 0) {
        src = iframe.attr('src');
        if (/^https?:\/\/www.youtube.com\//i.test(src)) {
          this.element.find('#media_youtube_url').val("" + (src.match(/^https?/)[0]) + "://youtu.be/" + (src.match(/\/embed\/(\w+)/)[1]));
          this.element.find('#media_youtube_width').val(iframe.width());
          this.element.find('#media_youtube_height').val(iframe.height());
          return this.focus('#media_youtube_url');
        } else if (/^https?:\/\/player.vimeo.com\//i.test(src)) {
          this.element.find('#media_vimeo_url').val("" + (src.match(/^https?/)[0]) + "://vimeo.com/" + (src.match(/\/video\/(\w+)/)[1]));
          this.element.find('#media_vimeo_width').val(iframe.width());
          this.element.find('#media_vimeo_height').val(iframe.height());
          return this.focus('#media_vimeo_url');
        }
      }
    },
    focus: function(selector) {
      var _this = this;
      return setTimeout((function() {
        return _this.element.find(selector).focus();
      }), 300);
    },
    onLabelChecked: function() {
      var forInput;
      forInput = jQuery(this).closest('.control-label').attr('for');
      return jQuery(this).closest('.control-group').find("#" + forInput).focus();
    },
    onInputFocused: function(input) {
      input.closest('.control-group').find('input[type=radio]').prop('checked', true);
      if (input.closest('.media-options').length) {
        return;
      }
      this.element.find(".media-options").hide();
      this.element.find("#" + (input.attr('id').replace('media_', '')) + "_options").show();
      return this.resize(true);
    },
    addInputError: function(input, message) {
      input.after('<span class="help-inline error-message">' + Mercury.I18n(message) + '</span>').closest('.control-group').addClass('error');
      return this.valid = false;
    },
    clearInputErrors: function() {
      this.element.find('.control-group.error').removeClass('error').find('.error-message').remove();
      return this.valid = true;
    },
    validateForm: function() {
      var el, type, url;
      this.clearInputErrors();
      type = this.element.find('input[name=media_type]:checked').val();
      el = this.element.find("#media_" + type);
      switch (type) {
        case 'youtube_url':
          url = this.element.find('#media_youtube_url').val();
          if (!/^https?:\/\/youtu.be\//.test(url)) {
            return this.addInputError(el, "is invalid");
          }
          break;
        case 'vimeo_url':
          url = this.element.find('#media_vimeo_url').val();
          if (!/^https?:\/\/vimeo.com\//.test(url)) {
            return this.addInputError(el, "is invalid");
          }
          break;
        default:
          if (!el.val()) {
            return this.addInputError(el, "can't be blank");
          }
      }
    },
    submitForm: function() {
      var alignment, attrs, code, float, protocol, type, url, value;
      type = this.element.find('input[name=media_type]:checked').val();
      switch (type) {
        case 'image_url':
          attrs = {
            src: this.element.find('#media_image_url').val()
          };
          if (alignment = this.element.find('#media_image_alignment').val()) {
            attrs['align'] = alignment;
          }
          if (float = this.element.find('#media_image_float').val()) {
            attrs['style'] = 'float: ' + float + ';';
          }
          return Mercury.trigger('action', {
            action: 'insertImage',
            value: attrs
          });
        case 'youtube_url':
          url = this.element.find('#media_youtube_url').val();
          code = url.replace(/https?:\/\/youtu.be\//, '');
          protocol = 'http';
          if (/^https:/.test(url)) {
            protocol = 'https';
          }
          value = jQuery('<iframe>', {
            width: parseInt(this.element.find('#media_youtube_width').val(), 10) || 560,
            height: parseInt(this.element.find('#media_youtube_height').val(), 10) || 349,
            src: "" + protocol + "://www.youtube.com/embed/" + code + "?wmode=transparent",
            frameborder: 0,
            allowfullscreen: 'true'
          });
          return Mercury.trigger('action', {
            action: 'insertHTML',
            value: value
          });
        case 'vimeo_url':
          url = this.element.find('#media_vimeo_url').val();
          code = url.replace(/^https?:\/\/vimeo.com\//, '');
          protocol = 'http';
          if (/^https:/.test(url)) {
            protocol = 'https';
          }
          value = jQuery('<iframe>', {
            width: parseInt(this.element.find('#media_vimeo_width').val(), 10) || 400,
            height: parseInt(this.element.find('#media_vimeo_height').val(), 10) || 225,
            src: "" + protocol + "://player.vimeo.com/video/" + code + "?title=1&byline=1&portrait=0&color=ffffff",
            frameborder: 0
          });
          return Mercury.trigger('action', {
            action: 'insertHTML',
            value: value
          });
      }
    }
  };

}).call(this);
(function() {

  this.Mercury.modalHandlers.insertSnippet = function() {
    var _this = this;
    return this.element.find('form').on('submit', function(event) {
      var serializedForm, snippet;
      event.preventDefault();
      serializedForm = _this.element.find('form').serializeObject();
      if (Mercury.snippet) {
        snippet = Mercury.snippet;
        snippet.setOptions(serializedForm);
        Mercury.snippet = null;
      } else {
        snippet = Mercury.Snippet.create(_this.options.snippetName, serializedForm);
      }
      Mercury.trigger('action', {
        action: 'insertSnippet',
        value: snippet
      });
      return _this.hide();
    });
  };

}).call(this);
(function() {

  this.Mercury.modalHandlers.insertTable = {
    initialize: function() {
      var _this = this;
      this.table = this.element.find('#table_display table');
      this.table.on('click', function(event) {
        return _this.onCellClick($(event.target));
      });
      this.element.find('#table_alignment').on('change', function() {
        return _this.setTableAlignment();
      });
      this.element.find('#table_border').on('keyup', function() {
        return _this.setTableBorder();
      });
      this.element.find('#table_spacing').on('keyup', function() {
        return _this.setTableCellSpacing();
      });
      this.element.find('[data-action]').on('click', function(event) {
        event.preventDefault();
        return _this.onActionClick(jQuery(event.target).data('action'));
      });
      this.selectFirstCell();
      return this.element.find('form').on('submit', function(event) {
        event.preventDefault();
        _this.submitForm();
        return _this.hide();
      });
    },
    selectFirstCell: function() {
      var firstCell;
      firstCell = this.table.find('td, th').first();
      firstCell.addClass('selected');
      return Mercury.tableEditor(this.table, firstCell, '&nbsp;');
    },
    onCellClick: function(cell) {
      this.cell = cell;
      this.table = this.cell.closest('table');
      this.table.find('.selected').removeAttr('class');
      this.cell.addClass('selected');
      return Mercury.tableEditor(this.table, this.cell, '&nbsp;');
    },
    onActionClick: function(action) {
      if (!action) {
        return;
      }
      return Mercury.tableEditor[action]();
    },
    setTableAlignment: function() {
      return this.table.attr({
        align: this.element.find('#table_alignment').val()
      });
    },
    setTableBorder: function() {
      var border;
      border = parseInt(this.element.find('#table_border').val(), 10);
      if (isNaN(border)) {
        return this.table.removeAttr('border');
      } else {
        return this.table.attr({
          border: border
        });
      }
    },
    setTableCellSpacing: function() {
      var cellspacing;
      cellspacing = parseInt(this.element.find('#table_spacing').val(), 10);
      if (isNaN(cellspacing)) {
        return this.table.removeAttr('cellspacing');
      } else {
        return this.table.attr({
          cellspacing: cellspacing
        });
      }
    },
    submitForm: function() {
      var html, value;
      this.table.find('.selected').removeAttr('class');
      this.table.find('td, th').html('<br/>');
      html = jQuery('<div>').html(this.table).html();
      value = html.replace(/^\s+|\n/gm, '').replace(/(<\/.*?>|<table.*?>|<tbody>|<tr>)/g, '$1\n');
      return Mercury.trigger('action', {
        action: 'insertTable',
        value: value
      });
    }
  };

}).call(this);
(function() {

  if (Mercury.onload) {
    Mercury.onload();
  }

  jQuery(window).trigger('mercury:loaded');

}).call(this);
