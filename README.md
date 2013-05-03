Mercury Editor 2
================

Mercury Editor is a web based WYSIWYG editor, and takes a different approach than any editor out there. It provides a full framework in which you can more easily create complex regions and interfaces. In Mercury Editor, regions dictate it's toolbars, buttons, and context for highlighting buttons. This simplifies the configuration, and provides more flexibility in terms of defining your own custom functionality that doesn't fit into the standard Mercury Editor features.

Mercury Editor also provides a comprehensive plugin architecture. Plugins makes additional functionality easier to write, test, and maintain -- and allows a more consistent way to provide it to others.


## Developer Notice

This branch represents the future version of Mercury Editor. This iteration of Mercury Editor (Mercury2) separates the Rails portions from the Javascript portions of the project. Rails is still used for development (for a server, coffeescript, sass, build process etc.) but the Rails Engine has been moved to [mercury-rails](https://github.com/jejacks0n/mercury-rails) -- this enables more functionality, and to serve as an example of how to implement functionality like snippets and image uploading/resizing. If you're interested in integrating Mercury2 with your own platform, this is the best place to start.


## Examples

There's [several examples](https://github.com/jejacks0n/mercury/tree/mercury2/examples) of how to integrate more complex features directly in the project, and the [gallery region](https://github.com/jejacks0n/mercury/blob/mercury2/lib/javascripts/mercury/regions/gallery.coffee) is a good place to start reading if you're planning on writing custom regions. There's an example for how to [sandbox using an iframe](https://github.com/jejacks0n/mercury/blob/mercury2/examples/frame.haml) and for more complex integrations check the [developer interface example](https://github.com/jejacks0n/mercury/blob/mercury2/examples/assets/developer_interface.coffee) which outlines many of the events and API, and if you're planning on adding functionality there's some examples of [how to add your own toolbars and actions, or write simple plugins](https://github.com/jejacks0n/mercury/blob/mercury2/examples/assets/adding_functionality.coffee).

An example of server integration is available in the [mercury-rails](https://github.com/jejacks0n/mercury-rails) project, which outlines all of the features that are needed by the server to fully work with the default regions.


## Sandboxing & The Shadow Dom

Mercury2 allows sandboxing content within an iframe or it can load directly on the page you're editing. This has been a complication in the past, so this version simplifies that while also retaining the ability to sandbox itself to mimimize conflicts with javascript libraries and css.

The iframe support has also been simplified and expects that you pass an iframe (or selector) when initializing using the FrameInterface. This allows you to determine what url is loaded, and simplifies the save process.

Mercury2 also now has support for moving it's interface into a [Shadow DOM](http://glazkov.com/2011/01/14/what-the-heck-is-shadow-dom), which removes the interface from the dom on the page that you're editing, which helps to alleviate conflicts on the page with other javascript and css, but isn't as reliable as using an iframe nor as widely supported.


## Fonts & Graphics

Mercury2 uses two custom fonts for all graphic elements in the interface. This allows for retina support, makes it easier to package, and allows you to modify it for your own needs.

The primary toolbar icons and general interface elements are in mercury.ttf, which is generated using the awesome [IcoMoon project](http://icomoon.io/app/) (by [Keyamoon](https://twitter.com/keyamoon)). You can upload/import the mercury.dev.svg file that can be found in the project and add new icons for your custom buttons. If you're making a plugin you probably want to bundle these separately.

The toolbar icons (bold, italics, etc.) are in toolbars.ttf, and was built using [fontstruct.com](http://fontstruct.com/). [The original font](http://fontstruct.com/fontstructions/show/797530) can be cloned and edited as needed. Fontstruct is used here because it allows for small pixel fonts but also allows for more advanced shape that scale nicely.


## I18n / Translations

Mercury has support for the following locales.  If you'd like to contribute one, the easiest way is to fork the project, create a locale file with your translation, and submit a pull request -- that way you get full credit for your contributions.

Translations and contributors:
- Arabic ([mohamagdy](https://github.com/mohamagdy))
- Danish ([martinjlowm](https://github.com/martinjlowm))
- German ([poke](https://github.com/poke))
- Spanish ([javiercr](https://github.com/javiercr))
- French ([adamantx](https://github.com/adamantx))
- Italian ([gcastagneti](https://github.com/gcastagnet) / [eymengunay](https://github.com/eymengunay))
- Korean ([dorajistyle](https://github.com/dorajistyle))
- Dutch ([kieranklaassen](https://github.com/kieranklaassen))
- Polish ([cintrzyk](https://github.com/cintrzyk))
- Portuguese ([yakko](https://github.com/yakko))
- Swedish ([stefanm](https://github.com/stefanm))
- Simplified Chinese ([董劭田 DONG Shaotian](https://github.com/richarddong))
- Hungarian ([egivandor](https://github.com/egivandor))
- Russian ([ilyacherevkov](https://github.com/ilyacherevkov))


## Dependencies

Mercury2 was built using jQuery 1.9.1/2.0, but attempts to minimize reliance on jQuery as much as is feasible. Selections in HTML regions are handled using Rangy. Each region can also have it's own dependencies, which is entirely up to the author. If you're writing a custom region it's expected to document the dependencies and version information. You can also check the [full list of dependencies](https://github.com/jejacks0n/mercury/blob/mercury2/lib/javascripts/mercury/dependencies.coffee).


## Contributing

Awesome! Please [check here](https://github.com/jejacks0n/mercury/blob/mercury2/CONTRIBUTING.md).


## Known issues

### Webkit

- Dropping files at the cursor position doesn't work.

### Gecko

- Dropping files doesn't display cursor position, and thus dropping at that place isn't applicable.


## Consulting

I'm available for hire. If you need help implementing, enhancing, or integrating Mercury Editor this might be a worth while option. I don't always have time for freelance work, so I recommend [Mode Set](http://modeset.com), a small consultancy with amazing folks where I work -- many of the developers there are familiar with Mercury, and it's easier for me to dedicate my days to your issues rather than my evenings.


## License

Licensed under the [MIT License](http://opensource.org/licenses/mit-license.php)

Copyright 2012 [Jeremy Jackson](https://github.com/jejacks0n)


## Enjoy =)
