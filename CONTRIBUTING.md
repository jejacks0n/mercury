Contributing to Mercury Editor2
===============================

I'm looking to form a team or organization of like minded individuals who are willing to and can contribute to Mercury Editor and grow the community. I enjoy writing code alone, but I also enjoy the benefits of teamwork and other peoples ideas. If you're interested drop me a line, and I'll add you to the mailing list. This invitation isn't solely for developers and extends to designers, translators, support people, or anyone who thinks there's something to learn from contributing to open source. Those that contribute regularly will be invited to the mailing list and will get commit rights.


## Filing a Bug

To ensure that the issue isn't wasting anyone's time, and to increase the likelihood that it's addressed quickly please:

1. Submit a failing test along with the issue, or
2. A step by step walk through to recreate the issue
3. Provide [system details](http://www.supportdetails.com/).


## Contributing Code

Awesome! Just fork the project, follow the development steps below (modifying the repo to reflect your own). Write code + specs, making sure all the specs pass, push, and then submit a pull request. To greatly increase the chances that your pull request is merged, and that you don't waste your time, it's best to follow the steps outlined here.

1. Post an issue outlining what you plan on doing prior to working on it. It's good to check that no one else has plans to do what you're thinking about, and that people agree with your thinking or have advice.
2. If it's something worth testing please provide tests to go along with your code.
3. Make sure all tests are passing across all supported browsers.
4. Update appropriate documentation or wiki articles before / after the pull request is merged.
5. Push changes to your fork and submit a pull request!


## Development

Development requires Ruby for the server, tests, and build process. Here's some information about [Installing Ruby](http://www.ruby-lang.org/en/downloads/).

Clone the project.
```shell
git clone https://github.com/jejacks0n/mercury
git checkout mercury2
```

Install the required gems (you may have to run `gem install bundler`).
```shell
bundle install
```

You can start the server and browse to http://localhost:9292 to do regression testing and see how the application works.
```
rackup
```

Run specs / build distro (on passing specs).
```shell
bundle exec rake
```

Run specs with coverage reports.
```shell
bundle exec teaspoon --coverage
```


