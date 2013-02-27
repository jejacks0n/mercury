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
    notifier   : 'error'                                   # alert or throw an error - 'alert', 'error', or false.


  # Localization
  # Mercury comes with translation files (contributed by the community) for several languages. To add a translation you
  # must first require the locale(s) you want to have support for, enable, and set a preferred locale (to an included
  # locale.)
  #
  localization:
    enabled    : true
    preferred  : 'en-US'                                   # preferred locale - if the user locale isn't supported


  # Uploading
  # When enabled you can drag and drop images/files onto a given region and that file will be uploaded. It's expected
  # that the server respond with JSON containing a url. How the file is inserting into the region it was dropped on is
  # determined by the region itself.
  #
  uploading:
    enabled    : true
    saveUrl    : '/mercury/uploads'                        # save url
    saveName   : 'file'                                    # param that will be set for the image data
    mimeTypes  : ['image/jpeg', 'image/gif', 'image/png']  # allowed file types
    maxSize    : 5242880                                   # max size - 5.00 Mb

