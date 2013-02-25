Mercury Editor
==============

This branch represents the future version of Mercury Editor. It outlines the framework that will be used (and built
upon), and at the moment provides an example of using the more structured core library for the uploading process (eg. an
uploader view, and a file model).

This approach is more in line with the MVC frameworks that exist and is comprised of a hybrid of Spine and Backbone
(neither library is used however to maintain ambiguity). Spine Controller was taken and adjusted into Mercury.View, and
a modified Spine.Model became Mercury.Model. The naming was adopted to be more like Backbone, as was the get/set methods
for model attributes. At the moment the structure is pretty minimal and will likely be added to over time as different
feature additions require (specifically Mercury.Model).


## Restructuring

This iteration of Mercury Editor will separate the Rails portions from the Javascript portions of the project.  Rails is
still used for development (for a server, coffeescript, sass, build process etc), but development will not mimic the
current version of Mercury in that the engine will be broken off into a different library so that more functionality can
be added to that, and to serve as a more useful example of how to implement functionality like snippets and image
uploading.


## Dependencies

This version of Mercury is being built with jQuery 1.9.1 and 2.0 in mind, however zepto is also being tested against.
Rangy will be used for selections, but I have yet to dive fully into figuring out how best to utilize the library.


## Development

Clone using git
```shell
git clone https://github.com/jejacks0n/mercury
git checkout mercury2
```

Install dependencies (some are already there)
```shell
bundle install
```

Run specs / build distro on passing specs
```shell
rake
```


## Contributing

Fork the project, follow the above steps (modifying the repo to reflect your own). Write code+specs, make sure tests pass, and submit a pull request.


## License

Licensed under the [MIT License](http://opensource.org/licenses/mit-license.php)

Copyright 2012 [Jeremy Jackson](https://github.com/jejacks0n)


## Enjoy =)
