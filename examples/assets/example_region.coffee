# Custom Regions
#
# There's a lot that Mercury does to make writing custom regions easier, but it's inherently hard, especially when you
# get into the differences between browsers and HTML editing. If you're writing your own regions you have to understand
# a good amount of Javascript and/or coffeescript, and the differences between browsers.
#
# With that being said, they basically a view with more functionality. You're responsible for large parts of the
# process, but we've provided several examples and modules that you can use to better understand how to tackle some of
# the more complex aspects. A good place to start with understanding Regions is to read the comments in the
# core/region.coffee file. You may also want to check out the regions/gallery.coffee file because that region is
# provided as a more complex example of how you can write custom regions.
#
# Here we're going to make a really simple region that is sort of like a button. It's styled very simply, and an editor
# can change the background color as well as the text color of the region. It allows bold, italics, and underline.
#
# It inherits from the plain region, which will give us some html editing, but also restricts anything complex -- eg.
# pasting, drag/drop, etc. It's really just a way to capture some colors and some text for a button.
#
# When this region is serialized it will return the color/bgcolor in the data, and will have the "value" of the button.
#
class Mercury.Region.Button extends Mercury.Region.Plain

  # Every regions must define their name, and type. This is used for logging and allowing it to be used by elements on
  # the page. You can replace regions by defining the same type as an existing region if you want to add/remove
  # functionality.
  #
  @define 'Mercury.Region.Button', 'button'

  # This is a way to determine if the region is supported in the current client. Since this region is an example and
  # isn't intended to be used, it sets this to true -- but this is a way that you can do browser detection to see if a
  # given region is supported.
  #
  @supported: true


# Each region is responsibile for adding an initial toolbar. This allows others to modify the toolbar to add/remove
# buttons based on functionality that they may have added to the region externally. Refer to the
# functionality_adding.coffee for more information.
#
Mercury.Region.Button.addToolbar

  style:
    color:   ['Color', plugin: 'color']                             # provides button for changing the text color
    sep:     ' '                                                    # separator -- so the buttons aren't a group
    bgcolor: ['Background Color', plugin: 'color']                  # provides button for changing the background color


# Regions can define actions for themselves as well. This is a common way to extend regions as well, and is covered in
# the functionality_adding.coffee file. Here we just add actions for color and bgcolor, which set data -- this data can
# then be used to style the element, but also to serialize back to the server on save.
#
Mercury.Region.Button.addAction

  color: (val) -> @data(color: val)
  bgcolor: (val) -> @data(bgcolor: val)


# As you can see above, we're calling #data with {color: val} and {bgcolor: val} from the action handlers. When you set
# data Mercury will look for data handlers for that specific attribute. So basically when you trigger an action with the
# name 'bgcolor', it will first be handled by our action, and then will make it through to our data handler -- where we
# can then style the element as needed. In this case just color and background. You could be more specific and set
# backgroundColor, but meh, all that is up to you.
#
Mercury.Region.Button.addData

  color: (val) -> @css(color: val)
  bgcolor: (val) -> @css(background: val)


# In addition to setting the color and background color we want to display that information in our buttons. Some buttons
# don't have context, and some buttons do. In the case of color palette buttons (from the color plugin) we need to
# return the actual value of that css property -- some contexts only care about being true/false -- but the color one is
# special.
#
Mercury.Region.Button.addContext

  color:     -> @css('color')
  bgcolor:   -> @css('backgroundColor')
