Mercury Editor2
===============

Mercury2 is a WYSIWYG editor, and takes a different approach than any editor out there. It was a great html editor that had additional functionality, but it's become more. Mercury2 has the same features as it's predecessor, but is more structured, and provides a full framework in which you can more easily create complex regions that are anything you want.

Regions dictate toolbars, buttons, and what actions they support. This simplifies the configuration for toolbars, but also provides more flexibility in terms of defining your own custom functionality that doesn't fit into the standard Mercury features. Check out the gallery region for an example of this.

Mercury2 allows sandboxing content within an iframe or it can load directly on the page you're editing. This has been a complication in the past, so this version simplifies that while also retaining the ability to sandbox itself to mimimize conflicts with javascript libraries and css. It also supports moving it's interface into a [Shadow DOM](http://glazkov.com/2011/01/14/what-the-heck-is-shadow-dom), which removes the interface from the dom on the page that you're editing, which helps to alleviate conflicts on the page with other javascript and css, but isn't as reliable as using an iframe.


## Developer Notice

This branch represents the future version of Mercury Editor. This iteration of Mercury Editor (Mercury2) separates the Rails portions from the Javascript portions of the project. Rails is still used for development (for a server, coffeescript, sass, build process etc.) but the Rails Engine has been moved to [mercury-rails] -- this enables more functionality, and to serve as an example of how to implement functionality like snippets and image uploading. If you're interested in integrating Mercury with your own platform, this is the best place to start.


## Fonts & Graphics

Mercury uses two custom fonts for all graphic elements in the interface. This allows for retina support, makes it easier to package, and allows you to modify it for your own needs.

The primary toolbar icons and general interface elements are in mercury.ttf, which is generated using the awesome [IcoMoon project](http://icomoon.io/app/) (by [Keyamoon](https://twitter.com/keyamoon)). You can upload/import the mercury.dev.svg file that can be found in the project and add new icons for your custom buttons. If you're making a plugin you probably want to bundle these separately.

The toolbar icons (bold, italics, etc.) are in toolbars.ttf, and was built using [fontstruct.com](http://fontstruct.com/). [The original font](http://fontstruct.com/fontstructions/show/797530) can be cloned and edited as needed. Fontstruct is used here because it allows for small pixel fonts but also allows for more advanced shape that scale nicely.


## Internationalization / Translations

Mercury has support for the following locales.  If you'd like to contribute one, the easiest way is to fork the project, create a locale file with your translation, and submit a pull request -- that way you get full credit for your contributions.

Translations and contributors:
- Arabic ([mohamagdy](https://github.com/mohamagdy))
- Danish ([martinjlowm](https://github.com/martinjlowm))
- German ([poke](https://github.com/poke))
- Spanish ([javiercr](https://github.com/javiercr))
- French ([adamantx](https://github.com/adamantx))
- Italian ([gcastagneti](https://github.com/gcastagnet))
- Korean ([dorajistyle](https://github.com/dorajistyle))
- Dutch ([kieranklaassen](https://github.com/kieranklaassen))
- Polish ([cintrzyk](https://github.com/cintrzyk))
- Portuguese ([yakko](https://github.com/yakko))
- Swedish ([stefanm](https://github.com/stefanm))
- Simplified Chinese ([董劭田 DONG Shaotian](https://github.com/richarddong))
- Hungarian ([egivandor](https://github.com/egivandor))
- Russian ([ilyacherevkov](https://github.com/ilyacherevkov))


## Dependencies

This version of Mercury is being built using jQuery 2.0, but attempts to minimize reliance on jQuery as much as is feasible, and near the end there may be a pass to remove things like $.extend. Selections in HTML regions are handled using Rangy. Each region can also have it's own dependencies, which is entirely up to the author. If you're writing a custom region it's expected to document the dependencies and version information. Check `lib/javascripts/mercury/dependencies.coffee` for a full list of dependencies.


## Development

Clone using git
```shell
git clone https://github.com/jejacks0n/mercury
git checkout mercury2
```

Install required gems
```shell
bundle install
```

Run specs / build distro on passing specs
```shell
bundle exec rake
```

Run specs with coverage reports
```shell
bundle exec teabag --coverage
```

### Contributing

Fork the project, follow the steps above (modifying the repo to reflect your own). Write code+specs, make sure tests pass, push, and submit a pull request.


## Notes Area (will be moved to wiki later)

### Custom Actions

If I wanted to add the ability to change the direction of text in a markdown region I could do something like this:

```html
<div id="markdown1" data-mercury="markdown" data-region-options='{"allowDirection": true}'>
```

```coffeescript
Mercury.MarkdownRegion.addAction 'direction', ->
  return alert("This region doesn't allow switching text direction") unless @allowDirection
  @direction = if @direction == 'rtl' then 'ltr' else 'rtl'
  @el.css(direction: @direction)
```

Now if that region has focus we can trigger the action like this:

```coffeescript
Mercury.trigger('action', 'direction')
```

### Known issues

#### Webkit

- Dropping files at the cursor position doesn't work.

#### Gecko

- Dropping files doesn't display cursor position, and thus dropping at that place isn't applicable.


## Consulting

I'm available for hire. If you need help implementing, enhancing, or integrating Mercury Editor this might be a worth while option. I don't always have time for freelance work, so I recommend [Mode Set](http://modeset.com), a small consultancy with amazing folks where I work -- many of the developers there are familiar with Mercury, and it's easier for me to dedicate my days to your issues rather than my evenings.


## License

Licensed under the [MIT License](http://opensource.org/licenses/mit-license.php)

Copyright 2012 [Jeremy Jackson](https://github.com/jejacks0n)


## Enjoy =)
