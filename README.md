# Mercury Editor

Mercury Editor is a fully featured editor much like TinyMCE or CKEditor, but with a different usage paradigm.  It
expects that an entire page is something that can be editable, and allows different types of editable regions to be
specified.  It displays a single toolbar for every region on the page, and uses the HTML5 contentEditable features on
block elements, instead of iframes, which allows for CSS to be applied in ways that most other editors can't handle.

Mercury has been written using CoffeeScript and jQuery for the Javascript portions, and is written on top of Rails 3.1.


## Translations

Hey international open source contributors, want to contribute to the Mercury Editor project without having to do much
coding?  We're looking for good translations.  If you have a good grasp of english, another common language, and have
the desire and time to do a translation for the project it would be awesome to hear from you.  Just shoot me a message
or email and I'll provide more details.  While any translation would be a good thing, the languages that seem like they
would give the most value are:

- French
- German
- Spanish
- Japanese
- Chinese
- Dutch


## Awesomeness

Mercury has been added as a Featured Project on Pivotal Tracker!  If you're interested in what's planned, check out the
public project at: https://www.pivotaltracker.com/projects/295823


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

I was looking for a fully featured editor that didn't use iframes, and there weren't any decent ones.  My primary goal
was to have areas that were editable, but that also allowed CSS to flow naturally.  A few have cropped up since then
(Aloha Editor for instance), and as good as they are, none had all the features I was looking for.

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
- Table Editing: Advanced table editing and creation.
- Snippets: Insert and edit predefined and reusable bits of markup/code using drag and drop.
- Notes: Attach notes to any page and communicate with other content authors.


## Installation

### For Rails

Include the gem in your Gemfile and bundle to install the gem.

    gem 'mercury-rails'

Make sure you get the migrations that you'll need.

    rake mercury_engine:install:migrations
    rake db:migrate

You can also get the configuration file by running the generator.

    rails generate mercury:install

This generator puts the mercury base file (configuration) into your project in /app/assets/javascripts/mercury.js.

### For Other Frameworks / Languages

Get the distro files by downloading them from github using the downloads feature, or pull them out of the project
manually (the files are in /public/mercury).  Copy the files into your project, and if you adjust where they're
located (eg. not within mercury/javascripts or mercury/stylesheets) make sure you update the
mercury_loader.js file to reflect this.

Images are bundled into the CSS if you use the mercury.bundle.css file, but if you'd rather not use the bundled CSS
you'll need to grab the images manually and adjust the paths in the css file.

The dialogs (eg. color palettes, modals, and other dialog types) are bundled into the mercury_dialogs.js file.  If you
would like to customize a view you can remove the view from the mercury_dialogs.js file and adjust the path you want to
load using the configuration -- your custom view will then load using Ajax.

Bundling snippet options and snippets doesn't work in this way, so you may need to disable snippets or adjust where
they're loaded from.. We'll see how this pans out and adjust over time if needed, so feedback would be useful here.

If you use the distro instead of using the Rails Engine, you won't be able to utilize the Route usage method outlined in
the Usage portion of this documentation.


## Usage

Mercury has an expectation that content regions will be on the page (not required, but probably useful).  To define
content regions that Mercury will make editable you need to add a `mercury-region` class attribute to a div (this is
configurable).  Then specify what region type by using the `data-type` attribute -- which can be *editable*,
*markupable*, or *snippetable*. It's important for saving that an id attribute be set on regions, you should always
include.  Region types are outlined below.

    <div id="primary" class="mercury-region" data-type="editable">
      default content
    </div>

There's two methods to initialize Mercury Editor, and each one has it's benefits and drawbacks.

### Script Method

Include the mercury_loader.js file.  The loader will reload the page and enable Mercury in full page editing mode, so
you may want to wrap this in conditional logic (eg. only admins or something).

    javascript_include_tag 'mercury_loader.js'

Even though many efforts have been made to keep conflicts with javascript libraries from happening, we can't avoid all
of them.  If you use this method, understand that there may be conflicts with javascript and css.  You should use the
route method if you see any issues.

### Route Method

The other way to initialize Mercury, which provides some slight performance improvements to the script method, is to
access the editor route.  There's a glob route that captures everything beginning with /editor, so for instance to edit
an /about_us content page, you should access it at the /editor/about_us path.  Again, you may want to define this route
in your own routes file to restrict access to it.

If you use this method, you may want to notify Mercury when the page is ready to be initialized.  To do this just
trigger the initialize:frame event.  You can do this when the dom is ready to be interacted with (eg. dom:loaded,
document.ready), or at the bottom of your body tag.  It's recommended that you do this because it gives you some load
performance improvements, but it's not required.

    Mercury.trigger('initialize:frame');


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


## Snippets

Snippets are reusable and configurable chunks of markup.  They can be defined by developers, and then placed anywhere in
content regions.  When you drag a snippet into a region you'll be prompted to enter options, and after entering options
the snippet will be rendered into the page as a preview.  Snippets can be dragged around (in snippetable regions) and
edited or removed.

Mercury does very little to save content and snippets for you, but it does provide the ability to load snippets from
your own storage implementation.  Here's an example of loading existing snippet options back into Mercury.

    if (top.Mercury) top.Mercury.Snippet.load({
      snippet_1: {name: 'example', options: {'options[favorite_beer]': "Bells Hopslam", 'options[first_name]': "Jeremy"}}
    });


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

    top.Mercury.saveURL = '/contents';

Assuming you have a ContentsController and a RESTful route, this will make it through to the create action.  Where you
can store the content in whatever way you think is appropriate for your project.

Rendering content is up to you as well.. Now that you have content saved, you can add that content back to your pages,
and there's a lot of ways you could approach this.  In the past I've used Nokogiri to find and replace the contents of
regions, and do some additional handling for putting snippets back into the content.  You could also use regular
expressions to do this, which is probably faster, but maybe not as safe.

I'm interested in what solutions people are looking for and end up using for this, so feel free to shoot me a line if
you write something (eg. a middleware layer, an nginx module, or just something simple to get the job done).


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