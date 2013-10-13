Mercury Editor 2
================

![logo](https://pbs.twimg.com/media/BK_SVKdCYAAFXT1.jpg:large)

[![Build Status](https://travis-ci.org/jejacks0n/mercury.png?branch=mercury2)](https://travis-ci.org/jejacks0n/mercury)

Mercury Editor is a web based WYSIWYG editor, and takes a different approach than any editor out there. It provides a full framework in which you can more easily create complex regions and interfaces. In Mercury Editor, regions dictate it's toolbars, buttons, and context for highlighting buttons. This simplifies the configuration, and provides more flexibility in terms of defining your own custom functionality that doesn't fit into the standard Mercury Editor features.

Mercury Editor also provides a comprehensive plugin architecture. Plugins makes additional functionality easier to write, test, and maintain -- and allows for a more consistent way to provide it to others.


## Developer Notice

This branch represents the future version of Mercury Editor. This iteration of Mercury Editor (Mercury2) separates the Rails portions from the Javascript portions of the project. Rails is still used for development (for a server, coffeescript, sass, build process etc.) but the Rails Engine has been moved to [mercury-rails](https://github.com/jejacks0n/mercury-rails) -- this enables more functionality, and to serve as an example of how to implement functionality like snippets and image uploading/resizing. If you're interested in integrating Mercury2 with your own platform, this is the best place to start.


## Browser Support

Mercury has been written for the future, and thus doesn't support legacy browsers or browsers that don't follow the W3C specifications for content editing. Any browser will be supported if they support the W3C specification in the future, but there aren't plans currently for adding support for alternate implementations at this time.

Supported Browsers:

- Chrome 27
- Firefox 22 (currently in beta)
- Opera 12
- Safari 6.0.4
- Mobile Safari
- IE10? (need a VM with Win7/IE10 to check -- can't install my DVD copy on my Macbook Pro because it doesn't have a DVD drive)


## Usage

**NOTE:** this is likely to change and be expanded on.

If you're using Mercury2 with Rails, you should check out the [mercury-rails](https://github.com/jejacks0n/mercury-rails) project. You should ignore these steps and use the ones provided there.

If you want to use the raw assets grab them from [the distro](https://github.com/jejacks0n/mercury/tree/mercury2/distro), or download the [current version]() (not available yet) as a compressed package. Older versions are available as [compressed packages]() (not available yet) as well.

### Installation

Start by loading the general dependencies (changing paths as needed). The only required dependency is jQuery (1.8+), and in this example we'll use jQuery 2.0.

```html
<link href="mercury.bundle.css" media="screen" rel="stylesheet" type="text/css">
<script src="dependencies/jquery-2.0.0.js" type="text/javascript"></script>
<script src="dependencies/liquidmetal-1.2.1.js" type="text/javascript"></script> <!-- optional, used for filtering lists -->
<script src="mercury.min.js" type="text/javascript"></script>
```

It's worth noting that if you don't use the css bundle, you'll need to update the css to point to the correct font path and have those servable as well.

Mercury2 Regions are broken out from the main javascript file, which allows you to have whatever you want while not having regions you don't want. Each region can have it's own dependencies which are documented at the top of each region javascript. Regions include their own dependencies as well, so if you don't want a region you don't have to worry about it's dependencies.

Let's say we want to use the HTML and Markdown regions.

```html
<script src="regions/markdown.min.js" type="text/javascript"></script>
<script src="regions/html.min.js" type="text/javascript"></script>
```


### Initializing

You can initialize Mercury2 any time after the DOM is ready. You can use the jQuery dom loaded callback, or initialize it at the bottom of the document. The `Mercury.init` method takes options that are passed directly to the interface class that you've configured (Mercury.FrameInterface by default).

```javascript
jQuery(function() {
  Mercury.init();
})
```


## Examples

The configuration is a good place to start reading about various options and other useful tidbits. The configuration is at the top of the main `mercury.js` or `mercury.min.js` file, and has default configurations for all the standard regions as well -- you can [read more about the configuration options here](https://github.com/jejacks0n/mercury/blob/mercury2/lib/javascripts/mercury/config.coffee).

There's [several examples](https://github.com/jejacks0n/mercury/tree/mercury2/examples) of how to integrate more complex features directly in the project, and the [gallery region](https://github.com/jejacks0n/mercury/blob/mercury2/lib/javascripts/mercury/regions/gallery.coffee) is a good place to start reading if you're planning on writing custom regions.

There's an example for how to [sandbox using an iframe](https://github.com/jejacks0n/mercury/blob/mercury2/examples/frame.haml) and for more complex integrations check the [developer interface example](https://github.com/jejacks0n/mercury/blob/mercury2/examples/assets/developer_interface.coffee) which outlines many of the events and API, and if you're planning on adding functionality there's some examples of [how to add your own toolbars and actions, or write simple plugins](https://github.com/jejacks0n/mercury/blob/mercury2/examples/assets/functionality_adding.coffee).

An example of server integration is available in the [mercury-rails](https://github.com/jejacks0n/mercury-rails) project, which outlines all of the features that are needed by the server to fully work with the default regions.


## Standard Events

Since Mercury2 has a basic framework this list only includes the core events. Additional events could be added by plugins, custom regions, and views.

To bind to global events use `Mercury.on` or `Mercury.one`, eg. `Mercury.on('focus', function() { alert('Mercury was focused') })`. If you're binding to view, model, or snippet events you should use the `instance.on` method to bind to events. All region events are triggered both on the region instance, and globally as `region:[eventname]` with the first argument being the region instance -- this allows you to bind to region events for all regions should you need to.

### Public Events
- **focus** - focuses mercury, which will refocus the last region to have focus
- **blur** - blurs mercury
- **save** - initializes the save process (eg. calls Mercury.interface.save)
- **initialize** - tells mercury that the document is ready to be initialized (build interface/find regions)
- **reinitialize** - tells mercury that new regions might have been added and to find them
- **toggle** - toggles the interface
- **show** - shows the interface (does nothing if the interface is showing)
- **hide** - hides the interface (does nothing if the interface is hidden)
- **mode** - toggles a given mode (modes: preview -- eg. Mercury.trigger('mode', 'preview'))
- **action** - provides an action for Mercury -- typically processed by the focused region

### Global Events
- **configure** - triggered on Mercury.init and Mercury.configure
- **released** - triggered on Mercury.release
- **save:complete** - triggered on successful save ajax request

### Model Events
- **init** - triggered when a model is initialized
- **save** - triggered when the model save ajax request is successful
- **error** - triggered when the model save ajax request fails

### Snippet Events
- **rendered** - triggered when a snippet is rendered (can happen on undo/redo actions)

### View Events
- **build** - triggered when building / initializing

### Region Events
- **action** - triggered when an action is handled (global: region:action)
- **update** - triggered whenever a possible change could be made within in a region (includes focus - global: region:update)
- **preview** - triggered when the region is going into or coming out of preview mode (global: region:preview)
- **release** - triggered when the region is being released (global: region:release)
- **focus** - triggered when the region is focused (call instance.focus to manually focus a region - global: region:focus)
- **blur** - triggered then the region is blurred (call instance.blur to manually blur a region - global: region:blur)


## Sandboxing & The Shadow Dom

Mercury2 allows sandboxing content within an iframe or it can load directly on the page you're editing. This has been a complication in the past, so this version simplifies that while also retaining the ability to sandbox itself to mimimize conflicts with javascript libraries and css.

The iframe support has also been simplified and expects that you pass an iframe (or selector) when initializing using the FrameInterface. This allows you to determine what url is loaded, and simplifies the save process.

Mercury2 also now has support for moving it's interface into a [Shadow DOM](http://glazkov.com/2011/01/14/what-the-heck-is-shadow-dom), which removes the interface from the dom on the page that you're editing, which helps to alleviate conflicts on the page with other javascript and css, but isn't as reliable as using an iframe nor as widely supported.


## Fonts & Graphics

Mercury2 uses two custom fonts for all graphic elements in the interface. This allows for retina support, makes it easier to package, and allows it to be more customizable long term.

The primary toolbar icons and general interface graphics are in the `mercury-icons` font, which is generated using fontcustom and svg images -- several of the glyphs came from the awesome [IcoMoon project](http://icomoon.io/app/) (by [Keyamoon](https://twitter.com/keyamoon)).

The toolbar icons (bold, italics, etc.) are in the `mercury-toolbars` font, which was built using [fontstruct.com](http://fontstruct.com/). [The original font](http://fontstruct.com/fontstructions/show/797530) can be cloned and edited as needed. Fontstruct is used for this font because it allows for small pixel fonts but also allows for more advanced shapes that scale nicely.

Other graphics (there are only a few) are small images that have been base64 encoded and embedded into the css to simplify installation. You can change these images by overriding the classes where they're used and providing your own.


## I18n / Translations

Mercury2 has support for the following locales.  If you'd like to contribute one, the easiest way is to fork the project, create a locale file with your translation, and submit a pull request -- that way you get full credit for your contributions.

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


## Modules

A little complex, but worth documenting so it can be utilized well. Mercury ships with the concept of modules, and the first time I saw this concept was in Spine.js. Modules are bits of code (an object), that can be mixed into another object, class, the prototype of an object/class, or can be included in a single instance.

Any class that inherits from (aka extends) Mercury.Module will get a few methods/properties. The `extend`, `include` methods, and the ability to specify a `mixins` array.

When you `extend` a class it will add class level methods, and when you `include` a module it will add it to the classes prototype (so every instance of that class ever) and this may or may not be desired so you can also specify the `mixins` array as a class or instance property. If you use the mixins array, the modules will be "included" during instantiation, and will not be added to the object prototype.

Note: The objects that you pass to these methods are usually defined elsewhere, but for brevity this example just shows a simple object.

```coffeescript
class Animal extends Mercury.Module
  @extend foo: ->
  @include bar: ->
```

The Animal class will have a `foo` class method, and a `bar` "instance" method. Anything inheriting from Animal will also have these methods.

```coffeescript
class Dog extends Animal
  @include baz: ->
  mixins: [qux: ->]
```

Dog will have the same `foo` and `bar` methods as Animal, but it will also have the `baz` method.. and so will anything inheriting from Animal because the prototype is shared. This is where the mixins array comes in. Dog will have an instance method `qux`, but it won't make it onto the prototype, and so, is restricted to any instance of the Dog class.

Check [module.coffee](https://github.com/jejacks0n/mercury/blob/mercury2/lib/javascripts/mercury/core/module.coffee) for more comments and some code. And the various modules in [lib/mercury/views/modules](https://github.com/jejacks0n/mercury/tree/mercury2/lib/javascripts/mercury/views/modules), for several examples of how modules can be defined and used.


## Dependencies

Mercury2 was built using jQuery 1.9.1/2.0, but attempts to minimize reliance on jQuery as much as is feasible.

Each region can also have it's own dependencies, which is entirely up to the author. If you're writing a custom region it's expected to document the dependencies and version information.


## Contributing

Awesome! Please [check here](https://github.com/jejacks0n/mercury/blob/mercury2/CONTRIBUTING.md).


## Known issues

### Webkit

- Dropping files at the cursor position doesn't work.
- When using the shadow dom the jQuery 'focusout' event doesn't fire so focus can be restored to a region when in a dialog / modal.

### iOS

- Fixed positioning doesn't work correctly, so it's advised to use the floating interface. This also sometimes effects dialogs.
- iOS reports that it supports the shadow dom, but it doesn't.

### Gecko

- Dropping files doesn't display cursor position, and thus dropping at that place isn't applicable.

### Opera

- onBeforeUnload doesn't work properly (isn't able to ask before navigation after changes have been made).
- Outline styles obscure the mercury interface (problem with z-index+position:fixed+outline css)


## Consulting

I'm available for hire. If you need help implementing, enhancing, or integrating Mercury Editor this might be a worth while option. I don't always have time for freelance/consulting work, so I recommend [Mode Set](http://modeset.com), a small consultancy with amazing folks where I work -- many of the developers there are familiar with Mercury, and it's easier for me to dedicate my days to your issues rather than my evenings.


## License

Licensed under the [MIT License](http://opensource.org/licenses/mit-license.php)

Copyright 2012 [Jeremy Jackson](https://github.com/jejacks0n)


## Enjoy =)
