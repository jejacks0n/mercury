# Mercury Editor

[![Build Status](https://secure.travis-ci.org/jejacks0n/mercury.png?branch=master)](http://travis-ci.org/jejacks0n/mercury)
[![Dependency Status](https://gemnasium.com/jejacks0n/mercury.png)](https://gemnasium.com/jejacks0n/mercury)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jejacks0n/mercury)

Mercury Editor is a fully featured editor much like TinyMCE or CKEditor, but with a different usage paradigm.  It
expects that an entire page is something that can be editable, and allows different types of editable regions to be
specified.  It displays a single toolbar for every region on the page, and uses the HTML5 contentEditable features on
block elements, instead of iframes, which allows for CSS to be applied in ways that many other editors can't handle.

Mercury has been written using CoffeeScript and jQuery for the Javascript portions, and is written on top of Rails 3.2.


## Awesomeness

Ryan Bates has created an awesome [RailsCast](http://railscasts.com/episodes/296-mercury-editor) that walks you through
getting Mercury Editor installed, setup and working in a Rails application.  Check it out!

Mercury has been added as a Featured Project on Pivotal Tracker!  If you're interested in what's planned, check out the
[Mercury Tracker Project](https://www.pivotaltracker.com/projects/295823).


## Browser Support

Mercury has been written for the future, and thus doesn't support legacy browsers or browsers that don't follow the W3C
specifications for content editing.  Any browser will be supported if they support the W3C specification in the future,
but there aren't plans currently for adding support for alternate implementations at this time.

Supported Browsers:

- Chrome 10+
- Firefox 4+
- Safari 5+
- Opera 11.64+
- Mobile Safari (iOS 5+)


## A Demo

Feel free to check out [the demo](http://jejacks0n.github.com/mercury/).  We'll be adding a full walkthrough that goes
into detail for each of the major features.  If you would like to see how Mercury was implemented in the demo check the
[gh-pages](https://github.com/jejacks0n/mercury/tree/gh-pages) branch, it's a useful resource to see how you can
integrate the Mercury bundle into a non-rails project since it's a static site.


## The Story

I was looking for a fully featured editor that didn't use iframes to edit the content, and there weren't any decent
ones.  My primary goal was to have areas that were editable, but that also allowed CSS to flow naturally.  A few have
cropped up since then (Aloha Editor for instance), and as good as they are, none had all the features I was looking for.

Mercury was written to be as simple as possible, while also providing an advanced feature set.  Instead of complex
configuration, we chose a mix of configuration and code simplicity, which should give you a much better chance at
customizing Mercury to suit your exact needs.  This doesn't mean there's not configuration, and what's there provides
much of what you'll need, but efforts were taken to keep it simple and powerful.

Even though it's a great editor, Mercury Editor may not be the best for your needs (based on browser support,
functionality, etc.) so here's a list of some other editors that you might want to check out:

- [Aloha Editor](http://www.aloha-editor.org/)
- [jHtmlArea](http://jhtmlarea.codeplex.com/)
- [MarkItUp](http://markitup.jaysalvat.com/home/)
- [TinyMCE](http://tinymce.moxiecode.com/)
- [CKEditor](http://ckeditor.com/)
- [NicEdit](http://nicedit.com/)
- [Raptor Editor](http://www.raptor-editor.com/)


## Features

The feature list is actually pretty long, so here's a short list that should be highlighted.

- Previewing: Preview content while you're working to see exactly how it'll look.
- Link Tools: Insert and edit links, including TOC/Bookmark links.
- Media Tools: Insert and edit images, youtube videos, and vimeo videos.
- Image Uploading: Drag images from your desktop and they'll be automatically uploaded and inserted.
- Table Editing: Advanced table editing and creation, including support for multiple column and rows spans.
- Snippets: Insert and edit predefined and reusable bits of markup/code using drag and drop.
- Custom Regions: We provide Full HTML, Markdown, Snippet, Image, and Simple region types by default.
- I18n: Built in low profile translation and internationalization system.


## Installation

### For Rails

Include the gem in your Gemfile and bundle to install the gem.

    gem 'mercury-rails'

You can also get the configuration file and overrides by running the install generator.

    rails generate mercury:install

This generator puts a mercury configuration file into your project in /app/assets/javascripts/mercury.js.  This file
also functions as a manifest using sprockets `require` to include dependencies.  The install generator can optionally
install the layout and css files.

#### Image Processing / Uploading

Mercury has a basic facility for allowing image uploads, and we provide a generator that can act as a starting point for
your own back end integration.  To install run the generator.

    rails generate mercury:install:images

For Mongoid + MongoDB, you can use the `--orm=mongoid` option on the generator to get the appropriate model added to
your app.  This generator also puts paperclip (and mongoid_paperclip if needed) into your Gemfile, so make sure to
`bundle` or make your own adjustments.

If you're using ActiveRecord, make sure to migrate your database.  You can also disable this feature entirely in the
mercury configuration if you don't plan on allowing image uploading.

#### Authentication

Mercury provides a generator for giving you a basic authentication implementation.  You can run this generator and write
your own logic into the authentication file it provides.

    rails generate mercury:install:authentication

This provides a simple method for restricting the actions in the default MercuryController to only users who have the
required privileges.  Since this can vary largely from application to application, it's a basic approach that assumes
you'll write in what you want.

### For Non-Rails Environments

[Download the zip file](https://github.com/downloads/jejacks0n/mercury/mercury-v0.9.0.zip), and then follow the
installation instructions on the [wiki article](https://github.com/jejacks0n/mercury/wiki/Using-Mercury-without-Rails).


## Usage

There's a glob route that captures everything beginning with `/editor`, so for instance to edit an `/about_us` page, you
should access it at the `/editor/about_us` path.

For performance reasons you may also want to notify Mercury when the page is ready to be initialized.  To do this just
trigger the initialize:frame event from within your normal application layouts.  You can do this when the DOM is ready
to be interacted with (eg. dom:loaded, document.ready), or at the bottom of your body tag.  It's recommended that you do
this because it gives you some load performance improvements, but it's not required.

    jQuery(parent).trigger('initialize:frame');

Mercury has an expectation that content regions will be on the page (not required, but probably useful).  To define
content regions that Mercury will make editable you need to add a `data-mercury` attribute to an element.  This
attribute is used to specify the region type.  Mercury provides some default region types, but you can also create your
own.  Region types are outlined below, and the available values for the `data-mercury` attribute are:

- full
- simple
- markdown
- snippets
- image (should only be applied to img tags)

It's important for saving that an id attribute *always* be set on regions, so you should always include one.

    <div id="primary" data-mercury="full">
      default content
    </div>

For more advanced ways to integrate Mercury Editor with your Rails application (such as not using the /editor routing prefix) check out this
[wiki article](https://github.com/jejacks0n/mercury/wiki/Rails-Integration-Techniques).

### Using Mercury without Rails

If you're looking to use Mercury without Rails, you should start by checking this
[wiki article](https://github.com/jejacks0n/mercury/wiki/Using-Mercury-without-Rails).


## Region Types

### Full Region

Full regions are for full HTML markup and utilize the HTML5 contentEditable feature.  These are the core of what
Mercury does, and provide the most flexibility and visual representation of what the content will look like when saved.

### Simple Region

Simple regions are designed for plain text.  Newlines and markup are not allowed.  Simple Regions are appropriate for
titles, headlines, or any area where you want the content to be editable but not the style.

### Markdown Region

Markdown regions are based on Markdown syntax (specifically the github flavored version), and aren't as full featured as
the full region type -- primarily because Markdown is meant to be simple.  To keep it simple you can't do things like
set colors etc.  This region type is useful if you want to keep the markup clean and simple.

### Snippets Region

Snippet regions only allow snippets and don't have a concept of content editing within them.  Snippets can be the way to
go with complex markup and functionality, and are basically chunks of reusable markup that can be defined by a developer
and placed into content regions later.  More on this below.

### Image Region

The image region type should only be applied to an image tag.  It results in the image being drag-and-drop replacable.
This differs from the image handling in full regions, in that no content is in the area.  This works well for logos
and images you want to display with careful layout, and do not need any content functionality.


## Loading / Ready State

When Mercury loads it will fire an event telling the document that it's initialized, available and ready.  You can do
several things once Mercury is loaded, and we expose as many ways to do this as possible.  You can bind to the event
using jQuery, Prototype, or Mercury directly.  Or if you'd prefer you can just create a method and Mercury will call
that when it's ready.

#### jQuery

    jQuery(window).on('mercury:ready', function() { Mercury.saveUrl = '/content'; });

#### Mercury

    if (parent.Mercury) {
      parent.Mercury.on('ready', function() { Mercury.saveUrl = '/content'; });
    }

#### Function Declaration

    function onMercuryReady() { Mercury.saveUrl = '/content'; }

#### Prototype

    Event.observe(window, 'mercury:ready', function() { Mercury.saveUrl = '/content'; });


## Snippets

Snippets are reusable and configurable chunks of markup.  They can be defined by developers, and then placed anywhere in
content regions that support them.  When you drag a snippet into a region you'll be prompted to enter options, and after
entering options the snippet will be rendered into the page as a preview.  Snippets can be dragged around (in
snippets regions), edited or removed.

Mercury does very little to save content and snippets for you, but it does provide the ability to load snippets from
your own storage implementation.  Here's an example of loading existing snippet options back into Mercury using jQuery.

    jQuery(window).on('mercury:ready', function() {
      Mercury.Snippet.load({
        snippet_1: {name: 'example', options: {'favorite_beer': "Bells Hopslam", 'first_name': "Jeremy"}}
      });
    });

Snippet contents (when saved) are removed from the content.  Their options and their placement does come through in the
content however, and you're responsible for rendering your own snippet content when the page is being rendered.  You can
read more on the [wiki article about snippets](https://github.com/jejacks0n/mercury/wiki/Snippets).


## Reinitializing Regions

If you're using things like history.pushState, pjax, or just simply dynamically replacing / loading new content into
your pages, you can reinitialize regions afterwards by using:

    Mercury.trigger('reinitialize')

This will find any new regions and initialize them, leaving the existing ones intact.  There's more details that you'll
need to understand before taking advantage of all the possible features, but this will likely work for most cases.

In more advanced cases, you may want to load new snippets, and potentially prompt to save the contents before loading
the new content -- so content isn't lost.  The handling of these aspects is up to you, as Mercury can't know if an ajax
request will try to dynamically replace or load new content.


## Saving Content / Rendering Content

Note: Mercury doesn't implement saving or rendering of content.  We leave this part up to you because it can vary in so
many ways.  You may want to implement content versioning, use a nosql data store like mongo etc. and we don't want to
force our opinions.

Mercury will submit JSON or form values back to the server on save, and this can be adjusted in the configuration.  By
default it will use JSON, that JSON looks like:

    {
      "region_name": {
        "type": "full",
        "value": "[contents with a snippet]",
        "snippets": {
          "snippet_1": {
            "name": "example",
            "options": {
              "options[favorite_beer]": "Bells Hopslam",
              "options[first_name]": "Jeremy"
            }
          }
        }
      }
    }

Where it gets saved to is also up to you.  By default it submits a post to the current url, but you can adjust this by
setting Mercury.saveUrl, or passing it into the Mercury.PageEditor constructor.  How you do this is dependent on how
you're using loading mercury (via the loader, or by using the route method).  In both situations setting Mercury.saveUrl
is the most consistent.

    jQuery(window).on('mercury:ready', function() {
      Mercury.saveUrl = '/contents';
    });

Assuming you have a ContentsController and a RESTful route, this will make it through to the create action.  Where you
can store the content in whatever way you think is appropriate for your project.

Rendering content is up to you as well.. Now that you have content saved, you can add that content back to your pages,
and there's a lot of ways you could approach this.  In the past I've used Nokogiri to find and replace the contents of
regions, and do some additional handling for putting snippets back into the content.  You could also use regular
expressions to do this, which is probably faster, but maybe not as safe.

I'm interested in what solutions people are looking for and end up using for this, so feel free to shoot me a line if
you write something (eg. a middleware layer, an nginx module, or just something simple to get the job done).


## Images

The toolbar images have been created by the awesome [Mode Set](http://modeset.com/) guys (using
[GLYPHICONS](http://www.glyphicons.com/)).  They follow a simplistic design aesthetic to minimize the complexity of
creating / finding your own.  You're welcome to contribute your own to the PSD that can be found within the project so
others can potentially build from or use your own contributions.


## Internationalization / Translations

Mercury has support for the following locales.  If you'd like to contribute one, the easiest way is to fork the project,
create a locale file with your translation, and submit a pull request -- that way you get full credit for your
contributions.

Some [examples are here](https://github.com/jejacks0n/mercury/tree/master/app/assets/javascripts/mercury/locales),
and there's more on the [wiki page](https://github.com/jejacks0n/mercury/wiki/Localization-&-Translations).

Translations and contributors:
- Arabic ([mohamagdy](https://github.com/mohamagdy))
- Danish ([martinjlowm](https://github.com/martinjlowm))
- German ([poke](https://github.com/poke))
- Spanish ([javiercr](https://github.com/javiercr))
- French ([adamantx](https://github.com/adamantx))
- Italian ([gcastagneti](https://github.com/gcastagnet))
- Korean ([dorajistyle](https://github.com/dorajistyle))
- Dutch ([kieranklaassen](https://github.com/kieranklaassen))
- Portuguese ([yakko](https://github.com/yakko))
- Swedish ([stefanm](https://github.com/stefanm))
- Simplified Chinese ([董劭田 DONG Shaotian](https://github.com/richarddong))
- Hungarian ([egivandor](https://github.com/egivandor))
- Russian ([ilyacherevkov](https://github.com/ilyacherevkov))

To add translations to your installation you'll first need to turn it on in the configuration and set the prefered
locale to one of those that's listed above (eg. `fr-CA`, or `pt-BR`).  All you have to do after that is include the
locale you want to use.  You can do this in the configuration file directly using a sprockets `require` statement.
Examples are provided.


## Project Details

### WYSIWYG Editors Suck

They just do.  Which as I've learned, is primarily due to the browser implementations.  Don't get me wrong, what the
browsers have implemented is amazing, because it's hard stuff, plain and simple.  But if you're expecting a WYSIWYG
editor to solve all your content problems you're wrong.  A better perception is that it will solve many of them, but
shifts some into a new area.

With that being said, Mercury tries to solve many of those issues and succeeds to a great degree, but it seems to be
nearly impossible (impractical at least) to address everything, and the browsers don't expose enough to fix some things.
This is true for every editor that I've looked into as well, and will likely just take time as the browser vendors begin
to prioritize and fix these issues.

It's important to understand this, and the details are more suited for long nerdy blog posts, so they won't be covered
here.

### The Code and Why

#### CoffeeScript

Mercury has been written entirely in CoffeeScript because it simplifies a lot of the patterns that are used, and allows
for very readable code.  The goal was to provide good readable code that could be adjusted based on need, instead of a
complex configuration that makes the code harder to understand and tweak.

#### jQuery

jQuery was used as the javascript library, but is primarily used for the selectors, traversing, and manipulating the
DOM.  Chaining is kept to a minimum for readability, and even though much of Mercury could've been written as jQuery
plugins, it was not.

#### Rails

With the asset handling that comes bundled with Rails 3.1+, Rails Engines, and the gem tools, there really wasn't any
other option.  The javascript from Mercury can be used by any back end system, and isn't limited to Rails.  Many of the
features do require a back end however, and those features would have to be written in whatever language you wanted
support for.

The coffeescript files can be found in the repo, and I would be fully supportive of anyone who wanted to add support for
different back end frameworks or languages.  There's a server specification in the wiki that will help as well.

#### Specs / Integration Tests

Mercury is fully tested using Jasmine (via Evergreen) and Cucumber.  You can clone the project to run the full suite.

    rake spec:javascripts
    rake cucumber


## License

Licensed under the [MIT License](http://creativecommons.org/licenses/MIT/)

Copyright 2012 [Jeremy Jackson](https://github.com/jejacks0n)

Icons from [GLYPHICONS](http://www.glyphicons.com/)
