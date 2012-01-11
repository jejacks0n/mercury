# Mercury Editor

Mercury Editor is a fully featured editor much like TinyMCE or CKEditor, but with a different usage paradigm.  It
expects that an entire page is something that can be editable, and allows different types of editable regions to be
specified.  It displays a single toolbar for every region on the page, and uses the HTML5 contentEditable features on
block elements, instead of iframes, which allows for CSS to be applied in ways that most other editors can't handle.

Mercury has been written using CoffeeScript and jQuery for the Javascript portions, and is written on top of Rails 3.1.


## Translations

Hey international open source contributors, want to contribute to the Mercury Editor project without having to do much
coding?  We're looking for good translations.  If you have a good grasp of english, another language, and have the
desire and time to do a translation for the project it would be awesome to hear from you.  The easiest way to submit is
to fork the project, create a locale file with your translation, and submit a pull request -- that way you get full
credit for your contributions.

Some [examples are here](https://github.com/jejacks0n/mercury/tree/master/vendor/assets/javascripts/mercury/locales),
and there's more on the [wiki page](https://github.com/jejacks0n/mercury/wiki/Localization-&-Translations).

- French (provided by [adamantx](https://github.com/adamantx))
- Spanish (provided by [javiercr](https://github.com/javiercr))
- Portuguese (provided by [yakko](https://github.com/yakko))
- Dutch (provided by [kieranklaassen](https://github.com/kieranklaassen))


## Awesomeness

Ryan Bates over at the awesome [railscasts site](http://railscasts.com) has put together a really nice RailsCast that
walks you through getting Mercury Editor installed, setup and working in a Rails 3.1.1 application.  It's definitely
worth checking out.  [Watch the RailsCast](http://railscasts.com/episodes/296-mercury-editor)

Mercury has been added as a Featured Project on Pivotal Tracker!  If you're interested in what's planned, check out the
[Mercury Tracker Project](https://www.pivotaltracker.com/projects/295823).


## Browser Support

Mercury has been written for the future, and thus doesn't support legacy browsers or browsers that don't follow the W3C
specifications for content editing.  Any browser will be supported if they support the W3C specification in the future,
but there aren't plans for adding support for alternate implementations at this time.

Supported Browsers:

- Chrome 10+
- Safari 5+
- Firefox 4+


## A Demo

Feel free to check out [the demo](http://jejacks0n.github.com/mercury/).  The demo will be updated quite a bit in the
next weeks, so feel free to check back every now and then.. We'll be adding a full walkthrough that details each of the
major features shortly.  If you would like to see how Mercury was implemented in the demo check the gh-pages branch,
it's a useful resource to see how you can integrate the Mercury bundle.


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


## Features

The feature list is actually pretty long, so here's a short list that need highlighting.

- Previewing: Preview content while you're working to see exactly how it'll look.
- Link Tools: Insert and edit links, including TOC/Bookmark links.
- Media Tools: Insert and edit images, youtube videos, and vimeo videos.
- Image Uploading: Drag images from your desktop and they'll be automatically uploaded and inserted.
- Table Editing: Advanced table editing and creation, including support for multiple column and rows spans.
- Snippets: Insert and edit predefined and reusable bits of markup/code using drag and drop.
- Custom Regions: We provide Markdown, HTML, and Snippet region types by default.
- I18n: Built in low profile translation and internationalization system.


## Installation

### For Rails

Include the gem in your Gemfile and bundle to install the gem.

    gem 'mercury-rails'

You can also get the configuration file, css, and routes by running the generator.

    rails generate mercury:install

This generator puts the mercury base file (configuration) into your project in /app/assets/javascripts/mercury.js,
and includes the base mercury routes.  It can optionally install the layout and a css overrides file, models, as well as
an authentication helper that allows you to restrict access to editing.  Check the options by using `--help`.

For Mongoid + MongoDB, you can use the `--orm=mongoid` option on the generator to get the required models added to your
app.  Make sure to add `gem "mongoid-paperclip", :require => "mongoid_paperclip` to your Gemfile as well.  Thanks to
[chandresh](https://github.com/chandresh) for this tip.

If you're using ActiveRecord, make sure you get the migrations that you'll need for image uploading (if not you can
disable the feature in mercury.js if you don't want it).

    rake mercury_engine:install:migrations
    rake db:migrate

### For Mongoid + MongoDB + Paperclip (quick hack)

Add gem "mongoid-paperclip", :require => "mongoid_paperclip" to Gemfile. Now create a file app/models/mercury/image.rb with following:

class Mercury::Image
  include Mongoid::Document
  include Mongoid::Paperclip

 has_mongoid_attached_file :image

 validates_presence_of :image

 delegate :url, :to => :image

 def serializable_hash(options = nil)
   options ||= {}
   options[:methods] ||= []
   options[:methods] << :url
   super(options)
 end

end

## Usage

There's a glob route that captures everything beginning with `/editor`, so for instance to edit an `/about_us` page, you
should access it at the `/editor/about_us` path.  You may want to define this route in your own routes file to restrict
access to it (only admins or something).

For performance reasons you may also want to notify Mercury when the page is ready to be initialized.  To do this just
trigger the initialize:frame event from within your normal application layouts.  You can do this when the DOM is ready
to be interacted with (eg. dom:loaded, document.ready), or at the bottom of your body tag.  It's recommended that you do
this because it gives you some load performance improvements, but it's not required.

    jQuery(parent).trigger('initialize:frame');

Mercury has an expectation that content regions will be on the page (not required, but probably useful).  To define
content regions that Mercury will make editable you need to add a `mercury-region` class attribute to an element (this
class is configurable).  Then specify what region type by using the `data-type` attribute -- which can be *editable*,
*markupable*, or *snippetable*.  It's important for saving that an id attribute be set on regions, you should always
include one.  Region types are outlined below.

    <div id="primary" class="mercury-region" data-type="editable">
      default content
    </div>

For more advanced ways to integrate Mercury Editor with your Rails application check out this
[wiki article](https://github.com/jejacks0n/mercury/wiki/Rails-Integration-Techniques).

### Using Mercury without Rails

Check this [wiki article](https://github.com/jejacks0n/mercury/wiki/Using-Mercury-without-Rails)


## Region Types

### Editable

Editable Regions are HTML markup, and use the HTML5 contentEditable feature.  This is the core of what Mercury is about,
and provides the most flexibility and visual representation of what the content will look like when saved.

### Markupable

These regions are based on Markdown syntax (specifically the github flavored version), and isn't as full featured as the
editable region type -- primarily because markdown is meant to be simple, so to keep it such you can't do things like
set colors etc.  This region type is super useful if you want to keep the markup clean and simple.

### Snippetable

Snippetable regions only allow snippets.  There isn't any content editing in these regions, but snippets can sometimes
be the way to go with complex markup and functionality.  Snippets are basically chunks of reusable markup, that can be
defined by a developer and placed into content regions later.  More on this below.


## Loading / Ready State

When Mercury loads it will fire an event telling the document that it's initialized, available and ready.  You can do
several things once Mercury is loaded, and we expose as many ways to do this as possible.  You can bind to the event
using jQuery, Prototype, or Mercury directly.  Or if you'd prefer you can just create a method and Mercury will call
that when it's ready.

#### jQuery

    jQuery(window).on('mercury:ready', function() { Mercury.saveUrl = '/content'; });

#### Prototype

    Event.observe(window, 'mercury:ready', function() { Mercury.saveUrl = '/content'; });

#### Mercury

    if (parent.Mercury) {
      parent.Mercury.on('ready', function() { Mercury.saveUrl = '/content'; });
    }

#### Function Declaration

    function onMercuryReady() { Mercury.saveUrl = '/content'; }


## Snippets

Snippets are reusable and configurable chunks of markup.  They can be defined by developers, and then placed anywhere in
content regions.  When you drag a snippet into a region you'll be prompted to enter options, and after entering options
the snippet will be rendered into the page as a preview.  Snippets can be dragged around (in snippetable regions) and
edited or removed.

Mercury does very little to save content and snippets for you, but it does provide the ability to load snippets from
your own storage implementation.  Here's an example of loading existing snippet options back into Mercury.

    jQuery(window).on('mercury:ready', function() {
      Mercury.Snippet.load({
        snippet_1: {name: 'example', options: {'options[favorite_beer]': "Bells Hopslam", 'options[first_name]': "Jeremy"}}
      });
    });


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
many different ways.. You may want to implement content versioning, use a nosql data store like mongo etc. and we don't
want to force our opinions.

Mercury will submit JSON or form values back to the server on save, and this can be adjusted in the configuration.  By
default it will use JSON, that JSON looks like:

    {
      "region_name": {
        "type": "editable",
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

Where it gets saved to is also up to you.. by default it submits a post to the current url, but you can adjust this by
setting Mercury.saveURL, or passing it into the Mercury.PageEditor constructor.. how you do this is dependent on how
you're using loading mercury (via the loader, or by using the route method).  In both situations setting Mercury.saveURL
is the most consistent.

    jQuery(window).on('mercury:ready', function() {
      Mercury.saveURL = '/contents';
    });

Assuming you have a ContentsController and a RESTful route, this will make it through to the create action.  Where you
can store the content in whatever way you think is appropriate for your project.

Rendering content is up to you as well.. Now that you have content saved, you can add that content back to your pages,
and there's a lot of ways you could approach this.  In the past I've used Nokogiri to find and replace the contents of
regions, and do some additional handling for putting snippets back into the content.  You could also use regular
expressions to do this, which is probably faster, but maybe not as safe.

I'm interested in what solutions people are looking for and end up using for this, so feel free to shoot me a line if
you write something (eg. a middleware layer, an nginx module, or just something simple to get the job done).


## Adding Authentication

When you install Mercury using the generator (`rails g mercury:install`) you can optionally install an authentication
file into your application (at `lib/mercury/authentication.rb`).  This is a simple method for restricting the actions in
the MercuryController to only users who have the required privileges.  Since this can vary largely from application to
application, it's a basic approach that lets you write in what you want.


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

With the asset handling that comes bundled with Rails 3.1, Rails Engines, and the gem tools, there really wasn't any
other option.  The javascript from Mercury can be used by any back end system, and isn't limited to Rails.  Many of the
features do require a back end, and those features would have to be written in whatever language you wanted support for.
The coffeescript files can be found in the repo, and I would be fully supportive of anyone who wanted to add support for
different back end frameworks or languages.  There's a server specification in the wiki that will help as well.

#### Specs / Integration Tests

Mercury is fully tested using Jasmine (via Evergreen) and Cucumber.  You can clone the project to run the full suite.

    rake spec:javascripts
    rake cucumber


## License

Licensed under the [MIT License](http://creativecommons.org/licenses/MIT/)

Copyright 2011 [Jeremy Jackson](https://github.com/jejacks0n)
