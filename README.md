Mercury Editor2
===============

## Developer Notice

This branch represents the future version of Mercury Editor. It outlines the framework that will be used and is more in line with the MVC/MVVM frameworks that exist.

This iteration of Mercury Editor (Mercury2) will separate the Rails portions from the Javascript portions of the project. Rails is still used for development (for a server, coffeescript, sass, build process etc.) but the Rails Engine will be broken off into a different project so that more functionality can be added, and to serve as an example of how to implement functionality like snippets and image uploading.

Mercury2 allows sandboxing content within an iframe or can load directly on the page you're editing. This has been a point of contention and complication in the past, so this version attempts to simplify while also keeping the ability to sandbox itself to mimimize conflicts with javascript libraries and css.


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

### Actions

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
