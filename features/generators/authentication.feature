Feature:
  As a developer
  In order to restrict editing using Mercury
  I should be able to use a generator to setup my application

  Scenario: I can install a basic authentication template
    Given I have created a new rails application
    When I successfully run `bundle exec rails generate mercury:install:authentication --trace`
    Then the following files should exist:
      | lib/mercury/authentication.rb           |
