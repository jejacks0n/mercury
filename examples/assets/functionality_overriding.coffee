# Overriding functionality.
#
# This file provides examples on how to change functionality that Mercury has by default.
#
# We assign window.Mercury to parent.Mercury in case we're being loaded in an iframe where Mercury isn't being loaded.
#
@Mercury ||= parent.Mercury

# Saving - Customizing how saving works
#
# One of the things that was learned from Mercury1, was that saving wasn't flexible enough. Mercury2 tries to make that
# considerably nicer in terms of configuration, but if that doesn't cover your needs there's a few things that you can
# do.
#
# If you just need a dynamic way to specify the save url, you can set the URL that the page is saved to by adjusting the
# configuration manually.
#
Mercury.configure('saving:url', '/mercury/save')

# If you need something more complex than that, you can take over the entire ajax request by injecting additional
# functionality into the Page model. There's several ways to accomplish this, so here's a few that Mercury provides, but
# if you wanted to you could just set Mercury.Model.Page.prototype manually.
#
# The first is to use the Mercury.Module.include method, which adds or overrides the instance/prototype methods.
#
# Note: this example is overridden by examples below.
#
Mercury.Model.Page.include
  save: -> alert('this is a custom save method')

# The second way that Mercury exposes mixing additional functionality in is with the mixin method. Like the `include`
# example above, it's a method that exists on Mercury.Module, and since most things inherit from Mercury.Module, you
# will find these methods on most, if not all of the classes you'll want to interact with. With the `mixin` method you
# can provide both class, and instance level methods. This overrides the save method like above, but also adds a class
# method that we can call with Mercury.Model.Page.save(). If you just want to add class level methods you can use
# `extend`, which works the same way `include` does, but assigns them at the class level.
#
# Note: this example is overridden by examples below.
#
Mercury.Model.Page.mixin
  klass:
    save: -> alert('class method called')
  save: -> alert('instance method called')

# If you're sort of old-school, or hipster, here's an example that will set things back to the way they were using
# prototype, which may not be as pretty, but definitately fix-gear level cool.
#
Mercury.Model.Page.prototype.save = (options = {}) ->
  Mercury.Model.prototype.save.call(@, $.extend(@config('saving'), options))

# And finally, if you're using CoffeeScript, you can just reopen the class and do whatever else we wanted. This may be
# a little nicer since you can use `super` within methods.
#
class Mercury.Model.Page extends Mercury.Model.Page
  @save: -> @all()[0].save()
  save: -> super.success(-> confirm('saved!'))
