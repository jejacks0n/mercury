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
    enabled    : true
    notifier   : 'console'                                 # console, alert, or error (default is error)


  # Localization
  # Mercury comes with translation files (contributed by the community) for several languages. To add a translation you
  # must first require the locale(s) you want to have support for, enable, and set a preferred locale (to an included
  # locale.)
  #
  #= require mercury/locales/swedish_chef
  #
  localization:
    enabled    : true
    preferred  : 'en-US'                                   # preferred locale - if the user locale isn't supported


  # Uploading
  # When enabled you can drag and drop images/files onto a given region and that file will be uploaded. It's expected
  # that the server respond with JSON containing a url. How the file is inserting into the region it was dropped on is
  # determined by the region itself and some regions may not allow all file types.
  #
  uploading:
    enabled    : true
    saveUrl    : '/mercury/uploads'                        # save url
    saveName   : 'file'                                    # param that will be set for the image data
    mimeTypes  : ['image/jpeg', 'image/gif', 'image/png']  # allowed file types (false allows everything)
    maxSize    : 5242880                                   # max size - 5.00 Mb


  # Templates
  # By default Mercury provides all templates as JST templates that are loaded statically, however to provide more
  # flexibility if a template isn't found locally, an synchronous ajax request will be made to the server to fetch the
  # content.
  #
  templates:
    enabled    : true
    prefixUrl  : '/mercury/templates'                      # ajax path prefix for fallback JST templates.


  # Interface
  # Mercury will instantiate an editor on Mercury.init(). This configration allows you to specify which editor to use
  # as well as the various user interface classes to instantiate from within the editor which provides a modular way to
  # add to, or override Mercury functionality and it's interface elements.
  #
  interface:
    hidden     : true                                     # initial visible state -- trigger 'interface:show' to show
    editor     : 'FrameEditor'                             # editor to use on Mercury.init() - 'Editor', 'FrameEditor'
    toolbar    : 'Toolbar'                                 # toolbar class to use within the editor
    statusbar  : 'Statusbar'                               # statusbar class to use within the editor


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
      mimeTypes : ['image/jpeg']                           # file types - overrides general uploading configuration.

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
      mimeTypes : false                                    # file types - overrides general uploading to allow anything.

    # The image region is typically an image tag and what's sent back to the server on serialization is the source of
    # that image. It allows draging/dropping images onto itself, and maintains a history so you can undo/redo your
    # changes.
    #
    #= require mercury/regions/gallery
    #
    image:
      mimeTypes : ['image/jpeg']                           # file types - overrides general uploading configuration.

    # Markdown provides an easy way to provide some markup abilities without the exposing the ability to edit complex
    # HTML, and is useful for people who don't fully understand HTML. Use the markdown sent to the server on save to
    # render the content when not editing, and render the markdown when editing.
    #
    #= require dependencies/showdown-1.0
    #= require mercury/regions/markdown
    #
    markdown:
      autoSize  : true                                     # the region will auto-resize to the content within it.
      mimeTypes : false                                    # file types - overrides general uploading to allow anything.

    # The Plain region is a simplified single line HTML5 Content Editable region. It restricts paste, drag/drop, and
    # only provides the ability to do some common actions like bold, italics, and underline. This is a useful region for
    # headings and other single line areas.
    #
    #= require dependencies/rangy/rangy-core
    #= require dependencies/rangy/rangy-serializer
    #= require dependencies/rangy/rangy-cssclassapplier
    #= require mercury/regions/html
    #
    plain:
      actions   : true                                     # allow the common actions (bold/italics/underline)

    # The Text region is a multiline plain text input. This region can be used to collect only text in cases when you
    # don't want to allow more complex HTML. It's up to you to render <br> tags when displaying the content within the
    # page.
    #
    #= require mercury/regions/text
    #
    text:
      autoSize  : true                                     # the region will auto-resize to the content within it.
      stripTags : true                                     # strip html when saving/previewing (keeps it only text).
