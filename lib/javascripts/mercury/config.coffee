@Mercury ||= {}

Mercury.configuration =

  # Logging
  # You can enable logging for debugging purposes.
  #
  logging: true


  # Localization
  # Mercury comes with translation files (contributed by the community) for several languages. To add a translation you
  # must first require the locale(s) you want to have support for, enable, and set a preferred locale (to an included
  # locale.)
  #
  localization:
    enabled    : true
    preferred  : 'en-US'                                   # preferred locale - if the user locale isn't supported


  # Uploading
  # When enabled you can drag and drop images/files onto a given region and that file will be uploaded. How the file
  # upload is handled and inserted is up to the region that it was dropped on.
  #
  uploading:
    enabled    : true
    saveUrl    : '/mercury/images'                         # save url
    saveName   : 'image'                                   # param that will be set for the image data
    mimeTypes  : ['image/jpeg', 'image/gif', 'image/png']  # allowed file types
    maxSize    : 5242880                                   # max size - 5.00 Mb

