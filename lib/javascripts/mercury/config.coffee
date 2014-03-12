###!
Mercury Editor is a Coffeescript and jQuery based WYSIWYG editor released under the MIT License.
Documentation and other useful information can be found at https://github.com/jejacks0n/mercury

Copyright (c) 2013 Jeremy Jackson
###
@Mercury ||= {}

Mercury.configuration =

  # Logging
  # You can enable logging for debugging purposes. Notifications are always displayed as they represent potential
  # problems, and console.error will be used unless it's unavailable. In those cases an alert or error will be thrown
  # based on what notifier you choose to use. Use false if you don't care about fallbacks.
  #
  logging:
    enabled    : false
    notifier   : 'console'                                 # error, console, or alert


  # Localization
  # Mercury comes with translation files (contributed by the community) for several languages. To add a translation you
  # must first require the locale(s) you want to have support for, enable, and set a preferred locale (to an included
  # locale.)
  #
  #= require mercury/locales/swedish_chef
  #
  localization:
    enabled    : false
    preferred  : 'swedish_chef-BORK'                       # preferred locale - if the client locale isn't supported


  # Uploading
  # When enabled you can drag and drop images/files onto some regions and the file(s) will be uploaded. It's expected
  # that the server respond with JSON containing a url. How the file is inserting into the region it was dropped on is
  # determined by the region itself and some regions may not allow all file types specified here.
  #
  uploading:
    enabled    : true
    saveUrl    : '/mercury/uploads'                        # save url
    saveName   : 'file'                                    # param that will be set for the image data
    mimeTypes  : ['image/jpeg', 'image/gif', 'image/png']  # allowed file types (false allows everything)
    maxSize    : 5242880                                   # max size - 5.00 Mb


  # Saving
  # Saving uses the Page model and can be dependent on the server API. These options are merged with the ajax options
  # when saved, which allows configuring the ajax request per page. You can provide a custom Page.prototype.save method,
  # or ou can adjust this configuration by using Mercury.config('saving:url', '/path/for/this/page').
  #
  saving:
    enabled    : true
    url        : '/mercury/save'                           # save url
    method     : 'POST'                                    # save method - can be POST or PUT
    contentType: 'application/json'                        # content type - set to null to use standard form submission


  # Templates
  # By default Mercury provides all templates as JST templates that are loaded statically, however to provide more
  # flexibility if a template isn't found locally, a synchronous ajax request will be made to the server to fetch the
  # content of that template. The server is expected to respond with HTML.
  #
  templates:
    enabled    : true
    prefixUrl  : '/mercury/templates'                      # ajax path prefix for fallback JST templates


  # Interface
  # Mercury will instantiate an interface on Mercury.init(). This configration allows you to specify which interface to
  # use, as well as the various user interface classes to instantiate, which provides a modular way to add to, or
  # override default functionality and interface elements. Other properties can be configured here as well.
  #
  interface:
    enabled    : true                                      # initial visible state - trigger 'interface:show' to show
    class      : 'BaseInterface'                           # interface class - used on Mercury.init()
    toolbar    : 'Toolbar'                                 # toolbar class to use within the interface
    statusbar  : 'Statusbar'                               # statusbar class to use within the interface
    uploader   : 'Uploader'                                # uploader class to use within the interface
    silent     : false                                     # set to true to disable asking about changes when leaving
    shadowed   : false                                     # puts the interface into a shadow dom when it's available
    maskable   : false                                     # uses a mask over the document for toolbar dialogs
    style      : false                                     # interface style - 'small', 'flat' or 'small flat'
    floating   : false                                     # floats to the focused region
    floatWidth : false                                     # fixed width for floating interface (pixel value - eg. 520)
    floatDrag  : true                                      # allow dragging the floating interface manually
    nohijack   : ['mercury-ignored']                       # classnames of anchors/forms that shouldn't be hijacked


  # Toolbars
  # You can configure which toolbars and buttons are available here. Provide the title, and options. The name is used
  # for icons and when triggering action events, unless the options specify otherwise. Most regions provide their own
  # toolbars, or additional buttons to existing toolbars.
  #
  # Button Options:
  #   title: string
  #   icon: string
  #   action: an action button (default)
  #   event: the provided event name will be triggered when clicked.
  #   mode: a toggle button, which will trigger a mode event with the value.
  #   global: boolean indicating the button applies globally, and not regions.
  #   button: the custom button class to use when instantiating the button.
  #   plugin: expects a plugin with the given name to respond to button click.
  #   settings: configuration to be passed to the plugin.
  #
  # For more information about button options or adding your own functionality check todo: wiki url here
  #
  toolbars:

    # The primary toolbar is always built and visible (it's required). Buttons may become disabled when a region that
    # doesn't support a given action is focused, and some buttons like save, preview, snippet, will always be active as
    # they apply to the entire page and are not specific to the focused region.
    #
    primary:
      save     : ['Save', title: 'Save this page', event: 'save', global: true]
      preview  : ['Preview', title: 'Preview this page', mode: 'preview', global: true]
      sep1     : ' '
      undo     : ['Undo', title: 'Undo your last action']
      redo     : ['Redo', title: 'Redo your last action']
      sep2     : '-'
      link     : ['Link', title: 'Insert Link', plugin: 'link']
      file     : ['Media', title: 'Insert Media and Files (images, videos, etc.)', plugin: 'media']
      table    : ['Table', title: 'Insert Table', plugin: 'table']
      character: ['Character', title: 'Special Characters', plugin: 'character']
      snippets : ['Snippets', title: 'Snippet Panel', plugin: 'snippets']
      sep3     : ' '
      history  : ['History', title: 'Page Version History', plugin: 'history']
      notes    : ['Notes', title: 'Page Notes', plugin: 'notes']


  # Regions
  # Mercury looks for elements that have a data-mercury="type" attribute. This attribute is used to declare what type of
  # region a given element should be. When saving, each region is serialized with a name and data that it might want to
  # pass back to the server, and the identifier attribute is used as a unique name.
  #
  regions:
    attribute  : 'data-mercury'                            # data attribute used to declare the region type
    options    : 'data-region-options'                     # data attribute used for options for the region (JSON)
    identifier : 'id'                                      # attribute used for name when serializing

    # The gallery region is provided an an example of how you can easily (generally speaking) create your own regions.
    # It allows drag/drop of images and provides a simple implementation of a slide show with the ability to remove
    # items. You can use this as an example of how you could embed an entire backbone app within a region.
    #
    #= require mercury/regions/gallery
    #
    gallery:
      mimeTypes: ['image/jpeg']                            # file types - overrides general uploading configuration

    # The HTML region is a full HTML5 Content Editable region -- a true WYSIWYG experience. Effort has been made to
    # normalize, and keep things consistent, but the nature of it is complex and should be treated as such. There's an
    # expectation that users who are exposed to this region understand HTML.
    #
    #= require dependencies/rangy/rangy-core
    #= require dependencies/rangy/rangy-serializer
    #= require dependencies/rangy/rangy-cssclassapplier
    #= require mercury/regions/html
    #
    html:
      mimeTypes: false                                     # file types - overrides general uploading to allow anything

    # The image region is typically an image tag and what's sent back to the server on serialization is the source of
    # that image. It allows draging/dropping images onto itself, and maintains a history so you can undo/redo your
    # changes. Also allows setting image alignment.
    #
    #= require mercury/regions/gallery
    #
    image:
      mimeTypes: ['image/jpeg']                            # file types - overrides general uploading configuration

    # Markdown provides an easy way to provide some markup abilities without the exposing the ability to edit complex
    # HTML. Use the markdown sent to the server on save to render the content when not editing, and render the markdown
    # when editing. Some options are for the converter - more here: https://github.com/chjj/marked
    #
    #= require dependencies/marked-0.2.8
    #= require mercury/regions/markdown
    #
    markdown:
      autoSize : true                                      # the region will auto-resize to the content within it
      mimeTypes: false                                     # file types - overrides general uploading to allow anything
      wrapping : true                                      # enables/disables soft line wrapping
      sanitize : false                                     # sanitize the output - ignore any html that has been input
      breaks   : true                                      # enable line breaks - new lines will become line breaks

    # The Plain region is a simplified single line HTML5 Content Editable region. It restricts drag/drop, can restrict
    # paste and line feeds and only provides the ability to do some common actions like bold, italics, and underline.
    # This is a useful region for headings and other single line areas.
    #
    #= require dependencies/rangy/rangy-core
    #= require dependencies/rangy/rangy-serializer
    #= require dependencies/rangy/rangy-cssclassapplier
    #= require mercury/regions/html
    #
    plain:
      allowActs: true                                      # allow the common actions (bold/italic/underline)
      pasting  : true                                      # allow pasting -- always sanitized to text
      newlines : false                                     # allow line feeds (on enter and paste)

    # The Text region is a multiline plain text input. This region can be used to collect only text in cases when you
    # don't want to allow more complex HTML. It's up to you to render <br> tags when displaying the content within the
    # page.
    #
    #= require mercury/regions/text
    #
    text:
      autoSize : true                                      # the region will auto-resize to the content within it
      wrapping : true                                      # enables/disables soft line wrapping
