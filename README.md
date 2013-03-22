Mercury Editor2
===============

## Developer Notice

This branch represents the future version of Mercury Editor. This iteration of Mercury Editor (Mercury2) will separate the Rails portions from the Javascript portions of the project. Rails is still used for development (for a server, coffeescript, sass, build process etc.) but the Rails Engine will be broken off into a different project so that more functionality can be added, and to serve as an example of how to implement functionality like snippets and image uploading.

Mercury2 takes a considerably different approach in terms of it's architecture and featureset. It was a great html editor before that had some additional functionality, but it's become more. Mercury2 has the same features as it's predecessor, but is more structured, and provides a framework in which you can more easily create complex regions that are anything you want.

Regions dictate toolbars, buttons, and what actions they support. This simplifies the configuration for toolbars, but also provides more flexibility in terms of defining your own custom functionality that doesn't fit into Mercury directly. Check out the gallery region for an example of this.

Mercury2 also allows sandboxing content within an iframe or it can load directly on the page you're editing. This has been a point of contention and complication in the past, so this version simplifies that while also retaining the ability to sandbox itself to mimimize conflicts with javascript libraries and css.


## Internationalization / Translations

Mercury has support for the following locales.  If you'd like to contribute one, the easiest way is to fork the project,
create a locale file with your translation, and submit a pull request -- that way you get full credit for your
contributions.

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


## Todo

- add a canvas region.
- figure out how to better integrate snippets.
- can we make editing content within snippets work better?
- provide a custom toolbar and functionality for the image and gallery regions.
- when using the iframe, rangy isn't behaving the same (doesn't work because it doesn't understand the context).
- selections are a little wonky on undo/redo still, and sometimes in firefox they're not applying because the checksum doesn't validate.
- finish html region.


## Dependencies

This version of Mercury is being built using jQuery 2.0, but attempts to minimize reliance on jQuery as much as is feasible, and near the end there may be a pass to remove things like $.extend. Selections in HTML regions are handled using Rangy. Check `lib/javascripts/mercury/dependencies.coffee` for a full list of dependencies.


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
rake
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
# example of extending regions to add actions for buttons or other functionality.
Mercury.MarkdownRegion.addAction 'direction', ->
  return alert("This region doesn't allow switching text direction") unless @allowDirection
  @direction = if @direction == 'rtl' then 'ltr' else 'rtl'
  @el.css(direction: @direction)
```

Now if that region has focus we can trigger the action like this:

```coffeescript
Mercury.trigger('action', 'direction')
```

### Default Actions

- bold
- italic
- underline
- subscript
- superscript
- rule
- indent
- outdent
- orderedList
- unorderedList
- style (value)
- html (html)
- block (format)
- snippet (snippet)
- file (file)
- link (url, text)
- image (url, text)


### Known issues

#### Webkit

- Dropping files at the cursor position in textarea doesn't work.

#### Gecko

- Dropping files doesn't display cursor position, and thus dropping at that place isn't applicable.
- The drop indicator doesn't like to stay visible (we could fix this by using dragover).


## License

Licensed under the [MIT License](http://opensource.org/licenses/mit-license.php)

Copyright 2012 [Jeremy Jackson](https://github.com/jejacks0n)


## Enjoy =)
