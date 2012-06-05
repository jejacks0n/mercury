Feature:
  As a developer
  In order to use Mercury
  I should be able to use a generator to install configuration and overrides into my application

  Scenario: I can install the Mercury configuration file
    Given I have created a new rails application
    When I run `bundle exec rails generate mercury:install --trace` interactively
    And I type "N"
    Then the following files should exist:
      | app/assets/javascripts/mercury.js             |
    And the file "config/routes.rb" should contain "mount Mercury::Engine => '/'"

  Scenario: I can install the configuration file and overrides
    Given I have created a new rails application
    When I successfully run `bundle exec rails generate mercury:install --full --trace`
    Then the following files should exist:
      | app/assets/javascripts/mercury.js             |
      | app/assets/stylesheets/mercury_overrides.css  |
      | app/views/layouts/mercury.html.erb            |
    And the file "config/routes.rb" should contain "mount Mercury::Engine => '/'"
